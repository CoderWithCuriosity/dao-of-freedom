import 'dart:convert';

// ─── File-based backend (mobile / desktop only) ───────────────────────
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// ─── Shared-preferences backend (works everywhere, incl. web) ─────────
import 'package:shared_preferences/shared_preferences.dart';

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
import '../extensions/player_status_json.dart';

class SaveService {
  static const String _fileName = 'dao_save.json';
  static const String _saveKey = 'dao_save';

  // ═══════════════════════════════════════════════════════════════════
  // FILE-BASED BACKEND (commented out)
  // ═══════════════════════════════════════════════════════════════════
  //
  // Future<File> _getSaveFile() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return File('${directory.path}/$_fileName');
  // }
  //
  // Future<void> savePlayer(PlayerStatus status) async {
  //   try {
  //     final file = await _getSaveFile();
  //     final jsonString = jsonEncode(status.toJson());
  //     await file.writeAsString(jsonString);
  //     print('Game saved successfully (file).');
  //   } catch (e) {
  //     print('Error saving game: $e');
  //   }
  // }
  //
  // Future<PlayerStatus?> loadPlayer() async {
  //   try {
  //     final file = await _getSaveFile();
  //     if (await file.exists()) {
  //       final jsonString = await file.readAsString();
  //       return playerStatusFromJson(jsonDecode(jsonString));
  //     }
  //   } catch (e) {
  //     print('Error loading game: $e');
  //   }
  //   return null;
  // }
  //
  // Future<void> deleteSave() async {
  //   try {
  //     final file = await _getSaveFile();
  //     if (await file.exists()) {
  //       await file.delete();
  //     }
  //   } catch (e) {
  //     print('Error deleting save: $e');
  //   }
  // }

  // ═══════════════════════════════════════════════════════════════════
  // SHARED-PREFERENCES BACKEND
  // ═══════════════════════════════════════════════════════════════════

  Future<void> savePlayer(PlayerStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(status.toJson());
      await prefs.setString(_saveKey, jsonString);
      print('Game saved successfully (prefs).');
    } catch (e) {
      print('Error saving game: $e');
    }
  }

  // ── REAL LOADER (commented out, replaced by demo for now) ─────────
  //
  // Future<PlayerStatus?> loadPlayer() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final jsonString = prefs.getString(_saveKey);
  //     if (jsonString != null) {
  //       return playerStatusFromJson(jsonDecode(jsonString));
  //     }
  //   } catch (e) {
  //     print('Error loading game: $e');
  //   }
  //   return null;
  // }

  /// DEMO: returns a fully-stacked cultivator so we can see the HUD
  /// with everything populated, without going through creation.
  Future<PlayerStatus?> loadPlayer() async {
    return _demoPlayer();
  }

  Future<void> deleteSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_saveKey);
      print('Save deleted (prefs).');
    } catch (e) {
      print('Error deleting save: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // DEMO DATA
  // ═══════════════════════════════════════════════════════════════════

  PlayerStatus _demoPlayer() {
    return PlayerStatus(
      name: 'Li Wei',
      age: 24,
      temperament: BodyTemperament.chaosBody,
      race: PlayerRace.immortal,

      // Five-element affinity + awakened derivations
      baseAffinities: [
        Element.water,
        Element.wood,
        Element.metal,
      ],
      derivedAffinities: [
        DerivedElement.ice,
        DerivedElement.lightning,
        DerivedElement.wind,
      ],

      // Mid-game cultivator
      realm: CultivationRealm.qiCondensation,
      subStage: SubStage.mid,
      cultivationExp: 2400,
      cultivationExpNeeded: 5000,

      // Full resource pools
      qi: ResourcePool(current: 4200, max: 5000, regenPerSecond: 40),
      soul: ResourcePool(current: 800, max: 1000, regenPerSecond: 5),
      body: ResourcePool(current: 1400, max: 2000, regenPerSecond: 8),
      health: ResourcePool(current: 3200, max: 4000, regenPerSecond: 6),

      // Attributes
      attackPower: 480,
      defense: 390,
      speed: 260,
      spiritualSense: 410,
      luck: 12,

      // Flight / mobility
      isFlying: false,
      canFlyPermanently: true,
      flightTimeRemaining: 0,

      // Teleport (not yet — Void Refinement+)
      canTeleportAtWill: false,
      teleportCooldown: 0,
      teleportAnchors: const [],

      // Soul / survival
      nascentSoulActive: false,
      isSoulForm: false,
      rebirthsRemaining: 0,

      // Race passives (demo: give the Immortal one spark charge)
      tribulationImmunityRemaining: 1,
      immortalSparkCharges: 1,

      // Inventory
      inventory: const [
        Item(
          id: 'healing_pill',
          name: 'Healing Pill 回春丹',
          description: 'Restores 500 HP.',
          quantity: 8,
        ),
        Item(
          id: 'qi_pill',
          name: 'Qi Gathering Pill 聚气丹',
          description: 'Restores 800 Qi.',
          quantity: 5,
        ),
        Item(
          id: 'spirit_stone_low',
          name: 'Low-Grade Spirit Stone',
          description: 'Basic cultivation currency.',
          quantity: 132,
        ),
        Item(
          id: 'ice_crystal',
          name: 'Ice Crystal 冰晶',
          description: 'Material for ice techniques.',
          quantity: 3,
        ),
      ],

      // Weapon
      lifeBoundWeapon: const Weapon(
        id: 'frost_edge',
        name: 'Frost Edge 霜刃',
        attackBonus: 120,
        element: Element.water,
        isLifeBound: true,
      ),

      // Techniques
      knownTechniques: const [
        Technique(
          id: 'azure_water_blade',
          name: 'Azure Water Blade 碧水斩',
          description: 'A crescent of compressed water.',
          baseElement: Element.water,
          qiCost: 40,
          cooldown: 1.2,
        ),
        Technique(
          id: 'glacial_prison',
          name: 'Glacial Prison 寒冰牢',
          description: 'Traps the target in ice.',
          derivedElement: DerivedElement.ice,
          qiCost: 90,
          cooldown: 4.0,
        ),
        Technique(
          id: 'thunder_step',
          name: 'Thunder Step 雷步',
          description: 'Instant short-range dash.',
          derivedElement: DerivedElement.lightning,
          qiCost: 60,
          cooldown: 3.0,
        ),
        Technique(
          id: 'wind_walk',
          name: 'Wind Walk 御风',
          description: 'Grants brief evasion.',
          derivedElement: DerivedElement.wind,
          qiCost: 30,
          cooldown: 2.5,
        ),
      ],

      // Domain / Law — leave null for now (unlocked at higher realms)
      domain: null,
      masteredLaw: null,
    );
  }
}