import 'package:budget_tracker/screens/home.dart';
import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:budget_tracker/services/local_storage_service.dart';
import 'package:budget_tracker/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async { // storage of data
  WidgetsFlutterBinding.ensureInitialized();
  final localStorageService = LocalStorageService();
  await localStorageService.initializeHive();
  final sharedPreferences = await SharedPreferences.getInstance();

  return runApp( // wrap your app
    MyApp(
      sharedPreferences: sharedPreferences,
    )
  );
}


class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({required this.sharedPreferences, Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider( // ThemeService (dark/light theme) + budget 
      providers: [
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService(sharedPreferences)),
        ChangeNotifierProvider<BudgetViewModel>(create: (_) => BudgetViewModel()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final themeService = Provider.of<ThemeService>(context);
          // final budgetService = Provider.of<BudgetViewModel>(context);
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    brightness: themeService.darkTheme
                        ? Brightness.dark
                        : Brightness.light,
                    seedColor: Colors.indigo),
              ),
              home: Home());
        },
      ),
    );
  }
}
