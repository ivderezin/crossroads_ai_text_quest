import 'dart:async';

import 'package:flutter_edge_ai/flutter_edge_ai.dart';
import 'package:flutter_edge_ai_mediapipe/flutter_edge_ai_mediapipe.dart';
import 'package:injectable/injectable.dart';

import '../llm_exception.dart';
import 'local_model.dart';
import 'on_device_engine.dart';

@LazySingleton(as: OnDeviceEngine)
class EdgeAiEngine implements OnDeviceEngine {
  static const _timeout = Duration(minutes: 3);
  static const _maxOutputChars = 6500;

  Future<void>? _initialized;
  Future<void> _queue = Future.value();
  InferenceModel? _model;
  String? _loadedUrl;
  CancelToken? _cancel;

  Future<void> _ensureInitialized() => _initialized ??=
      FlutterEdgeAi.initialize(inferenceEngines: const [MediaPipeEngine()]);

  // MediaPipe holds a single loaded model, so downloads and generation
  // take turns in one queue.
  Future<T> _exclusive<T>(Future<T> Function() body) {
    final result = _queue.then((_) => body());
    _queue = result.then((_) {}, onError: (Object _) {});
    return result;
  }

  static ModelType _type(LocalModelFamily family) => switch (family) {
    LocalModelFamily.gemma => ModelType.gemmaIt,
    LocalModelFamily.qwen => ModelType.qwen,
    LocalModelFamily.phi => ModelType.phi,
    LocalModelFamily.deepSeek => ModelType.deepSeek,
    LocalModelFamily.general => ModelType.general,
  };

  InferenceInstallationBuilder _builder(LocalModel model, {String? token}) =>
      FlutterEdgeAi.installModel(
        modelType: _type(model.family),
        fileType: ModelFileType.task,
      ).fromNetwork(model.url, token: token);

  @override
  Future<String> install(
    LocalModel model, {
    String? token,
    void Function(int percent)? onProgress,
  }) async {
    await _ensureInitialized();
    return _exclusive(() async {
      await _closeModel();
      final cancel = _cancel = CancelToken();
      try {
        final trimmed = token?.trim();
        var builder = _builder(
          model,
          token: trimmed == null || trimmed.isEmpty ? null : trimmed,
        ).withCancelToken(cancel);
        if (onProgress != null) builder = builder.withProgress(onProgress);
        final installation = await builder.install();
        return installation.spec.files.first.filename;
      } on DownloadCancelledException {
        throw const LlmDownloadCancelledException();
      } on DownloadException catch (e) {
        throw switch (e.error) {
          UnauthorizedError() ||
          ForbiddenError() => const LlmModelAccessException(),
          NotFoundError() => const LlmModelNotFoundException(),
          RateLimitedError() => const LlmRateLimitException(),
          ServerError() => const LlmServerException(),
          CanceledError() => const LlmDownloadCancelledException(),
          NetworkError(:final message) ||
          UnknownError(:final message) => LlmNetworkException(message),
        };
      } finally {
        _cancel = null;
      }
    });
  }

  @override
  void cancelInstall() => _cancel?.cancel();

  @override
  Future<bool> isInstalled(String installId) async {
    await _ensureInitialized();
    return FlutterEdgeAi.isModelInstalled(installId);
  }

  @override
  Future<void> uninstall(String installId) async {
    await _ensureInitialized();
    return _exclusive(() async {
      await _closeModel();
      if (!await FlutterEdgeAi.isModelInstalled(installId)) return;
      try {
        await FlutterEdgeAi.uninstallModel(installId);
      } catch (e) {
        throw LlmOnDeviceException('$e');
      }
    });
  }

  @override
  Future<String> generate(
    LocalModel model, {
    required String installId,
    required String prompt,
  }) async {
    await _ensureInitialized();
    return _exclusive(() async {
      if (!await FlutterEdgeAi.isModelInstalled(installId)) {
        throw const LlmModelNotInstalledException();
      }
      final InferenceModelSession session;
      try {
        if (_loadedUrl != model.url) {
          await _closeModel();
          // Already on disk: this only makes it the active model.
          await _builder(model).install();
          _model = await FlutterEdgeAi.getActiveModel(
            maxTokens: model.contextTokens,
            preferredBackend: PreferredBackend.cpu,
          );
          _loadedUrl = model.url;
        }
        session = await _model!.createSession(temperature: 0.75, topK: 40);
      } catch (e) {
        await _closeModel();
        throw LlmOnDeviceException('$e');
      }
      return _run(session, prompt);
    });
  }

  Future<String> _run(InferenceModelSession session, String prompt) async {
    var timedOut = false;
    final timer = Timer(_timeout, () {
      timedOut = true;
      unawaited(session.stopGeneration().catchError((Object _) {}));
    });
    try {
      await session.addQueryChunk(Message(text: prompt, isUser: true));
      final buffer = StringBuffer();
      await for (final chunk in session.getResponseAsync()) {
        buffer.write(chunk);
        if (buffer.length > _maxOutputChars) {
          await session.stopGeneration();
          throw const LlmInvalidResponseException('Response is too long');
        }
      }
      if (timedOut) throw const LlmTimeoutException();
      if (buffer.isEmpty) {
        throw const LlmInvalidResponseException('Empty response');
      }
      return buffer.toString();
    } on LlmException {
      rethrow;
    } catch (e) {
      throw LlmOnDeviceException('$e');
    } finally {
      timer.cancel();
      await session.close();
    }
  }

  Future<void> _closeModel() async {
    final model = _model;
    _model = null;
    _loadedUrl = null;
    await model?.close();
  }
}
