import 'package:flutter/material.dart';
import 'world_definition.dart';

class WorldRegistry {
  WorldRegistry._();

  static const verdantPlains = WorldDefinition(
    id: 'verdant_plains',
    name: 'Verdant Plains',
    size: 4000,
    groundColor: Color(0xFF3E8E41),
    patchColor: Color(0xFF2F7A35),
    edgeColor: Color(0xFF1B4D1F),
    voidColor: Color(0xFF0B1F0D),
    seed: 1,
  );

  static const emberWastes = WorldDefinition(
    id: 'ember_wastes',
    name: 'Ember Wastes',
    size: 3000,
    groundColor: Color(0xFF8B4A2B),
    patchColor: Color(0xFF6E3720),
    edgeColor: Color(0xFFD9531E),
    voidColor: Color(0xFF1A0A05),
    seed: 2,
  );

  static const frozenExpanse = WorldDefinition(
    id: 'frozen_expanse',
    name: 'Frozen Expanse',
    size: 5000,
    groundColor: Color(0xFFDCEBF5),
    patchColor: Color(0xFFBFD8EA),
    edgeColor: Color(0xFF7FB3D5),
    voidColor: Color(0xFF0A1622),
    seed: 3,
  );

  static const jadeSwamp = WorldDefinition(
    id: 'jade_swamp',
    name: 'Jade Swamp',
    size: 3500,
    groundColor: Color(0xFF2E5E55),
    patchColor: Color(0xFF244B44),
    edgeColor: Color(0xFF5FD0B0),
    voidColor: Color(0xFF07130F),
    seed: 4,
  );

  static const all = <WorldDefinition>[
    verdantPlains,
    emberWastes,
    frozenExpanse,
    jadeSwamp,
  ];

  static WorldDefinition byId(String? id) =>
      all.firstWhere((w) => w.id == id, orElse: () => verdantPlains);
}