import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.overline,
    this.title,
    required this.children,
  });

  final String? overline;
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (overline case final overline?) ...[
            Overline(overline),
            const SizedBox(height: 10),
          ],
          if (title case final title?) ...[
            Text(title, style: context.textStyles.titleMedium),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    ),
  );
}

class Overline extends StatelessWidget {
  const Overline(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      color: context.colors.primary,
      fontSize: 11,
      letterSpacing: 1.5,
    ),
  );
}

class MutedText extends StatelessWidget {
  const MutedText(this.text, {super.key, this.textAlign, this.fontSize});
  final String text;
  final TextAlign? textAlign;
  final double? fontSize;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: context.colors.onSurfaceVariant,
      height: 1.6,
      fontSize: fontSize,
    ),
  );
}
