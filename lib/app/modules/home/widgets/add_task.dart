import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/app/core/utils/extensions.dart';
import 'package:my_todo_app/app/core/values/colors.dart';
import 'package:my_todo_app/app/data/models/task.dart';
import 'package:my_todo_app/app/modules/home/controller.dart';
import 'package:my_todo_app/app/widgets/icons.dart';

class AddTaskCard extends StatelessWidget {
  final homeCrtl = Get.find<HomeController>();
  AddTaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;

    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
            title: 'Task Type',
            radius: 5,
            content: Form(
              key: homeCrtl.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeCrtl.editCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your task title';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3.0.wp, vertical: 3.0.wp),
                    child: Wrap(
                      spacing: 2.0.wp,
                      alignment: WrapAlignment.center,
                      children: icons
                          .map((e) => Obx(() {
                                final index = icons.indexOf(e);
                                return ChoiceChip.elevated(
                                  showCheckmark: false,
                                  selectedColor: Colors.grey[200],
                                  pressElevation: 0,
                                  backgroundColor: Colors.white,
                                  label: e,
                                  selected: homeCrtl.chipIndex.value == index,
                                  onSelected: (bool selected) {
                                    homeCrtl.chipIndex.value =
                                        selected ? index : 0;
                                  },
                                );
                              }))
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(150, 40)),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (homeCrtl.formKey.currentState!.validate()) {
                        int icon =
                            icons[homeCrtl.chipIndex.value].icon!.codePoint;
                        String color =
                            icons[homeCrtl.chipIndex.value].color!.toHex();
                        var task = Task(
                          title: homeCrtl.editCtrl.text,
                          icon: icon,
                          color: color,
                        );
                        Get.back();
                        homeCrtl.addTask(task)
                            ? EasyLoading.showSuccess('Create Success')
                            : EasyLoading.showError('Duplicate Task');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
