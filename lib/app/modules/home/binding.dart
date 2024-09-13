import 'package:get/get.dart';
import 'package:my_todo_app/app/data/providers/tasks/provider.dart';
import 'package:my_todo_app/app/data/services/storage/repository.dart';
import 'package:my_todo_app/app/modules/home/controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}
