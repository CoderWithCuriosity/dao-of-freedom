/// The Five Elements (五行, Wǔxíng) — the foundation of all xianxia.
enum Element {
  wood,   // 木 — growth, healing, life
  fire,   // 火 — destruction, refinement
  earth,  // 土 — stability, defense
  metal,  // 金 — sharpness, weapons
  water,  // 水 — flow, adaptability
}

/// Derived/mutated elements — variants of the base five.
enum DerivedElement {
  ice,        // 冰 — derived from water
  lightning,  // 雷 — derived from metal
  wind,       // 风 — derived from wood
  light,      // 光 — standalone, yang
  darkness,   // 暗 — standalone, yin
}

/// Higher laws — not elements, unlocked at high realms.
enum HigherLaw {
  space,  // 空间
  time,   // 时间
  chaos,  // 混沌
}

/// Maps each derived element to its parent base element.
/// null = standalone.
const Map<DerivedElement, Element?> derivedParent = {
  DerivedElement.ice: Element.water,
  DerivedElement.lightning: Element.metal,
  DerivedElement.wind: Element.wood,
  DerivedElement.light: null,
  DerivedElement.darkness: null,
};