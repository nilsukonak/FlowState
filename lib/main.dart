import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/data/firebase_options.dart';
import 'package:todoapp/presentation/providers/providers.dart';
import 'package:todoapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/presentation/routes/app_router.dart';
import 'package:todoapp/services/notification_service.dart';
import 'package:todoapp/presentation/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.initialize();
  //await NotificationService.instance.scheduleTestNotification();
  runApp(MultiProvider(providers: appProviders, child: MyApp()));
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter(); // << burada router nesnesini oluştur
  @override
  Widget build(BuildContext context) {
    final themeprovider = context.watch<ThemeProvider>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: themeprovider.isDarkMode
          ? AppTheme.darktheme
          : AppTheme.lighttheme,

      // home: AuthWrapperScreen(),
      routerConfig: _appRouter.config(),
    );
  }
}
