import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed('/');
            },
            child: const Text(
              'HABIT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.toNamed('/edit');
                },
                icon: Icon(Icons.list),
                splashRadius: 20,
              ),
              // IconButton(
              //   onPressed: () {
              //     Get.toNamed('/settings');
              //   },
              //   icon: Icon(Icons.tune),
              //   splashRadius: 20,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
