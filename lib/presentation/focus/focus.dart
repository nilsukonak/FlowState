import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/helpers/focus_time_formatter.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/focus_provider.dart';

@RoutePage()
class FocusPage extends StatefulWidget {
  final Taskmodel task;

  const FocusPage({super.key, required this.task});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  late FocusProvider _focusProvider;
  @override
  void initState() {
    super.initState();

    _focusProvider = context.read<FocusProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _focusProvider.selectTask(widget.task.id!);
    });
  }

  @override
  @override
  void dispose() {
    _focusProvider.leaveFocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final minutes = focusProvider.remainingSeconds ~/ 60;
    final seconds = focusProvider.remainingSeconds % 60; //dk ve sny hesabı
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Focus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Seçilen görev
              Text(
                widget.task.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              // Görevin kategorisi
              Text(
                widget.task.category,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Total Focus: ${formatFocusTime(focusProvider.totalFocusSeconds)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 36),

              // Timer
              Text(
                '$minutes:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Focus Session',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 36),

              const Divider(),

              const SizedBox(height: 20),

              // Pomodoro göstergeleri
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isCompleted = index < focusProvider.completedSessions;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 30,
                      color: isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 14),

              Text(
                '${focusProvider.completedSessions} / 4 sessions',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                '${focusProvider.completedCycles} cycles completed',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (focusProvider.isCycleCompleted) ...[
                //eger icteki sey true olursa altaki widgetkeri calıstr dyoz
                const SizedBox(height: 16),

                Text(
                  '🎉 Congratulations!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'You completed 100 minutes of focus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              const Divider(),

              const SizedBox(height: 30),

              // Start / Pause / Resume
              SizedBox(
                width: 180,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (focusProvider.isCycleCompleted) {
                      context.read<FocusProvider>().startNewCycle();
                    } else if (focusProvider.isRunning) {
                      context.read<FocusProvider>().pauseTimer();
                    } else {
                      context.read<FocusProvider>().startTimer();
                    }
                  },
                  icon: Icon(
                    focusProvider.isRunning ? Icons.pause : Icons.play_arrow,
                  ),
                  label: Text(
                    focusProvider.isCycleCompleted
                        ? 'Start New Cycle'
                        : focusProvider.isRunning
                        ? 'Pause'
                        : focusProvider.remainingSeconds == 0
                        ? 'Start Next'
                        : focusProvider.remainingSeconds <
                              FocusProvider.focusDuration
                        ? 'Resume'
                        : 'Start',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Reset
              TextButton.icon(
                onPressed: () {
                  context.read<FocusProvider>().resetTimer();
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset'),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
