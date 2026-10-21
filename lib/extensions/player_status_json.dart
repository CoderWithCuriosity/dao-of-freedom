import '../core/vec2.dart';
import '../models/body_temperament.dart';
import '../models/cultivation_realm.dart';
import '../models/domain.dart';
import '../models/element.dart';
import '../models/item.dart';
import '../models/law.dart';
import '../models/player_status.dart';
import '../models/race.dart';
import '../models/resource_pool.dart';
import '../models/technique.dart';
import '../models/weapon.dart';

PlayerRace _raceFromNameSafe(Object? raw) {
  if (raw is! String) return PlayerRace.human;
  try {
    return PlayerRace.values.byName(raw);
  } catch (_) {
    return PlayerRace.human;
  }
}

extension PlayerStatusJson on PlayerStatus {
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'temperament': temperament.name,
    'race': race.name,
    'baseAffinities': baseAffinities.map((e) => e.name).toList(),
    'derivedAffinities': derivedAffinities.map((e) => e.name).toList(),
    'realm': realm.name,
    'subStage': subStage.name,
    'cultivationExp': cultivationExp,
    'cultivationExpNeeded': cultivationExpNeeded,
    'qi': qi.toJson(),
    'soul': soul.toJson(),
    'body': body.toJson(),
    'health': health.toJson(),
    'attackPower': attackPower,
    'defense': defense,
    'speed': speed,
    'spiritualSense': spiritualSense,
    'luck': luck,
    'isFlying': isFlying,
    'flightTimeRemaining': flightTimeRemaining,
    'canFlyPermanently': canFlyPermanently,
    'canTeleportAtWill': canTeleportAtWill,
    'teleportCooldown': teleportCooldown,
    'teleportAnchors': teleportAnchors.map((v) => v.toJson()).toList(),
    'nascentSoulActive': nascentSoulActive,
    'isSoulForm': isSoulForm,
    'rebirthsRemaining': rebirthsRemaining,
    'tribulationImmunityRemaining': tribulationImmunityRemaining,
    'immortalSparkCharges': immortalSparkCharges,
    'inventory': inventory.map((i) => i.toJson()).toList(),
    'lifeBoundWeapon': lifeBoundWeapon?.toJson(),
    'knownTechniques': knownTechniques.map((t) => t.toJson()).toList(),
    'domain': domain?.toJson(),
    'masteredLaw': masteredLaw?.toJson(),
  };
}

PlayerStatus playerStatusFromJson(Map<String, dynamic> json) => PlayerStatus(
  name: json['name'] as String,
  age: json['age'] as int? ?? 16,
  temperament: BodyTemperament.values.byName(
    json['temperament'] as String? ?? 'mortal',
  ),
  race: _raceFromNameSafe(json['race']),
  baseAffinities: (json['baseAffinities'] as List<dynamic>? ?? [])
      .map((e) => Element.values.byName(e as String))
      .toList(),
  derivedAffinities: (json['derivedAffinities'] as List<dynamic>? ?? [])
      .map((e) => DerivedElement.values.byName(e as String))
      .toList(),
  realm: CultivationRealm.values.byName(json['realm'] as String),
  subStage: SubStage.values.byName(json['subStage'] as String),
  cultivationExp: (json['cultivationExp'] as num).toDouble(),
  cultivationExpNeeded: (json['cultivationExpNeeded'] as num).toDouble(),
  qi: ResourcePool.fromJson(json['qi'] as Map<String, dynamic>),
  soul: ResourcePool.fromJson(json['soul'] as Map<String, dynamic>),
  body: ResourcePool.fromJson(json['body'] as Map<String, dynamic>),
  health: ResourcePool.fromJson(json['health'] as Map<String, dynamic>),
  attackPower: (json['attackPower'] as num).toDouble(),
  defense: (json['defense'] as num).toDouble(),
  speed: (json['speed'] as num).toDouble(),
  spiritualSense: (json['spiritualSense'] as num).toDouble(),
  luck: (json['luck'] as num?)?.toDouble() ?? 5,
  isFlying: json['isFlying'] as bool? ?? false,
  flightTimeRemaining: (json['flightTimeRemaining'] as num?)?.toDouble() ?? 0,
  canFlyPermanently: json['canFlyPermanently'] as bool? ?? false,
  canTeleportAtWill: json['canTeleportAtWill'] as bool? ?? false,
  teleportCooldown: (json['teleportCooldown'] as num?)?.toDouble() ?? 0,
  teleportAnchors: (json['teleportAnchors'] as List<dynamic>? ?? [])
      .map((v) => Vec2.fromJson(v as Map<String, dynamic>))
      .toList(),
  nascentSoulActive: json['nascentSoulActive'] as bool? ?? false,
  isSoulForm: json['isSoulForm'] as bool? ?? false,
  rebirthsRemaining: json['rebirthsRemaining'] as int? ?? 0,
  tribulationImmunityRemaining:
      (json['tribulationImmunityRemaining'] as num?)?.toInt() ?? 0,
  immortalSparkCharges:
      (json['immortalSparkCharges'] as num?)?.toInt() ?? 0,
  inventory: (json['inventory'] as List<dynamic>? ?? [])
      .map((i) => Item.fromJson(i as Map<String, dynamic>))
      .toList(),
  lifeBoundWeapon: json['lifeBoundWeapon'] != null
      ? Weapon.fromJson(json['lifeBoundWeapon'] as Map<String, dynamic>)
      : null,
  knownTechniques: (json['knownTechniques'] as List<dynamic>? ?? [])
      .map((t) => Technique.fromJson(t as Map<String, dynamic>))
      .toList(),
  domain: json['domain'] != null
      ? Domain.fromJson(json['domain'] as Map<String, dynamic>)
      : null,
  masteredLaw: json['masteredLaw'] != null
      ? Law.fromJson(json['masteredLaw'] as Map<String, dynamic>)
      : null,
);