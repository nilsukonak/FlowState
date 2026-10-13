// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthWrapperRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthWrapperPage(),
      );
    },
    EditTaskRoute.name: (routeData) {
      final args = routeData.argsAs<EditTaskRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditTaskPage(
          key: args.key,
          taskmodel: args.taskmodel,
        ),
      );
    },
    FocusRoute.name: (routeData) {
      final args = routeData.argsAs<FocusRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FocusPage(
          key: args.key,
          task: args.task,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    NewtasksRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NewtasksPage(),
      );
    },
    SigninRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SigninPage(),
      );
    },
    TasklistRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TasklistPage(),
      );
    },
    TasksRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TasksPage(),
      );
    },
  };
}

/// generated route for
/// [AuthWrapperPage]
class AuthWrapperRoute extends PageRouteInfo<void> {
  const AuthWrapperRoute({List<PageRouteInfo>? children})
      : super(
          AuthWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthWrapperRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditTaskPage]
class EditTaskRoute extends PageRouteInfo<EditTaskRouteArgs> {
  EditTaskRoute({
    Key? key,
    required Taskmodel taskmodel,
    List<PageRouteInfo>? children,
  }) : super(
          EditTaskRoute.name,
          args: EditTaskRouteArgs(
            key: key,
            taskmodel: taskmodel,
          ),
          initialChildren: children,
        );

  static const String name = 'EditTaskRoute';

  static const PageInfo<EditTaskRouteArgs> page =
      PageInfo<EditTaskRouteArgs>(name);
}

class EditTaskRouteArgs {
  const EditTaskRouteArgs({
    this.key,
    required this.taskmodel,
  });

  final Key? key;

  final Taskmodel taskmodel;

  @override
  String toString() {
    return 'EditTaskRouteArgs{key: $key, taskmodel: $taskmodel}';
  }
}

/// generated route for
/// [FocusPage]
class FocusRoute extends PageRouteInfo<FocusRouteArgs> {
  FocusRoute({
    Key? key,
    required Taskmodel task,
    List<PageRouteInfo>? children,
  }) : super(
          FocusRoute.name,
          args: FocusRouteArgs(
            key: key,
            task: task,
          ),
          initialChildren: children,
        );

  static const String name = 'FocusRoute';

  static const PageInfo<FocusRouteArgs> page = PageInfo<FocusRouteArgs>(name);
}

class FocusRouteArgs {
  const FocusRouteArgs({
    this.key,
    required this.task,
  });

  final Key? key;

  final Taskmodel task;

  @override
  String toString() {
    return 'FocusRouteArgs{key: $key, task: $task}';
  }
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NewtasksPage]
class NewtasksRoute extends PageRouteInfo<void> {
  const NewtasksRoute({List<PageRouteInfo>? children})
      : super(
          NewtasksRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewtasksRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SigninPage]
class SigninRoute extends PageRouteInfo<void> {
  const SigninRoute({List<PageRouteInfo>? children})
      : super(
          SigninRoute.name,
          initialChildren: children,
        );

  static const String name = 'SigninRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TasklistPage]
class TasklistRoute extends PageRouteInfo<void> {
  const TasklistRoute({List<PageRouteInfo>? children})
      : super(
          TasklistRoute.name,
          initialChildren: children,
        );

  static const String name = 'TasklistRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TasksPage]
class TasksRoute extends PageRouteInfo<void> {
  const TasksRoute({List<PageRouteInfo>? children})
      : super(
          TasksRoute.name,
          initialChildren: children,
        );

  static const String name = 'TasksRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
