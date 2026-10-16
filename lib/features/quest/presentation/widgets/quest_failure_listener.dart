import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../bloc/quest_bloc.dart';

class QuestFailureListener extends StatelessWidget {
  const QuestFailureListener({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<QuestBloc, QuestState>(
    listenWhen: (previous, current) =>
        current.failure != null && previous.failure != current.failure,
    listener: (context, state) {
      // Home and story are both alive; only the top one shows the snackbar.
      if (ModalRoute.of(context)?.isCurrent == false) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.failure!.message(context.l10n)),
            duration: const Duration(seconds: 8),
          ),
        );
    },
    child: child,
  );
}
