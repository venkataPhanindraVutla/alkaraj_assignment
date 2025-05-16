import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alkaraj_assignment/presentation/screens/splash_screen.dart';
import 'package:alkaraj_assignment/presentation/screens/home_screen.dart';
import 'package:alkaraj_assignment/business_logic/theme/theme_notifier.dart';
import 'package:alkaraj_assignment/business_logic/bloc/item_bloc.dart';
import 'package:alkaraj_assignment/data/repositories/item_repository.dart';
import 'package:alkaraj_assignment/business_logic/services/item_service_impl.dart';
import 'package:alkaraj_assignment/business_logic/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          create: (context) =>
              ItemBloc(context.read<ItemServiceImpl>())..add(LoadItems()),
        ),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return AnimatedTheme(
            data: themeNotifier.themeMode == ThemeMode.dark
                ? darkTheme
                : lightTheme,
            duration: const Duration(
              milliseconds: 300,
            ), // Adjust duration as needed
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeNotifier.themeMode,
              home: StreamBuilder<User?>(
                stream: context.read<AuthService>().user,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User? user = snapshot.data;
                    if (user == null) {
                      return SplashScreen();
                    } else {
                      return HomeScreen();
                    }
                  }
                  return SplashScreen();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
