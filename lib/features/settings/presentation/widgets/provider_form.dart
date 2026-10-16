import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/llm/llm_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/provider_settings.dart';
import '../cubit/model_catalog_cubit.dart';
import '../cubit/settings_cubit.dart';
import 'model_picker_sheet.dart';

class ProviderForm extends StatefulWidget {
  const ProviderForm({
    super.key,
    required this.provider,
    required this.initial,
  });

  final LlmProvider provider;
  final ProviderSettings initial;

  @override
  State<ProviderForm> createState() => _ProviderFormState();
}

class _ProviderFormState extends State<ProviderForm> {
  late final _apiKey = TextEditingController(text: widget.initial.apiKey);
  late final _model = TextEditingController(text: widget.initial.model);
  late final _baseUrl = TextEditingController(text: widget.initial.baseUrl);
  var _obscure = true;
  var _saving = false;

  @override
  void dispose() {
    _apiKey.dispose();
    _model.dispose();
    _baseUrl.dispose();
    super.dispose();
  }

  ProviderSettings get _current => ProviderSettings(
    apiKey: _apiKey.text.trim(),
    model: _model.text.trim(),
    baseUrl: _baseUrl.text.trim(),
  );

  Future<void> _save() async {
    setState(() => _saving = true);
    final cubit = context.read<SettingsCubit>();
    final ok = await cubit.saveProviderSettings(widget.provider, _current);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.settingsSaved)));
    }
  }

  void _check() {
    final settings = _current;
    if (!settings.isConfigured) return;
    context.read<ModelCatalogCubit>().fetch(settings.toConfig(widget.provider));
  }

  Future<void> _pickModel(ModelCatalogState catalog) async {
    final l10n = context.l10n;
    final fetched = catalog is ModelCatalogLoaded && catalog.models.isNotEmpty
        ? catalog.models
        : null;
    final picked = await ModelPickerSheet.show(
      context,
      title: fetched != null ? l10n.modelsAvailable : l10n.modelsSuggested,
      models: fetched ?? widget.provider.suggestedModels,
      selected: _model.text.trim(),
    );
    if (picked != null) setState(() => _model.text = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final catalog = context.watch<ModelCatalogCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _apiKey,
          obscureText: _obscure,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.apiKeyLabel,
            helperText: l10n.apiKeyHelper,
            suffixIcon: IconButton(
              tooltip: _obscure ? l10n.showKey : l10n.hideKey,
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SelectableText(
          l10n.apiKeyWhere(widget.provider.consoleUrl),
          style: TextStyle(
            fontSize: 12,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _model,
          autocorrect: false,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.modelLabel,
            suffixIcon: IconButton(
              tooltip: l10n.modelPick,
              icon: const Icon(Icons.list_rounded),
              onPressed: () => _pickModel(catalog),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _baseUrl,
          autocorrect: false,
          keyboardType: TextInputType.url,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.baseUrlLabel,
            helperText: l10n.baseUrlHelper,
            suffixIcon: _baseUrl.text.trim() == widget.provider.defaultBaseUrl
                ? null
                : IconButton(
                    tooltip: l10n.resetBaseUrl,
                    icon: const Icon(Icons.restart_alt_rounded),
                    onPressed: () => setState(
                      () => _baseUrl.text = widget.provider.defaultBaseUrl,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),
        _CatalogStatus(catalog),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed:
                  catalog is ModelCatalogLoading || !_current.isConfigured
                  ? null
                  : _check,
              icon: const Icon(Icons.wifi_tethering_rounded),
              label: Text(l10n.checkConnection),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(l10n.saveSettings),
            ),
          ],
        ),
      ],
    );
  }
}

class _CatalogStatus extends StatelessWidget {
  const _CatalogStatus(this.state);
  final ModelCatalogState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = switch (state) {
      ModelCatalogIdle() => null,
      ModelCatalogLoading() => const LinearProgressIndicator(),
      ModelCatalogLoaded(:final models) => Text(
        l10n.connectionOk(models.length),
        style: TextStyle(color: context.colors.primary),
      ),
      ModelCatalogFailed(:final failure) => Text(
        failure.message(l10n),
        style: TextStyle(color: context.colors.error),
      ),
    };
    if (child == null) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: child);
  }
}
