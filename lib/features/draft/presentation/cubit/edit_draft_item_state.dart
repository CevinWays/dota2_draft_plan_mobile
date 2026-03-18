import 'package:equatable/equatable.dart';

abstract class EditDraftItemState extends Equatable {
  const EditDraftItemState();

  @override
  List<Object?> get props => [];
}

class EditDraftItemInitial extends EditDraftItemState {}

class EditDraftItemLoading extends EditDraftItemState {}

class EditDraftItemSuccess extends EditDraftItemState {}

class EditDraftItemError extends EditDraftItemState {
  final String message;

  const EditDraftItemError(this.message);

  @override
  List<Object?> get props => [message];
}
