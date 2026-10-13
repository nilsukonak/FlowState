import 'package:provider/provider.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';
import 'package:todoapp/presentation/providers/dropdown_provider.dart';
import 'package:todoapp/data/repositories/task_repository.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';
import 'package:todoapp/presentation/providers/focus_provider.dart';

// önce repository'yi tanımla
final taskRepository = TaskRepository();

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => LoginProvider()),
  ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ChangeNotifierProvider(create: (_) => TaskProvider(taskRepository)),
  ChangeNotifierProvider(create: (_) => DropdownProvider()),
  ChangeNotifierProvider(create: (_) => FocusProvider()),
];
