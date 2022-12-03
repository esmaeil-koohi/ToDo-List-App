import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data.dart';
import 'main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;
   const EditTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
 late final TextEditingController _controller = TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final Box<TaskEntity> box = Hive.box(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: appBar(themeData),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: saveChangeButton(box, context),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          priorityButtons(),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(label: Text('Add a task for today...')),
          ),
        ],
      ),
    );
  }

  Widget priorityButtons() {
    return Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(flex: 1,child: PriorityCheckBox(
                onTap: () {
                 setState(() {
                   widget.task.priority = Priority.high;
                 });
                },
                label: 'High',
                color: primaryColor,
                isSelected: widget.task.priority == Priority.high,
              )),
             const SizedBox(width: 8.0,),
              Flexible(flex: 1,child: PriorityCheckBox(
                onTap: () {
                  setState(() {
                    widget.task.priority = Priority.normal;
                  });
                },
                label: 'Normal',
                color:normalPriorityColor,
                isSelected: widget.task.priority == Priority.normal,
              )),
              const SizedBox(width: 8.0,),
              Flexible(flex: 1,child: PriorityCheckBox(
                onTap: () {
                  setState(() {
                    widget.task.priority = Priority.low;
                  });
                },
                label: 'Low',
                color:lowPriorityColor,
                isSelected: widget.task.priority == Priority.low,
              )),
            ],
          );
  }

  Widget saveChangeButton(Box<TaskEntity> box, BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () {
          widget.task.name = _controller.text.toString();
          widget.task.priority = widget.task.priority;
          if (widget.task.isInBox) {
            widget.task.save();
          } else {
            box.add(widget.task);
          }
          Navigator.of(context).pop();
        },
        label: Row(
          children: const [
            Text('Save Changes'),
            SizedBox(width: 5.0,),
            Icon(CupertinoIcons.checkmark_alt, size:20 ,),
          ],
        ));
  }

  AppBar appBar(ThemeData themeData) {
    return AppBar(
      elevation: 0,
      backgroundColor: themeData.colorScheme.surface,
      foregroundColor: themeData.colorScheme.onSurface,
      title: const Text('Edit Task'),
    );
  }

}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final GestureTapCallback onTap;
  const PriorityCheckBox({Key? key,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4),),
        border: Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
      ),
        child: Stack(
          children: [
            Center(child: Text(label)),
            Positioned(
                right: 6,
                top: 0,
                bottom: 0,
                child: Center(child: _CheckBoxShape(value:isSelected, color: color,))),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const _CheckBoxShape({Key? key, required this.value, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color
      ),
      child: value ?  Icon(CupertinoIcons.check_mark, color: themeData.colorScheme.onPrimary, size: 14,) : null ,
    );
  }
}