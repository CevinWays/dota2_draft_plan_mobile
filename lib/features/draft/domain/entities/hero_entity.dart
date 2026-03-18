import 'package:equatable/equatable.dart';

class HeroEntity extends Equatable {
  final int id;
  final String localizedName;
  final String primaryAttr; // 'str' | 'agi' | 'int' | 'all'
  final String imgUrl;

  const HeroEntity({
    required this.id,
    required this.localizedName,
    required this.primaryAttr,
    required this.imgUrl,
  });

  @override
  List<Object?> get props => [id, localizedName, primaryAttr, imgUrl];
}
