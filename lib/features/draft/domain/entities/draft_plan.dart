import 'package:equatable/equatable.dart';

class DraftPlan extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int picks;
  final int bans;
  final int threats;
  final DateTime updatedAt;

  const DraftPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.picks,
    required this.bans,
    required this.threats,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    thumbnailUrl,
    picks,
    bans,
    threats,
    updatedAt,
  ];
}
