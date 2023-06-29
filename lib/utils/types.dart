abstract class Mappable {
  Map<String, dynamic> toMap();
}

enum TaskType {
  repeating,
  oneTime,
}

class Task implements Mappable {
  String name;
  TaskType type;
  DateTime? nextDue;
  int skipped = 0;

  bool completedToday() {
    if (nextDue == null) {
      return true;
    }
    if (skipped > 0) {
      return false;
    }
    return (nextDue?.millisecondsSinceEpoch ?? 0) >=
        DateTime.now().millisecondsSinceEpoch;
  }

  bool get isDue {
    if (nextDue == null) {
      return false;
    }
    return (nextDue?.millisecondsSinceEpoch ?? 0) <=
        DateTime.now().millisecondsSinceEpoch;
  }

  void complete() {
    if (type == TaskType.repeating) {
      // due in 1 day at 8 am (currently its not 8 am)
      nextDue = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 1,
        8,
      );
    } else {
      nextDue = null;
    }
    skipped = 0;
  }

  void skip() {
    nextDue = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
      8,
    );
    skipped++;
  }

  Task({required this.name, required this.type, required this.nextDue});

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'type': type.index, 'nextDue': nextDue?.toString()};
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      type: TaskType.values[map['type']],
      nextDue: map['nextDue'] != null ? DateTime.parse(map['nextDue']) : null,
    );
  }
}
