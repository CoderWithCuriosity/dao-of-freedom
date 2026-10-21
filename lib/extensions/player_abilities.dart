import '../models/cultivation_realm.dart';
import '../models/element.dart';
import '../models/player_status.dart';
import '../models/race.dart';
import '../core/vec2.dart';

extension PlayerAbilities on PlayerStatus {
  // FLIGHT
  bool get canFlyTemporarily =>
      realm.index >= CultivationRealm.foundationEstablishment.index &&
      !canFlyPermanently;

  bool get canFlyNow =>
      canFlyPermanently || (canFlyTemporarily && qi.current > 5);

  void startFlight() {
    if (!canFlyNow) return;
    isFlying = true;
    if (canFlyTemporarily) {
      flightTimeRemaining = 10.0 + (realm.index * 5);
    }
  }

  void updateFlight(double dt) {
    if (!isFlying) return;
    if (canFlyTemporarily) {
      flightTimeRemaining -= dt;
      qi.consume(0.5 * dt);
      if (flightTimeRemaining <= 0 || qi.isEmpty) {
        isFlying = false;
        flightTimeRemaining = 0;
      }
    } else {
      qi.consume(0.05 * dt);
    }
  }

  // TELEPORT
  bool get canTeleportNow =>
      canTeleportAtWill && teleportCooldown <= 0 && qi.current >= 20;

  bool teleportTo(Vec2 target) {
    if (!canTeleportNow) return false;
    qi.consume(20);
    teleportCooldown = 1.0;
    return true;
  }

  // SOUL SURVIVAL
  bool get canSurviveBodyDeath => nascentSoulActive && rebirthsRemaining > 0;

  void onBodyDestroyed() {
    if (!canSurviveBodyDeath) return;
    rebirthsRemaining--;
    isSoulForm = true;
    health.current = health.max * 0.1;
  }

  // ── IMMORTAL'S SPARK ─────────────────────────────────────────────
  /// Call when health.current would reach 0. Consumes one charge and
  /// restores to 50% HP. Returns true if the revive was consumed
  /// (player survives), false if the player should die normally.
  bool tryImmortalRevive() {
    if (immortalSparkCharges <= 0) return false;
    immortalSparkCharges--;
    health.current = health.max * 0.5;
    // TODO: trigger a golden revive effect in the Flame game layer.
    return true;
  }

  // ELEMENT QUERIES
  bool get hasIceAffinity =>
      derivedAffinities.contains(DerivedElement.ice) ||
      baseAffinities.contains(Element.water);

  bool canWield(DerivedElement element) {
    if (derivedAffinities.contains(element)) return true;
    final parent = derivedParent[element];
    return parent != null && baseAffinities.contains(parent);
  }

  // CULTIVATION PROGRESS
  bool get canBreakthrough => cultivationExp >= cultivationExpNeeded;

  /// Race-adjusted exp gain.
  void gainCultivationExp(double amount) {
    final mul = raceProfileFor(race).cultivationSpeedMul;
    cultivationExp += amount * mul;
  }

  /// Try to break through. Consumes tribulation immunity if the player
  /// has any (Immortal first-breakthrough protection).
  /// Returns true if the breakthrough actually happened.
  bool attemptBreakthrough() {
    if (!canBreakthrough) return false;

    if (tribulationImmunityRemaining > 0) {
      tribulationImmunityRemaining--;
      _doBreakthrough();
      return true;
    }

    // Future: roll a random tribulation failure here for non-Immortal.
    _doBreakthrough();
    return true;
  }

  /// Backwards-compatible alias for the old signature.
  void breakthrough() => attemptBreakthrough();

  void _doBreakthrough() {
    if (subStage == SubStage.late) {
      if (realm.index < CultivationRealm.values.length - 1) {
        realm = CultivationRealm.values[realm.index + 1];
        subStage = SubStage.early;
      }
    } else {
      subStage = SubStage.values[subStage.index + 1];
    }

    cultivationExp = 0;
    cultivationExpNeeded *= 2.5;
    _applyRealmBonuses();
    refreshRealmUnlocks();
    _applyHalfBloodLateScaling();
  }

  void _applyRealmBonuses() {
    final realmMultiplier = 1.0 + (realm.index * 0.8);
    qi.max = 10 * realmMultiplier;
    qi.current = qi.max;
    health.max = 100 * realmMultiplier;
    health.current = health.max;
    attackPower *= 1.5;
    defense *= 1.5;
    speed *= 1.3;
    spiritualSense *= 1.4;
  }

  /// Half-blood's "hard start / strong late" payoff — small stacking
  /// boosts from Foundation Establishment onward.
  void _applyHalfBloodLateScaling() {
    if (race != PlayerRace.halfBlood) return;
    if (realm.index < CultivationRealm.foundationEstablishment.index) return;
    attackPower *= 1.10;
    defense *= 1.10;
    speed *= 1.05;
    spiritualSense *= 1.05;
  }

  /// Public so tests / save-load / cheat codes can call it.
  void refreshRealmUnlocks() {
    switch (realm) {
      case CultivationRealm.foundationEstablishment:
        // temporary flight now available
        break;
      case CultivationRealm.coreFormation:
        canFlyPermanently = true;
        break;
      case CultivationRealm.nascentSoul:
        nascentSoulActive = true;
        rebirthsRemaining = 1;
        break;
      case CultivationRealm.voidRefinement:
        canTeleportAtWill = true;
        break;
      default:
        break;
    }
  }
}