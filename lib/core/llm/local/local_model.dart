import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_model.freezed.dart';
part 'local_model.g.dart';

enum LocalModelFamily { gemma, qwen, phi, deepSeek, general }

@freezed
abstract class LocalModel with _$LocalModel {
  const factory LocalModel({
    required String id,
    required String name,
    required String url,
    required LocalModelFamily family,
    @Default(2048) int contextTokens,
    int? sizeMb,
    @Default(false) bool gated,
  }) = _LocalModel;

  const LocalModel._();

  factory LocalModel.fromJson(Map<String, dynamic> json) =>
      _$LocalModelFromJson(json);

  static const customId = 'custom';

  factory LocalModel.custom(String url, LocalModelFamily family) => LocalModel(
    id: customId,
    name: Uri.parse(url).pathSegments.last.replaceAll(RegExp(r'\.task$'), ''),
    url: url,
    family: family,
  );
  bool get isCustom => id == customId;
  static final _huggingFaceTask = RegExp(
    r'^https://huggingface\.co/[^/\s]+/[^/\s]+/resolve/[^/\s]+/[^\s]+\.task$',
  );
  static bool isHuggingFaceTaskUrl(String url) =>
      _huggingFaceTask.hasMatch(url.trim());
  static const catalog = [
    LocalModel(
      id: 'gemma3-1b-it-int4',
      name: 'Gemma 3 1B',
      url: 'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task',
      family: LocalModelFamily.gemma,
      sizeMb: 555,
      gated: true,
    ),
    LocalModel(
      id: 'qwen2.5-1.5b-instruct-q8',
      name: 'Qwen 2.5 1.5B',
      url: 'https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
      family: LocalModelFamily.qwen,
      contextTokens: 1280,
      sizeMb: 1600,
    ),
    LocalModel(
      id: 'gemma-3n-e2b-it-int4',
      name: 'Gemma 3n E2B',
      url: 'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
      family: LocalModelFamily.gemma,
      contextTokens: 4096,
      sizeMb: 3100,
      gated: true,
    ),
    LocalModel(
      id: 'gemma-3n-e4b-it-int4',
      name: 'Gemma 3n E4B',
      url: 'https://huggingface.co/google/gemma-3n-E4B-it-litert-preview/resolve/main/gemma-3n-E4B-it-int4.task',
      family: LocalModelFamily.gemma,
      contextTokens: 4096,
      sizeMb: 4400,
      gated: true,
    ),
    LocalModel(
      id: 'phi-4-mini-instruct-q8',
      name: 'Phi-4 mini',
      url: 'https://huggingface.co/litert-community/Phi-4-mini-instruct/resolve/main/Phi-4-mini-instruct_multi-prefill-seq_q8_ekv4096.task',
      family: LocalModelFamily.phi,
      contextTokens: 4096,
      sizeMb: 3900,
    ),
  ];
}
