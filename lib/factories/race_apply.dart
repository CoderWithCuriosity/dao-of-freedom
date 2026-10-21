import '../models/element.dart';
import '../models/item.dart';
import '../models/player_status.dart';
import '../models/race.dart';
import '../models/technique.dart';

/// Applies a race's multipliers and one-time passives to a freshly-created
/// PlayerStatus. Call once, at character creation, AFTER the base
/// PlayerStatus has been built and BEFORE it is saved.
///
/// Does not touch fields that are meant to evolve at runtime
/// (cultivationExp is not multiplied here — that happens per-gain in
/// the PlayerAbilities extension).
PlayerStatus applyRace(PlayerStatus s, RaceProfile r) {
  s.race = r.race;

  // ── Derived attributes ──
  s.attackPower *= r.attackMul;
  s.defense *= r.defenseMul;
  s.speed *= r.speedMul;
  s.spiritualSense *= r.spiritualSenseMul;
  s.luck *= r.luckMul;

  // ── Pools: scale max AND snap current to full ──
  s.health.max *= r.hpMul;
  s.health.current = s.health.max;

  s.qi.max *= r.qiMul;
  s.qi.current = s.qi.max;

  s.soul.max *= r.soulMul;
  s.soul.current = s.soul.max;

  s.body.max *= r.bodyMul;
  s.body.current = s.body.max;

  // ── Regen ──
  s.qi.regenPerSecond *= r.qiRegenMul;
  s.health.regenPerSecond += r.combatHpRegenBonus;
  s.soul.regenPerSecond += r.combatSoulRegenBonus;

  // ── Premium: Inherited Dao Memory — one free rare technique ──
  if (r.inheritedDaoMemory) {
    s.knownTechniques.add(_immortalStartingTechnique());
  }

  // ── Premium: starting currency ──
  if (r.startingSpiritStones > 0) {
    final stones = r.startingSpiritStones.toInt();
    s.inventory.add(Item(
      id: 'spirit_stone_low',
      name: 'Low-Grade Spirit Stone',
      description: 'Basic cultivation currency.',
      quantity: stones,
    ));
  }

  // ── Premium: tickable passives ──
  s.tribulationImmunityRemaining = r.tribulationImmunityRealms;
  s.immortalSparkCharges = r.immortalSparkRevives;

  return s;
}

/// One rare technique every Immortal gets at creation. Flavourful —
/// it's a *technique* object, not a stat boost, so it shows up in
/// the player's actual technique list.
Technique _immortalStartingTechnique() => const Technique(
      id: 'heaven_sever',
      name: 'Heaven Sever 天斩',
      description: 'A blade of pure intent. Ignores defense.',
      baseElement: Element.metal,
      qiCost: 25,
      cooldown: 4.0,
    );