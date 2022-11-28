import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.openBox<Task>(taskBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen()
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    return Scaffold(
      appBar: AppBar(title: Text('To Do List'),),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditTaskScreen(),));
      }, label: Text('Add New Task')),
      body: ListView.builder(
        itemCount: box.values.length,
        itemBuilder: (context, index) {
          final Task task = box.values.toList()[index];
          return Container(

          );
      },),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({Key? key}) : super(key: key);
 TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task'),),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        final task = Task();
        task.name = _controller.text;
        task.priority = Priority.low;
        if(task.isInBox){
          task.save();
        }else{
          final Box<Task> box = Hive.box(taskBoxName);
          box.add(task);
        }
        Navigator.of(context).pop();
      }, label: Text('Save Changes')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              label: Text('Add a task for today...')
            ),
          ),
        ],
      ),
    );
  }
}

