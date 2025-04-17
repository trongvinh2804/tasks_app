import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import '../domain/entity_task.dart';

class TaskStore {
  // lấy file lưu dữ liệu
  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    final dataDir = Directory('${dir.path}/data');
    //thư mục chưa có thì tạo cái mới(quan trọng)
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
    return File('${dataDir.path}/tasks.json');
  }

  // đọc tasks từ file
  Future<List<Task>> getTasks() async {
    try {
      final file = await _file;
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      final List data = jsonDecode(content);
      return data.map((e) => Task.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // lưu ngược xuống lại
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final file = await _file;
      final List data = tasks.map((t) => t.toMap()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      rethrow;
    }
  }
}
