import 'package:flutter/material.dart';

class ChoiceList extends StatelessWidget {
  const ChoiceList({super.key, required this.choices, required this.onChosen});

  final List<String> choices;

  final ValueChanged<String>? onChosen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, choice) in choices.indexed)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(18),
            ),
            onPressed: onChosen == null ? null : () => onChosen!(choice),
            child: Text('${index + 1}.  $choice'),
          ),
        ),
    ],
  );
}
