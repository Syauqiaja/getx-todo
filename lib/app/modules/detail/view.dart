import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/app/core/utils/extensions.dart';
import 'package:my_todo_app/app/modules/detail/widgets/done_list.dart';
import 'package:my_todo_app/app/modules/detail/widgets/todo_list.dart';
import 'package:my_todo_app/app/modules/home/controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        homeCtrl.updateTodos(task);
                        Get.back();
                        homeCtrl.editCtrl.clear();
                        homeCtrl.selectTask(null);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      IconData(task.icon, fontFamily: "MaterialIcons"),
                      color: color,
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16.0.wp, top: 3.0.wp, right: 16.0.wp),
                child: Obx(() {
                  var totalTodos =
                      homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                  return Row(
                    children: [
                      Text(
                        '$totalTodos Tasks',
                        style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeCtrl.doneTodos.length,
                          size: 5,
                          padding: 0,
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color]
                          ),
                          unselectedGradientColor: LinearGradient(
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 3.0.wp, horizontal: 5.0.wp
                ),
                child: TextFormField(
                  controller: homeCtrl.editCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    prefixIcon: Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey[400]!,
                    ),
                    suffixIcon: IconButton(
                      onPressed: (){
                        if(homeCtrl.formKey.currentState!.validate()){
                          var success = homeCtrl.addTodo(homeCtrl.editCtrl.text);
                          if(success){
                            EasyLoading.showSuccess("Todo item add success");
                          }else{
                            EasyLoading.showError("Todo item already exist");
                          }
                          homeCtrl.editCtrl.clear();
                        }
                      },
                      icon: const Icon(Icons.done),
                    )
                  ),
                  validator: (value){
                    if(value == null || value.trim().isEmpty){
                      return "Please enter your task";
                    }
                    return null;
                  },
                ),
              ),
              TodoList(),
              DoneList(),
            ],
          ),
        ),
      ),
    );
  }
}
