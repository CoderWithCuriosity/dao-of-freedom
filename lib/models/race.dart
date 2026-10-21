// lib/models/race.dart

enum PlayerRace { human, demon, spirit, halfBlood, immortal }

class RaceProfile {
  final PlayerRace race;
  final String displayName; // "Human", "Demon 妖族"
  final String identity; // one-line description

  // ── Core multipliers (default 1.0) ─────────────────────────────────
  final double attackMul;
  final double defenseMul;
  final double speedMul;
  final double spiritualSenseMul;
  final double luckMul;
  final double hpMul;
  final double qiMul;
  final double soulMul;
  final double bodyMul;

  // ── Economy / progression ──────────────────────────────────────────
  final double cultivationSpeedMul; // multiplies exp gain
  final double qiRegenMul;

  // ── Social / gating ────────────────────────────────────────────────
  final double sectTrust; // 0..1
  final double yangVulnerability; // 1.0 = none, 1.5 = 50% extra dmg
  final bool startsUnlocked; // false = Immortal Descendant

  // ── Signature flags (read by systems, not just UI) ────────────────
  final bool hasTransformation; // demon
  final bool soulFormNative; // spirit
  final bool hybridLateScaling; // half-blood

  // ── Premium passives (Immortal Descendant) ────────────────────────
  final bool heavenFavor; // luck does something real (crit + drops)
  final int tribulationImmunityRealms; // first N breakthroughs can't fail
  final int immortalSparkRevives; // free revives per run
  final bool inheritedDaoMemory; // bonus exp + free technique + anchors
  final bool startsAtQiCondMid; // begin at Qi Condensation Mid
  final double startingSpiritStones; // free currency at creation
  final double combatHpRegenBonus; // added to health.regenPerSecond
  final double combatSoulRegenBonus; // added to soul.regenPerSecond

  const RaceProfile({
    required this.race,
    required this.displayName,
    required this.identity,

    // Multipliers
    this.attackMul = 1,
    this.defenseMul = 1,
    this.speedMul = 1,
    this.spiritualSenseMul = 1,
    this.luckMul = 1,
    this.hpMul = 1,
    this.qiMul = 1,
    this.soulMul = 1,
    this.bodyMul = 1,

    // Economy / progression
    this.cultivationSpeedMul = 1,
    this.qiRegenMul = 1,

    // Social / gating
    this.sectTrust = 1,
    this.yangVulnerability = 1,
    this.startsUnlocked = true,

    // Signature flags
    this.hasTransformation = false,
    this.soulFormNative = false,
    this.hybridLateScaling = false,

    // Premium passives
    this.heavenFavor = false,
    this.tribulationImmunityRealms = 0,
    this.immortalSparkRevives = 0,
    this.inheritedDaoMemory = false,
    this.startsAtQiCondMid = false,
    this.startingSpiritStones = 0,
    this.combatHpRegenBonus = 0,
    this.combatSoulRegenBonus = 0,
  });
}

// ─────────────────────────────────────────────────────────────────────
// RACE DEFINITIONS
// ─────────────────────────────────────────────────────────────────────

const humanRace = RaceProfile(
  race: PlayerRace.human,
  displayName: 'Human',
  identity: 'Balanced all-rounder, fastest cultivation, easy sect access.',
  cultivationSpeedMul: 1.15,
);

const demonRace = RaceProfile(
  race: PlayerRace.demon,
  displayName: 'Demon 妖族',
  identity: 'Beast lineage, raw physique, powerful transformations.',
  attackMul: 1.30,
  defenseMul: 1.25,
  speedMul: 1.05,
  spiritualSenseMul: 0.85,
  luckMul: 0.95,
  hpMul: 1.35,
  qiMul: 0.90,
  soulMul: 0.85,
  bodyMul: 1.30,
  cultivationSpeedMul: 0.90,
  qiRegenMul: 0.8,
  sectTrust: 0.4,
  hasTransformation: true,
);

const spiritRace = RaceProfile(
  race: PlayerRace.spirit,
  displayName: 'Spirit 鬼修',
  identity: 'Yin-aligned soul cultivator. Eerie powers, weak to yang.',
  attackMul: 0.90,
  defenseMul: 0.85,
  speedMul: 1.20,
  spiritualSenseMul: 1.30,
  luckMul: 1.05,
  hpMul: 0.80,
  qiMul: 1.30,
  soulMul: 1.50,
  bodyMul: 0.75,
  cultivationSpeedMul: 1.00,
  qiRegenMul: 1.4,
  sectTrust: 0.2,
  yangVulnerability: 1.5,
  soulFormNative: true,
);

const halfBloodRace = RaceProfile(
  race: PlayerRace.halfBlood,
  displayName: 'Half-Blood 人妖混血',
  identity: 'Hybrid build. Hard early game, strong late.',
  attackMul: 1.10,
  defenseMul: 1.05,
  speedMul: 1.00,
  spiritualSenseMul: 1.00,
  luckMul: 0.90,
  hpMul: 1.10,
  qiMul: 1.00,
  soulMul: 0.95,
  bodyMul: 1.10,
  cultivationSpeedMul: 0.85,
  qiRegenMul: 1.0,
  sectTrust: 0.3,
  hybridLateScaling: true,
);

const immortalRace = RaceProfile(
  race: PlayerRace.immortal,
  displayName: 'Immortal Descendant 仙裔',
  identity: 'Fallen immortal bloodline. No weaknesses. No equal.',

  // Stats — best in class, but not absurd. ~1.25-1.35× across the board.
  attackMul: 1.25,
  defenseMul: 1.20,
  speedMul: 1.15,
  spiritualSenseMul: 1.30,
  luckMul: 1.40,
  hpMul: 1.25,
  qiMul: 1.35,
  soulMul: 1.30,
  bodyMul: 1.20,

  // Progression
  cultivationSpeedMul: 1.35,
  qiRegenMul: 1.5,

  // Social
  sectTrust: 0.95,
  yangVulnerability: 0.90, // slight resistance, not immunity

  // Gating
  startsUnlocked: false,

  // Premium passives — trimmed to the "cool, not cheat" set
  heavenFavor: true, // luck → real crit + drop bonus
  tribulationImmunityRealms: 1, // ONLY the first breakthrough is safe
  immortalSparkRevives: 1, // one free revive per run
  inheritedDaoMemory: true, // free rare technique at creation (single gift)
  startsAtQiCondMid: false, // cut — don't skip content
  startingSpiritStones: 150, // small cushion, not a bankroll
  combatHpRegenBonus: 1.0, // passive regen, visible but not broken
  combatSoulRegenBonus: 0.5,
);

const allRaces = <RaceProfile>[
  humanRace,
  demonRace,
  spiritRace,
  halfBloodRace,
  immortalRace,
];

// ─────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────

/// Look up a race profile by enum. Safe fallback to human.
RaceProfile raceProfileFor(PlayerRace race) {
  for (final r in allRaces) {
    if (r.race == race) return r;
  }
  return humanRace;
}

/// Defensive lookup — never throws on bad save data.
RaceProfile profileForRaceNameSafe(String? name) {
  if (name == null) return humanRace;
  try {
    return raceProfileFor(PlayerRace.values.byName(name));
  } catch (_) {
    return humanRace;
  }
}