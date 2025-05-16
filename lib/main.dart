import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:alkaraj_assignment/presentation/screens/splash_screen.dart';
import 'package:alkaraj_assignment/business_logic/theme/theme_notifier.dart';
import 'package:alkaraj_assignment/business_logic/bloc/item_bloc.dart';
import 'package:alkaraj_assignment/data/repositories/item_repository.dart';
import 'package:alkaraj_assignment/business_logic/services/item_service_impl.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        Provider<ItemRepository>(create: (_) => ItemRepository()),
        Provider<ItemServiceImpl>(
          create: (context) => ItemServiceImpl(context.read<ItemRepository>()),
        ),
        BlocProvider<ItemBloc>(
          create: (context) => ItemBloc(context.read<ItemServiceImpl>())..add(LoadItems()),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeNotifier.themeMode,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
