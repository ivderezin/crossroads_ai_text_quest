import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/quest.dart';
import '../../domain/repositories/quest_repository.dart';
import '../datasources/quest_local_data_source.dart';
import '../models/quest_dto.dart';

@LazySingleton(as: QuestRepository)
class QuestRepositoryImpl implements QuestRepository {
  QuestRepositoryImpl(this._source);
  final QuestLocalDataSource _source;

  @override
  Future<Quest?> load() async {
    final String? raw;
    try {
      raw = await _source.read();
    } catch (_) {
      throw const StorageFailure();
    }
    if (raw == null) return null;
    try {
      return QuestDto.fromJson(jsonDecode(raw) as Map<String, dynamic>)
          .toDomain();
    } catch (_) {
      // The broken save is left in place on purpose.
      throw const CorruptedSaveFailure();
    }
  }

  @override
  Future<void> save(Quest quest) async {
    try {
      await _source.write(jsonEncode(QuestDto.fromDomain(quest).toJson()));
    } catch (_) {
      throw const StorageFailure();
    }
  }
}
