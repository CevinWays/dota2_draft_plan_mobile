import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial());

  Future<void> register(
    String fullName,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    emit(RegisterLoading());
    try {
      final user = await registerUseCase.call(
        fullName,
        email,
        password,
        passwordConfirmation,
      );
      emit(RegisterSuccess(user));
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(RegisterError(errorMsg));
    }
  }
}
