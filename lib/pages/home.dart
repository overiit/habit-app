import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/components/betterbutton.dart';
import 'package:habit/utils/fns.dart';
import 'package:habit/utils/store.dart';
import 'package:habit/utils/types.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/';

  Widget success(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.greenAccent.withOpacity(.2),
              size: MediaQuery.of(context).size.width * .8,
            ),
          ),
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "YOU DID IT!",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 54,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You've completed all tasks for today!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget currentTaskView({required BuildContext context, required Task task}) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "YOUR CURRENT TASK IS",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                task.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: BetterButton(
                "SKIP TODAY",
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                onPressed: () {
                  confirmCompletion(
                    context: context,
                    text: "Are you sure you want to skip this task",
                    onConfirm: () {
                      TaskModel taskModel = Get.find();
                      taskModel.skipTask(task: task);
                    },
                  );
                },
                color: Colors.transparent,
                borderColor: const Color(0xFFDB7777),
                style: const TextStyle(
                  color: Color(0xFFDB7777),
                  fontWeight: FontWeight.w900,
                ),
                overlayColor: const Color(0x16DD7C7C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: BetterButton(
                "COMPLETE TASK",
                padding: EdgeInsets.only(top: 15, bottom: 15),
                onPressed: () {
                  confirmCompletion(
                    context: context,
                    text: "Are you sure you want to complete this task?",
                    onConfirm: () {
                      TaskModel taskModel = Get.find();
                      taskModel.completeTask(task: task);
                    },
                  );
                },
                color: Color.fromARGB(255, 107, 216, 145),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TaskModel taskModel = Get.find();
    return Obx(() {
      Task? currentTask =
          taskModel.tasks.firstWhereOrNull((element) => element.isDue);
      return Container(
        margin: const EdgeInsets.all(15),
        child: currentTask != null
            ? currentTaskView(context: context, task: currentTask)
            : success(context),
      );
    });
  }
}
