import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../language/languages.dart';
import 'language_flag.dart';

typedef LanguageChoice = ({String? code});

class LanguagePickerSheet extends StatefulWidget {
  const LanguagePickerSheet({
    super.key,
    required this.codes,
    required this.selected,
    required this.automaticTitle,
    required this.automaticSubtitle,
  });

  final List<String> codes;
  final String? selected;
  final String automaticTitle;
  final String automaticSubtitle;

  static Future<LanguageChoice?> show(
    BuildContext context, {
    required List<String> codes,
    required String? selected,
    required String automaticTitle,
    required String automaticSubtitle,
  }) => showModalBottomSheet<LanguageChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => LanguagePickerSheet(
      codes: codes,
      selected: selected,
      automaticTitle: automaticTitle,
      automaticSubtitle: automaticSubtitle,
    ),
  );

  @override
  State<LanguagePickerSheet> createState() => _LanguagePickerSheetState();
}

class _LanguagePickerSheetState extends State<LanguagePickerSheet> {
  final _query = TextEditingController();
  late List<({String code, String name, String native})> _entries;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _entries = [
      for (final code in widget.codes)
        (
          code: code,
          name: Languages.localizedName(context, code),
          native: Languages.nativeName(code),
        ),
    ]..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _pick(String? code) =>
      Navigator.pop<LanguageChoice>(context, (code: code));

  @override
  Widget build(BuildContext context) {
    final query = _query.text.trim().toLowerCase();
    final matches = query.isEmpty
        ? _entries
        : _entries.where(
            (e) =>
                e.name.toLowerCase().contains(query) ||
                e.native.toLowerCase().contains(query) ||
                e.code == query,
          );
    final searchable = widget.codes.length > 8;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: searchable ? 0.75 : 0.4,
        maxChildSize: 0.95,
        builder: (context, controller) => Column(
          children: [
            if (searchable)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _query,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: context.l10n.languageSearch,
                  ),
                ),
              ),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  if (query.isEmpty)
                    ListTile(
                      leading: const Icon(Icons.auto_mode_outlined),
                      title: Text(widget.automaticTitle),
                      subtitle: Text(widget.automaticSubtitle),
                      trailing: widget.selected == null
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => _pick(null),
                    ),
                  for (final entry in matches)
                    ListTile(
                      leading: LanguageFlag(entry.code),
                      title: Text(entry.name),
                      subtitle: entry.native == entry.name
                          ? null
                          : Text(entry.native),
                      trailing: entry.code == widget.selected
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => _pick(entry.code),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
