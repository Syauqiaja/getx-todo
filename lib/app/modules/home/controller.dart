
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_todo_app/app/data/models/task.dart';
import 'package:my_todo_app/app/data/services/storage/repository.dart';

class HomeController extends GetxController{
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});

  final tabIndex = 0.obs;
  final editCtrl = TextEditingController();
  final isDeleting = false.obs;
  final chipIndex = 0.obs;
  final formKey = GlobalKey<FormState>();
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }
  @override
  void onClose() {
    // TODO: implement onClose
    editCtrl.dispose();
    super.onClose();
  }

  bool addTask(Task task) {
    if(tasks.contains(task)){
      return false;
    }
    tasks.add(task);
    return true;
  }
  setDeleting(bool value){
    isDeleting.value = value;
  }

  void deleteTask(Task data) {
    tasks.remove(data);
  }
  setTabIndex(int value){
    tabIndex.value = value;
  }
  selectTask(Task? task){
    this.task.value = task;
  }
  selectTodos(List<dynamic> todos){
    doneTodos.clear();
    doingTodos.clear();

    for(int i = 0; i < todos.length; i++){
      var todo = todos[i];
      var status = todo['done'];
      if(status == true){
        doneTodos.add(todo);
      }else{
        doingTodos.add(todo);
      }
    }
  }

  bool addTodo(String text) {
    var todo = {'title': text, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    if (doneTodos.any((element) =>
        mapEquals<String, dynamic>({'title': text, 'done': true}, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void doneTodo(String title) {
    int index = doingTodos.indexWhere((element) => 
      mapEquals({'title': title, 'done': false}, element));

    doingTodos.removeAt(index);
    doneTodos.add({'title': title, 'done': true});
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void undoneTodo(String title) {
    int index = doneTodos.indexWhere((element) => 
      mapEquals({'title': title, 'done': true}, element));

    doneTodos.removeAt(index);
    doingTodos.add({'title': title, 'done': false});
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void updateTodos(Task task) {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doneTodos,
      ...doingTodos
    ]);

    var newTask = task.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }
  int getTotalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}