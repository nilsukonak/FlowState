import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';

import 'package:todoapp/presentation/screens/auth/auth_wrapper_page.dart';
import 'package:todoapp/presentation/screens/auth/login.dart';
import 'package:todoapp/presentation/screens/auth/signin.dart';
import 'package:todoapp/presentation/screens/tasks/tasks.dart';
import 'package:todoapp/presentation/screens/tasks/tasklist.dart';
import 'package:todoapp/presentation/screens/tasks/newtasks.dart';
import 'package:todoapp/presentation/screens/tasks/edittask.dart';
import 'package:todoapp/presentation/focus/focus.dart';
import 'package:todoapp/presentation/screens/auth/forgot_password.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AuthWrapperRoute.page,
      initial: true,
      children: [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: TasksRoute.page),
      ],
    ),

    AutoRoute(page: SigninRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(page: TasklistRoute.page),
    AutoRoute(page: NewtasksRoute.page),
    AutoRoute(page: EditTaskRoute.page),
    AutoRoute(page: FocusRoute.page),
  ];
}
