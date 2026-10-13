import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:todoapp/presentation/providers/login_provider.dart';
import 'package:todoapp/presentation/providers/task_provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';

@RoutePage()
class AuthWrapperPage extends StatelessWidget {
  const AuthWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        final taskProvider = context.read<TaskProvider>();

        if (loginProvider.user != null &&
            loginProvider.user?.uid != taskProvider.userid) {
          taskProvider.setUserId(loginProvider.user!.uid);
        } else if (loginProvider.user == null && taskProvider.userid != null) {
          taskProvider.setUserId(null);
        }

       
        return AutoRouter.declarative(
          routes: (_) => [
            if (loginProvider.user == null)
              const LoginRoute()
            else
              const TasksRoute(),
          ],
        );
      },
    );
  }
}
