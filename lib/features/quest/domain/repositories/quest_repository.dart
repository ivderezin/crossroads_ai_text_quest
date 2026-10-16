import '../entities/quest.dart';

abstract interface class QuestRepository {
  Future<Quest?> load();

  Future<void> save(Quest quest);
}
