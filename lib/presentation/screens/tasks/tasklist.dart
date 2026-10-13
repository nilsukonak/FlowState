import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';

import 'package:todoapp/helpers/app_color.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/data/repositories/focus_repository.dart';
import 'package:todoapp/helpers/focus_time_formatter.dart';

@RoutePage()
class TasklistPage extends StatefulWidget {
  const TasklistPage({super.key});

  @override
  State<TasklistPage> createState() => _TasklistPageState();
}

//List<Taskmodel> tasklist = []; fetck ile provider yptgm için buna gerek yok

class _TasklistPageState extends State<TasklistPage> {
  final FocusRepository _focusRepository = FocusRepository();

  Widget _buildFocusMinutes(String? taskId, Color primaryColor) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || taskId == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<int>(
      //bu onceden futurebuilderdi tek veri alıyodu simdi stream yaptm her saniye dk bası guncellencek calısma suresi yani firestroeden bi kere veri geirmicek artkk
      stream: _focusRepository.watchTotalFocusSeconds(uid, taskId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final totalSeconds = snapshot.data!;
        final formattedTime = formatFocusTime(totalSeconds);
        return Text(
          '⏱ $formattedTime',
          style: TextStyle(
            color: primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //addPostFrameCallback, görev çekme işlemini ilk çizim tamamlandıktan sonra başlatır.
      if (!mounted) return;
      _loadtask();
    });
  }

  Future<void> _loadtask() async {
    final taskprovider = Provider.of<TaskProvider>(context, listen: false);
    await taskprovider.fetchtasks();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF292929) : Colors.white;

    final titleColor = Theme.of(context).colorScheme.onSurface;

    final subtitleColor = isDark ? const Color(0xFFAAAAAA) : Colors.black54;

    final primaryColor = Theme.of(context).colorScheme.primary;

    final taskProvider = context
        .watch<
          TaskProvider
        >(); //watch cunku provider değince listeyi yeniden olstryo
    final localFilteredTasks = taskProvider.filteredTasks;
    //yukardaki 2li sayesinde araam ktuus ve gorevler aktf calısıyo yani her harfte provider sayesnde o harf içeren gorevler geliyo
    final taskActions = context.read<TaskProvider>();
    if (taskProvider.isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (localFilteredTasks.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.task_alt, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No tasks found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Create a task to get started!',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    } //GOREV YOKSA GÖSTERİLECEK WIDGET

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      child: ListView.builder(
        itemCount: localFilteredTasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = localFilteredTasks[index];

          return Dismissible(
            key: ValueKey(task.id ?? UniqueKey()),

            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await taskActions.dismisibleTask(task.id!);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Task deleted')));
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.buttonColor,
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            child: Opacity(
              opacity: task.isdone ? 0.65 : 1.0,

              child: Card(
                color: cardColor,

                child: InkWell(
                  borderRadius: BorderRadius.circular(12),

                  onTap: () {
                    context.router.push(EditTaskRoute(taskmodel: task));
                  },

                  child: ListTile(
                    leading: Checkbox(
                      value: task.isdone,

                      activeColor: primaryColor,

                      checkColor: isDark ? Colors.black : Colors.white,

                      side: BorderSide(color: primaryColor, width: 1.5),

                      onChanged: (bool? value) async {
                        await taskActions.toggleTaskDone(task);
                      },
                    ),

                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Expanded(
                              //gorev uzunsa saati dısarı tasırmaın diey
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isdone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: titleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            _buildFocusMinutes(task.id, primaryColor),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              'Due: ${task.date} ,',

                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                              ),
                            ),

                            Text(
                              'Priority: ${task.priority.isEmpty ? 'None' : task.priority}',

                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
