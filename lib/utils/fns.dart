import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/utils/store.dart';

String timeAgo({required int time, bool short = false}) {
  int now = DateTime.now().millisecondsSinceEpoch;
  int diff = now - time;
  int seconds = (diff / 1000).floor();
  int minutes = (seconds / 60).floor();
  int hours = (minutes / 60).floor();
  int days = (hours / 24).floor();
  String d = short ? ' d' : ' day${days > 1 ? 's' : ''}';
  String h =
      short ? ' hr${hours > 1 ? 's' : ''}' : ' hour${hours > 1 ? 's' : ''}';
  String m = short
      ? ' min${minutes > 1 ? 's' : ''}'
      : ' minute${minutes > 1 ? 's' : ''}';
  if (days > 0) {
    return '${days}${d} ago';
  } else if (hours > 0) {
    return '${hours}${h} ago';
  } else if (minutes > 0) {
    return '${minutes}${m} ago';
  } else {
    return 'Just now';
  }
}

String timeSpanDuration(int timeMs, [num Function(num)? numberModifier]) {
  numberModifier ??= (num x) => x.floor();

  num seconds = timeMs / 1000;
  num minutes = seconds / 60;
  num hours = minutes / 60;
  num days = hours / 24;

  if (days >= 1) {
    days = numberModifier(days);
    hours = numberModifier(hours % 24);
    minutes = numberModifier(minutes % 60);
    return '${days}d ${hours}h';
  } else if (hours >= 1) {
    hours = numberModifier(hours);
    minutes = numberModifier(minutes % 60);
    return '${hours}h ${minutes}m';
  } else {
    minutes = numberModifier(minutes);
    return '${minutes}m';
  }
}

void confirmCompletion(
    {required BuildContext context,
    required String text,
    required Function onConfirm}) {
  TaskModel taskModel = Get.find<TaskModel>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmation"),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
