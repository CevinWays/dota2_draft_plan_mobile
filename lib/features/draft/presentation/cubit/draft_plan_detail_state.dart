import 'package:equatable/equatable.dart';
import '../../domain/entities/draft_plan_detail.dart';

abstract class DraftPlanDetailState extends Equatable {
  const DraftPlanDetailState();

  @override
  List<Object?> get props => [];
}

class DraftPlanDetailInitial extends DraftPlanDetailState {}

class DraftPlanDetailLoading extends DraftPlanDetailState {}

class DraftPlanDetailLoaded extends DraftPlanDetailState {
  final DraftPlanDetail detail;

  const DraftPlanDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class DraftPlanDetailError extends DraftPlanDetailState {
  final String message;

  const DraftPlanDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
