import 'package:get/get.dart';
import 'package:habit/utils/storage.dart';
import 'package:habit/utils/types.dart';

class TaskModel extends GetxController {
  // key is the order of the task
  final RxList<Task> _tasks = RxList([]);

  List<Task> get tasks {
    return _tasks;
  }

  set tasks(List<Task> tasks) {
    _tasks.value = tasks;
  }

  Task addTask({required Task task}) {
    tasks.add(task);
    update();
    return task;
  }

  void removeTask({required Task task}) {
    tasks.remove(task);
    update();
  }

  void completeTask({required Task task}) {
    int index = tasks.indexOf(task);
    if (index == -1) {
      return;
    }
    task.complete();
    tasks[index] = task;
    update();
  }

  void skipTask({required Task task}) {
    int index = tasks.indexOf(task);
    if (index == -1) {
      return;
    }
    task.skip();
    tasks[index] = task;
    update();
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final Task item = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, item);

    update();
  }

  Future<void> load() async {
    tasks = await loadList(taskStorage, Task.fromMap);
  }

  Future<void> save() async {
    await saveList(taskStorage, tasks);
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    save();
    super.update(ids, condition);
  }

  void reset() {
    tasks = [];
  }
}

class DataLoader extends GetxController {
  final RxBool _loaded = false.obs;

  bool get loaded {
    return _loaded.value;
  }

  set loaded(bool loaded) {
    _loaded.value = loaded;
  }

  @override
  void onReady() {
    load();
    super.onReady();
  }

  Future<void> load() async {
    await Get.find<TaskModel>().load();
    loaded = true;
    update();
  }

  void reset() {
    Get.find<TaskModel>().reset();
    update();
  }
}
