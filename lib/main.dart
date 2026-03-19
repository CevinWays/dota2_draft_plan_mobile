import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/core/di/injection_container.dart' as di;
import 'package:dota2_draft_plan_mobile/core/theme/app_theme.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/splash_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dota 2 Draft Plan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: BlocProvider(
        create: (_) => di.sl<SplashCubit>(),
        child: const SplashPage(),
      ),
    );
  }
}
