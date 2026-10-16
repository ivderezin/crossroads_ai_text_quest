import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/llm/local/local_model.dart';

class CustomModelForm extends StatefulWidget {
  const CustomModelForm({
    super.key,
    required this.current,
    required this.locked,
    required this.onSubmit,
  });

  final LocalModel? current;

  final bool locked;
  final ValueChanged<LocalModel> onSubmit;

  @override
  State<CustomModelForm> createState() => _CustomModelFormState();
}

class _CustomModelFormState extends State<CustomModelForm> {
  late final _url = TextEditingController(text: widget.current?.url);
  late var _family = widget.current?.family ?? LocalModelFamily.gemma;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  String _familyLabel(LocalModelFamily family) => switch (family) {
    LocalModelFamily.gemma => 'Gemma',
    LocalModelFamily.qwen => 'Qwen',
    LocalModelFamily.phi => 'Phi',
    LocalModelFamily.deepSeek => 'DeepSeek',
    LocalModelFamily.general => context.l10n.localFamilyOther,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final url = _url.text.trim();
    final valid = LocalModel.isHuggingFaceTaskUrl(url);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _url,
          enabled: !widget.locked,
          autocorrect: false,
          keyboardType: TextInputType.url,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.customModelUrlLabel,
            helperText: widget.locked
                ? l10n.customModelLocked
                : l10n.customModelUrlHelper,
            helperMaxLines: 2,
            errorText: url.isEmpty || valid ? null : l10n.customModelUrlInvalid,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<LocalModelFamily>(
          initialValue: _family,
          decoration: InputDecoration(labelText: l10n.customModelFamily),
          items: [
            for (final family in LocalModelFamily.values)
              DropdownMenuItem(
                value: family,
                child: Text(_familyLabel(family)),
              ),
          ],
          onChanged: widget.locked
              ? null
              : (family) => setState(() => _family = family ?? _family),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: widget.locked || !valid
                ? null
                : () => widget.onSubmit(LocalModel.custom(url, _family)),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.customModelAdd),
          ),
        ),
      ],
    );
  }
}
