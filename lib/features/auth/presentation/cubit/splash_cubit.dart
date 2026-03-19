import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  SplashCubit({required this.checkAuthStatusUseCase}) : super(const SplashInitial());

  Future<void> checkLoggingIn() async {
    emit(const SplashLoading());
    try {
      //INFO Delay for 2 seconds splash screen
      await Future.delayed(const Duration(seconds: 2));
      
      final isAuthenticated = await checkAuthStatusUseCase();
      if (isAuthenticated) {
        emit(const SplashAuthenticated());
      } else {
        emit(const SplashUnauthenticated());
      }
    } catch (_) {
      emit(const SplashUnauthenticated());
    }
  }
}
