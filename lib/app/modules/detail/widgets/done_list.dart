import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/app/core/utils/extensions.dart';
import 'package:my_todo_app/app/modules/home/controller.dart';

class DoneList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoneList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doneTodos.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeCtrl.doneTodos.map((todo) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 3.0.wp,
                        horizontal: 9.0.wp,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                  (_) => Colors.grey,
                                ),
                                value: todo['done'],
                                onChanged: (value) {
                                  homeCtrl.undoneTodo(todo['title']);
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                            child: Text(todo['title']),
                          )
                        ],
                      ),
                    )),
              ],
            )
          : Container(),
    );
  }
}
