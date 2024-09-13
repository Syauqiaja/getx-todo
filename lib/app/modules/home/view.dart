import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_todo_app/app/core/utils/extensions.dart';
import 'package:my_todo_app/app/core/values/colors.dart';
import 'package:my_todo_app/app/core/values/icons.dart';
import 'package:my_todo_app/app/data/models/task.dart';
import 'package:my_todo_app/app/modules/detail/view.dart';
import 'package:my_todo_app/app/modules/home/controller.dart';
import 'package:my_todo_app/app/modules/home/widgets/add_task.dart';
import 'package:my_todo_app/app/modules/home/widgets/task_card.dart';
import 'package:my_todo_app/app/modules/report/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: controller.tabIndex.value,
          children: [
            mainPage(),
            ReportPage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          onTap: (int index) => controller.setTabIndex(index),
          currentIndex: controller.tabIndex.value,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Report',
              icon: Icon(Icons.report),
            ),
          ],
        ),
        floatingActionButton: DragTarget<Task>(
          builder: (context, accepted, rejected) {
            return Obx(
              () => FloatingActionButton(
                backgroundColor:
                    controller.isDeleting.value ? Colors.red : blue,
                onPressed: () {},
                child: Icon(
                  controller.isDeleting.value ? Icons.delete : Icons.add,
                  color: Colors.white,
                ),
              ),
            );
          },
          onAcceptWithDetails: (details) {
            controller.deleteTask(details.data);
          },
        ),
      ),
    );
  }

  Widget mainPage() => SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0.wp),
              child: Text(
                "My Lists",
                style: TextStyle(
                  fontSize: 22.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                ...controller.tasks.map(
                  (task) => LongPressDraggable<Task>(
                    onDragStarted: () => controller.setDeleting(true),
                    onDraggableCanceled: (_, __) =>
                        controller.setDeleting(false),
                    onDragEnd: (_) => {
                      controller.setDeleting(false),
                    },
                    data: task,
                    feedback: Opacity(
                      opacity: 0.8,
                      child: TaskCard(task: task),
                    ),
                    child: TaskCard(
                      task: task,
                    ),
                  ),
                ),
                AddTaskCard()
              ],
            ),
          ],
        ),
      );
}
