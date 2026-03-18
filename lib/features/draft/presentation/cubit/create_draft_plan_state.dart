import 'package:equatable/equatable.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan.dart';

abstract class CreateDraftPlanState extends Equatable {
  const CreateDraftPlanState();
  @override
  List<Object?> get props => [];
}

class CreateDraftPlanInitial extends CreateDraftPlanState {
  const CreateDraftPlanInitial();
}

class CreateDraftPlanLoading extends CreateDraftPlanState {
  const CreateDraftPlanLoading();
}

class CreateDraftPlanSuccess extends CreateDraftPlanState {
  final DraftPlan plan;
  const CreateDraftPlanSuccess(this.plan);
  @override
  List<Object?> get props => [plan];
}

class CreateDraftPlanError extends CreateDraftPlanState {
  final String message;
  const CreateDraftPlanError(this.message);
  @override
  List<Object?> get props => [message];
}
