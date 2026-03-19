import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/splash_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/splash_state.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dota2_draft_plan_mobile/features/auth/presentation/cubit/login_cubit.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/pages/draft_plan_list_page.dart';
import 'package:dota2_draft_plan_mobile/features/draft/presentation/cubit/draft_plan_list_cubit.dart';
import 'package:dota2_draft_plan_mobile/core/di/injection_container.dart' as di;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkLoggingIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<DraftPlanListCubit>()..loadDraftPlans(),
                child: const DraftPlanListPage(),
              ),
            ),
          );
        } else if (state is SplashUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.sl<LoginCubit>(),
                child: const LoginPage(),
              ),
            ),
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, size: 80, color: Colors.blueAccent),
              SizedBox(height: 16),
              Text(
                'Dota 2 Draft Plan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
