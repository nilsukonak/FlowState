import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

import 'package:todoapp/presentation/screens/tasks/tasklist.dart';
import 'package:todoapp/presentation/widgets/chip_selector.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _searchController =
      TextEditingController(); //arama bcuugnu x ile direkt silmek içn

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context
        .watch<
          TaskProvider
        >(); //görev tamamlandığında Dashboard otomatik güncellenir.

    final themeprovider = Provider.of<ThemeProvider>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.router.replaceAll([const LoginRoute()]);
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: Text(
            'Task List ',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                themeprovider.toogleTheme();
              },
            ),

            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                try {
                  await context.read<LoginProvider>().logout();

                  context.router.replaceAll([const AuthWrapperRoute()]);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Çıkış başarısız: $e')),
                  );
                }
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Progress',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${(taskProvider.completionRate * 100).round()}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      LinearProgressIndicator(
                        value: taskProvider.completionRate,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${taskProvider.completedTasks}/${taskProvider.totalTasks} Completed',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${taskProvider.activeTasks} Active',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<TaskProvider>().setSearchQuery(value);

                    setState(() {});
                  }, //read yaptk cunku araam cubugu porvideri surekli değil sadece bşe yazılınca dinlesn
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<TaskProvider>().setSearchQuery('');

                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                  ),
                ),
              ),

              //araam cubugu için uı
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Chipapp(
                    chiplist: ['All', 'Completed', 'Active'],
                    selectedValue: context
                        .watch<TaskProvider>()
                        .selectedFilter
                        .name,
                    onchipselected: (selected) {
                      final option = FilterOption.values.firstWhere(
                        (e) => e.name == selected,
                      );
                      context.read<TaskProvider>().changeFilter(option);
                    },
                    showCheckmark: true,
                  ),
                ],
              ),

              const TasklistPage(),
            ],
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // START FOCUS
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final activeTasks = context
                          .read<TaskProvider>()
                          .filteredTasks
                          .where((task) => !task.isdone)
                          .toList();

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (sheetContext) {
                          String?
                          selectedTaskId; //? ded cunku ilk basta daha hiçbiri seçili değilken null oluy

                          return StatefulBuilder(
                            builder: (context, setModalState) {
                              return SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Start Focus',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      const Text(
                                        'Which task would you like to focus on?',
                                      ),

                                      const SizedBox(height: 16),

                                      if (activeTasks.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'No active tasks available.',
                                            ),
                                          ),
                                        )
                                      else
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: activeTasks.length,
                                            itemBuilder: (context, index) {
                                              final task = activeTasks[index];

                                              return RadioListTile<String>(
                                                title: Text(task.title),
                                                value: task.id!,
                                                groupValue: selectedTaskId,
                                                activeColor: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                onChanged: (value) {
                                                  setModalState(() {
                                                    selectedTaskId = value;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),

                                      const SizedBox(height: 16),

                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: selectedTaskId == null
                                              ? null
                                              : () {
                                                  final selectedTask =
                                                      activeTasks.firstWhere(
                                                        (task) =>
                                                            task.id ==
                                                            selectedTaskId,
                                                      ); //first where ile kouslu saglayan hepsini değil sadece ilkini alıyo

                                                  // Sonraki adımda FocusPage'e aktaracağız.
                                                  debugPrint(
                                                    'Selected focus task: ${selectedTask.title}',
                                                  );

                                                  Navigator.pop(sheetContext);

                                                  context.router.push(
                                                    FocusRoute(
                                                      task: selectedTask,
                                                    ),
                                                  );
                                                },
                                          child: const Text('Continue'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.timer_outlined),
                    label: const Text(
                      'Start Focus',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ADD TASK
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.push(const NewtasksRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      '+ Add Task',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
