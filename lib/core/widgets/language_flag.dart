import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatelessWidget {
  const LanguageFlag(this.languageCode, {super.key, this.width = 28});

  final String languageCode;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 0.7;
    if (FlagCode.fromLanguageCode(languageCode) == null) {
      return SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.language, size: height),
      );
    }
    return CountryFlag.fromLanguageCode(
      languageCode,
      theme: ImageTheme(
        width: width,
        height: height,
        shape: const RoundedRectangle(4),
      ),
    );
  }
}
