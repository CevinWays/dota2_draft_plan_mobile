import 'package:equatable/equatable.dart';
import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/draft_plan.dart';

abstract class DraftPlanListState extends Equatable {
  const DraftPlanListState();

  @override
  List<Object?> get props => [];
}

class DraftPlanListInitial extends DraftPlanListState {
  const DraftPlanListInitial();
}

class DraftPlanListLoading extends DraftPlanListState {
  const DraftPlanListLoading();
}

class DraftPlanListLoaded extends DraftPlanListState {
  final List<DraftPlan> plans;

  const DraftPlanListLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

class DraftPlanListError extends DraftPlanListState {
  final String message;

  const DraftPlanListError(this.message);

  @override
  List<Object?> get props => [message];
}

class DraftPlanListLogout extends DraftPlanListState {
  const DraftPlanListLogout();
}
