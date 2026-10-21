import '../core/vec2.dart';
import 'body_temperament.dart';
import 'cultivation_realm.dart';
import 'domain.dart';
import 'element.dart';
import 'item.dart';
import 'law.dart';
import 'race.dart';
import 'resource_pool.dart';
import 'technique.dart';
import 'weapon.dart';

class PlayerStatus {
  // IDENTITY
  String name;
  int age;
  BodyTemperament temperament;
  PlayerRace race;
  List<Element> baseAffinities;
  List<DerivedElement> derivedAffinities;

  // CULTIVATION
  CultivationRealm realm;
  SubStage subStage;
  double cultivationExp;
  double cultivationExpNeeded;

  // RESOURCES
  ResourcePool qi;
  ResourcePool soul;
  ResourcePool body;
  ResourcePool health;

  // DERIVED ATTRIBUTES
  double attackPower;
  double defense;
  double speed;
  double spiritualSense;
  double luck;

  // FLIGHT
  bool isFlying;
  double flightTimeRemaining;
  bool canFlyPermanently;

  // TELEPORT
  bool canTeleportAtWill;
  double teleportCooldown;
  List<Vec2> teleportAnchors;

  // SOUL
  bool nascentSoulActive;
  bool isSoulForm;
  int rebirthsRemaining;

  // RACE PASSIVES (tickable)
  int tribulationImmunityRemaining;
  int immortalSparkCharges;

  // INVENTORY
  List<Item> inventory;
  Weapon? lifeBoundWeapon;
  List<Technique> knownTechniques;

  // DOMAIN / LAW
  Domain? domain;
  Law? masteredLaw;

  PlayerStatus({
    required this.name,
    this.age = 16,
    this.temperament = BodyTemperament.mortal,
    this.race = PlayerRace.human,
    List<Element>? baseAffinities,
    List<DerivedElement>? derivedAffinities,
    this.realm = CultivationRealm.qiCondensation,
    this.subStage = SubStage.early,
    this.cultivationExp = 0,
    this.cultivationExpNeeded = 100,
    required this.qi,
    required this.soul,
    required this.body,
    required this.health,
    this.attackPower = 5,
    this.defense = 5,
    this.speed = 5,
    this.spiritualSense = 5,
    this.luck = 5,
    this.isFlying = false,
    this.flightTimeRemaining = 0,
    this.canFlyPermanently = false,
    this.canTeleportAtWill = false,
    this.teleportCooldown = 0,
    List<Vec2>? teleportAnchors,
    this.nascentSoulActive = false,
    this.isSoulForm = false,
    this.rebirthsRemaining = 0,
    this.tribulationImmunityRemaining = 0,
    this.immortalSparkCharges = 0,
    List<Item>? inventory,
    this.lifeBoundWeapon,
    List<Technique>? knownTechniques,
    this.domain,
    this.masteredLaw,
  })  : baseAffinities = baseAffinities ?? [],
        derivedAffinities = derivedAffinities ?? [],
        teleportAnchors = teleportAnchors ?? [],
        inventory = inventory ?? [],
        knownTechniques = knownTechniques ?? [];
}