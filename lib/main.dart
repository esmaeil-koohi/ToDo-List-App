import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data.dart';
import 'package:todo/extentiosn.dart';

import 'edit.dart';

const taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
       SystemUiOverlayStyle(statusBarColor: primaryVariant));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariant = Color(0xff5C0AFF);
final secondaryTextColor = Color(0xffAFBED0);
const Color normalPriorityColor = Color(0xffF09819);
const Color lowPriorityColor = Color(0xff3BE1F1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              const TextTheme(
                  headline6: TextStyle(
                fontWeight: FontWeight.bold,
              )),
            ),
            inputDecorationTheme: InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
                hintStyle: TextStyle(
              color: secondaryTextColor,
            )),
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              primaryVariant: primaryVariant,
              background: const Color(0xffF3F5F8),
              onSurface: primaryTextColor,
              onBackground: primaryTextColor,
              secondary: primaryColor,
              onSecondary: Colors.white,
            )),
        home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);
    TextEditingController controller = TextEditingController();
    final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                task: TaskEntity(),
              ),
            ));
          },
          label: Row(
            children: const [
              Text('Add New Task'),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                CupertinoIcons.add_circled_solid,
              ),
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            appBarHomeScreen(themeData, controller, searchKeywordNotifier),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                 return ValueListenableBuilder<Box<TaskEntity>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      final List<TaskEntity> items;
                      if(controller.text.isEmpty){
                        items = box.values.toList();
                      }else{
                        items = box.values.where((element) => element.name.contains(controller.text)).toList();
                      }
                      if (items.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                          child: ListView.builder(
                            itemCount: items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Today',
                                          style: themeData.textTheme.headline6!
                                              .apply(fontSizeFactor: 0.9),
                                        ),
                                        Container(
                                          height: 3.0,
                                          width: 70.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(1.5),
                                              color: themeData.primaryColor),
                                        )
                                      ],
                                    ),
                                    MaterialButton(
                                      color: const Color(0xffEAEFF5),
                                      onPressed: () {
                                        box.clear();
                                      },
                                      textColor: secondaryTextColor,
                                      child: Row(
                                        children: [
                                          const Text('Delete All'),
                                          const SizedBox(
                                            width: 4.0,
                                          ),
                                          const Icon(
                                            CupertinoIcons.delete,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      elevation: 0.0,
                                    )
                                  ],
                                );
                              } else {
                                final TaskEntity task =
                                items[index - 1];
                                return taskItem(task, context);
                              }
                            },
                          ),
                        );
                      } else {
                        return emptyList();
                      }
                    },
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          CupertinoIcons.rectangle_on_rectangle_angled,
          size: 120,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Your task list is empty',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget appBarHomeScreen(ThemeData themeData, TextEditingController  controller, ValueNotifier<String> searchKeywordNotifier) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          themeData.colorScheme.primary,
          themeData.colorScheme.primaryVariant,
        ],
      )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('To Do List',
                    style: themeData.textTheme.headline6!
                        .apply(color: themeData.colorScheme.onPrimary)),
                Icon(CupertinoIcons.share,
                    color: themeData.colorScheme.onPrimary),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: 38,
                decoration: BoxDecoration(
                    color: themeData.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                      ),
                    ]),
                child:  Center(
                  child: TextField(
                    onChanged: (value) {
                      searchKeywordNotifier.value = controller.text;
                    },
                    controller: controller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.search),
                      label: Text('Search tasks...'),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskItem(TaskEntity task, BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: task),
            ));
          });
        },
        onLongPress: () {
          task.delete();
        },
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: themeData.colorScheme.surface,
          ),
          child: Row(
            children: [
              MyCheckBox(
                value: task.isCompleted,
                onTap: () {
                  setState(() {
                    task.isCompleted = !task.isCompleted;
                  });
                },
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  task.name,
                  style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null),
                ),
              ),
              Container(
                width: 5,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: task.getColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final Function() onTap;

  MyCheckBox({Key? key, required this.value, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                !value ? Border.all(color: secondaryTextColor, width: 2) : null,
            color: value ? primaryColor : null),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 16,
              )
            : null,
      ),
    );
  }
}
