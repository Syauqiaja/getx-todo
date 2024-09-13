import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_todo_app/app/core/utils/keys.dart';
import 'package:my_todo_app/app/data/models/task.dart';
import 'package:my_todo_app/app/data/services/storage/services.dart';

class TaskProvider{
  StorageService storageService = Get.find<StorageService>();

  List<Task> readTasks(){
    var tasks = <Task>[];
    jsonDecode(storageService.read(taskKey).toString())
      .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }
  void writeTasks(List<Task> tasks){
    storageService.write(taskKey, jsonEncode(tasks));
  }
}