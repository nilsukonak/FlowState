import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/helpers/validation_helper.dart';
import 'package:todoapp/presentation/providers/dropdown_provider.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

import 'package:todoapp/presentation/widgets/date_picker.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/presentation/widgets/chip_selector.dart';
import 'package:todoapp/presentation/widgets/dropdown_menu.dart';
import 'package:todoapp/services/notification_service.dart';
import 'package:provider/provider.dart';

//giriş yapms kullanıcıcnın uid degerini getter ile alıyoruz
@RoutePage()
class NewtasksPage extends StatefulWidget {
  const NewtasksPage({super.key});

  @override
  State<NewtasksPage> createState() => _NewtasksPageState();
}

class _NewtasksPageState extends State<NewtasksPage> {
  final TextEditingController titlecont = TextEditingController();
  final TextEditingController descriptioncont = TextEditingController();

  final TextEditingController datecont = TextEditingController();

  final TextEditingController categorycont = TextEditingController();
  final _newformKey =
      GlobalKey<FormState>(); //title için validate ile boş kontrolü yapacağız

  @override
  void initState() {
    print('InitState _formKey hash: ${_newformKey.hashCode}');
    super.initState();
    titlecont.clear();
    descriptioncont.clear();
    datecont.clear();
    // provider değerlerini sıfırla
    Future.microtask(() {
      context.read<DropdownProvider>();
      context.read<DropdownProvider>()
        ..setPriority(null)
        ..setCategory(null);
    });
  }

  @override
  void dispose() {
    // Controller’ları serbest bırak
    titlecont.dispose();
    descriptioncont.dispose();
    datecont.dispose();
    categorycont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldColor = Theme.of(context).colorScheme.surfaceContainer;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          'New Task',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,

              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: _newformKey,
                child: TextFormField(
                  validator: (value) => validateNotEmpty(value, 'Title'),
                  controller: titlecont,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,

              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: descriptioncont,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 12),
                ),
              ),
            ),

            SizedBox(height: 15),

            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Container(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Datesec(controller: datecont);
                  },
                ),
              ),
            ),
            SizedBox(height: 15),

            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,

              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(15),
              ),

              child: DropdownMenuExample(),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Chipapp(
                  chiplist: ['Low', 'Medium', 'High'],
                  selectedValue: context
                      .watch<DropdownProvider>()
                      .selectedPriority,
                  onchipselected: (value) {
                    context.read<DropdownProvider>().setPriority(value);
                  },
                  showCheckmark: true,
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.92,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                onPressed: () async {
                  if (_newformKey.currentState!.validate()) {
                    final dropdownProvider = context.read<DropdownProvider>();
                    final newTask = Taskmodel(
                      title: titlecont.text,
                      description: descriptioncont.text,
                      date: datecont.text,
                      priority: dropdownProvider.selectedPriority ?? "",
                      category: dropdownProvider.selectedvalue ?? "",
                    );

                    final taskprovider = Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    );

                    final savedTask = await taskprovider.addTask(newTask);

                    if (savedTask.id != null && savedTask.id!.isNotEmpty) {
                      await NotificationService.instance.scheduleTaskReminders(
                        taskId: savedTask.id!,
                        taskTitle: savedTask.title,
                        selectedDate: DateTime.parse(savedTask.date),
                      );
                    }

                    if (!mounted) return;

                    context.router.replace(const TasksRoute());
                  } else {
                    print('hata ');
                  }

                  titlecont.clear();
                  descriptioncont.clear();
                  datecont.clear();

                  categorycont.clear();
                },

                child: Text('Save Task', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
