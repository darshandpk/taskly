import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double deviceHeight, deviceWidth;

  String? _newTaskContent;
  Box? _box;

  _HomePageState();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(50, 50, 80, 100),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(450, 450, 1000, 10),
        toolbarHeight: deviceHeight * 0.14,
        title: const Text(
          "Welcome to Taskly!",
          style: TextStyle(
            fontSize: 25,
            color: Color.fromRGBO(100, 100, 150, 10),
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _tasksView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('task'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _tasksList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _tasksList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, int index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              fontSize: 19,
              color: const Color.fromRGBO(450, 450, 1000, 10),
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            task.timestamp.toString(),
            style: const TextStyle(
              color: Color.fromRGBO(100, 100, 150, 10),
            ),
          ),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: const Color.fromRGBO(100, 100, 150, 10),
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(
              index,
              task.toMap(),
            );
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displyTaskPopup,
      child: const Icon(
        Icons.add,
        color: Color.fromRGBO(100, 100, 150, 10),
      ),
    );
  }

  void _displyTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Add New Task!",
            style: TextStyle(
              color: Color.fromRGBO(100, 100, 150, 10),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            onSubmitted: (value) {
              if (_newTaskContent != null) {
                var task = Task(
                  content: _newTaskContent!,
                  timestamp: DateTime.now(),
                  done: false,
                );
                _box!.add(task.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
              ;
            },
            onChanged: (value) {
              setState(() {
                _newTaskContent = value;
              });
            },
          ),
        );
      },
    );
  }
}
