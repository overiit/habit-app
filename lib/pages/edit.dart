import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/components/betterbutton.dart';
import 'package:habit/components/bettertextfield.dart';
import 'package:habit/utils/fns.dart';
import 'package:habit/utils/store.dart';
import 'package:habit/utils/types.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: const Column(
        children: [
          AddTask(),
          Expanded(child: TaskList()),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskModel taskModel = Get.find();
    return Obx(
      () {
        return ReorderableListView(
          onReorder: taskModel.reorderTask,
          children: taskModel.tasks.map((entry) {
            int index = taskModel.tasks.indexOf(entry);
            String infoText = "";
            if (entry.completedToday()) {
              infoText = "Completed today";
            } else if (entry.skipped > 0) {
              infoText = "Skipped ${entry.skipped} times";
            } else {
              infoText = "Not completed";
            }
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              key: Key(index.toString()),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name),
                  Text(
                    infoText,
                    style: TextStyle(
                      color: entry.skipped > 0 ? Colors.red : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              leading: const Icon(Icons.drag_handle),
              trailing: IconButton(
                  onPressed: () {
                    confirmCompletion(
                      context: context,
                      text:
                          "Are you sure you want to delete \"${entry.name}\"? This cannot be undone.",
                      onConfirm: () {
                        TaskModel taskModel = Get.find();
                        taskModel.removeTask(task: entry);
                      },
                    );
                  },
                  icon: const Icon(Icons.delete)),
            );
          }).toList(),
        );
      },
    );
  }
}

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  String _taskName = "";
  final TextEditingController _controller = TextEditingController();

  void addTask() {
    TaskModel taskModel = Get.find();
    taskModel.addTask(
      task: Task(
        name: _taskName,
        type: TaskType.repeating,
        nextDue: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              "What needs to be done?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: BetterTextField(
                color: Colors.black,
                hintText: "Work on...",
                style: TextStyle(),
                controller: _controller,
                onChanged: (taskName) {
                  setState(() {
                    _taskName = taskName;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            BetterButton(
              "ADD",
              onPressed: _taskName.length > 0
                  ? () {
                      addTask();
                      // reset _controller value
                      _controller.value = TextEditingValue(
                        text: "",
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: 0),
                        ),
                      );
                    }
                  : null,
              color: Colors.black.withOpacity(_taskName.length > 0 ? 1 : .1),
              overlayColor: Colors.white.withOpacity(.15),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
