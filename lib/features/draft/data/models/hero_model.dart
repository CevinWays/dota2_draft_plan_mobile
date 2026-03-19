import 'package:dota2_draft_plan_mobile/features/draft/domain/entities/hero_entity.dart';

class HeroModel extends HeroEntity {
  const HeroModel({
    required super.id,
    required super.localizedName,
    required super.primaryAttr,
    required super.imgUrl,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    final img = json['icon']?.toString() ?? json['image']?.toString() ?? json['img']?.toString() ?? '';
    // OpenDota img paths are relative, e.g. "/apps/dota2/images/dota_react/heroes/axe.png"
    final imgUrl = img.startsWith('http') || img.isEmpty
        ? img
        : 'https://cdn.cloudflare.steamstatic.com$img';
    return HeroModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      localizedName: json['localized_name']?.toString() ?? '',
      primaryAttr: json['primary_attr']?.toString() ?? 'str',
      imgUrl: imgUrl,
    );
  }
}
