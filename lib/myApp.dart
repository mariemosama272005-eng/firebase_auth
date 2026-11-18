import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app/feature/auth/data/repo/auth_repo.dart';
import 'package:new_app/feature/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:new_app/feature/auth/presentation/ui/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepo(),
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepo: context.read<AuthRepo>(),
        ),
        child: MaterialApp(
          title: 'New App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF6C63FF),
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
