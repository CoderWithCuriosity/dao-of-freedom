import 'package:flutter/material.dart';
import 'world_definition.dart';

class WorldRegistry {
  WorldRegistry._();

  static const verdantPlains = WorldDefinition(
    id: 'verdant_plains',
    name: 'Verdant Plains',
    size: 4000,
    tileAsset: 'land/tiles/verdant_plains_grass.jpg',
    edgeColor: Color(0xFF1B4D1F),
    voidColor: Color(0xFF0B1F0D),
  );

  static const emberWastes = WorldDefinition(
    id: 'ember_wastes',
    name: 'Ember Wastes',
    size: 3000,
    tileAsset: 'land/tiles/ember_wastes_stones.png',
    edgeColor: Color(0xFFD9531E),
    voidColor: Color(0xFF1A0A05),
  );

  static const frozenExpanse = WorldDefinition(
    id: 'frozen_expanse',
    name: 'Frozen Expanse',
    size: 5000,
    tileAsset: 'land/tiles/frozen_expanse_ice.png',
    edgeColor: Color(0xFF7FB3D5),
    voidColor: Color(0xFF0A1622),
  );

  static const jadeSwamp = WorldDefinition(
    id: 'jade_swamp',
    name: 'Jade Swamp',
    size: 3500,
    tileAsset: 'land/tiles/jade_swamp_ripples.png',
    edgeColor: Color(0xFF5FD0B0),
    voidColor: Color(0xFF07130F),
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