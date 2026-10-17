import '../models/body_temperament.dart';
import '../models/cultivation_realm.dart';
import '../models/element.dart';
import '../models/player_status.dart';
import '../models/resource_pool.dart';

class PlayerStatusFactory {
  PlayerStatusFactory._();

  /// A brand-new mortal cultivator at Qi Condensation Early.
  static PlayerStatus newCultivator(
    String name, {
    List<Element>? baseAffinities,
    List<DerivedElement>? derivedAffinities,
    BodyTemperament temperament = BodyTemperament.mortal,
  }) {
    return PlayerStatus(
      name: name,
      temperament: temperament,
      baseAffinities: baseAffinities,
      derivedAffinities: derivedAffinities,
      realm: CultivationRealm.qiCondensation,
      subStage: SubStage.early,
      qi: ResourcePool(current: 10, max: 10, regenPerSecond: 1.0),
      soul: ResourcePool(current: 5, max: 5, regenPerSecond: 0.2),
      body: ResourcePool(current: 20, max: 20, regenPerSecond: 0.5),
      health: ResourcePool(current: 100, max: 100, regenPerSecond: 0.1),
    );
  }

  /// A Foundation Establishment cultivator — can fly temporarily.
  static PlayerStatus foundationCultivator(
    String name, {
    List<Element>? baseAffinities,
    List<DerivedElement>? derivedAffinities,
  }) {
    return PlayerStatus(
      name: name,
      age: 40,
      baseAffinities: baseAffinities,
      derivedAffinities: derivedAffinities,
      realm: CultivationRealm.foundationEstablishment,
      subStage: SubStage.early,
      qi: ResourcePool(current: 200, max: 200, regenPerSecond: 5.0),
      soul: ResourcePool(current: 50, max: 50, regenPerSecond: 1.0),
      body: ResourcePool(current: 100, max: 100, regenPerSecond: 2.0),
      health: ResourcePool(current: 500, max: 500, regenPerSecond: 1.0),
      attackPower: 50,
      defense: 40,
      speed: 30,
      spiritualSense: 25,
    );
  }

  /// A Void Refinement cultivator — can teleport at will.
  static PlayerStatus voidRefinementCultivator(
    String name, {
    List<Element>? baseAffinities,
    List<DerivedElement>? derivedAffinities,
  }) {
    return PlayerStatus(
      name: name,
      age: 1500,
      baseAffinities: baseAffinities,
      derivedAffinities: derivedAffinities,
      realm: CultivationRealm.voidRefinement,
      subStage: SubStage.early,
      qi: ResourcePool(current: 5000, max: 5000, regenPerSecond: 100),
      soul: ResourcePool(current: 3000, max: 3000, regenPerSecond: 20),
      body: ResourcePool(current: 2000, max: 2000, regenPerSecond: 10),
      health: ResourcePool(current: 20000, max: 20000, regenPerSecond: 5),
      attackPower: 2000,
      defense: 1500,
      speed: 800,
      spiritualSense: 1200,
      canFlyPermanently: true,
      canTeleportAtWill: true,
      nascentSoulActive: true,
      rebirthsRemaining: 1,
    );
  }
}