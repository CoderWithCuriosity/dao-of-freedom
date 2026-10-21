import 'package:flutter/material.dart' hide Element;
import 'package:provider/provider.dart';

import '../app/game_state.dart';
import '../app/routes.dart';
import '../factories/player_status_factory.dart';
import '../models/body_temperament.dart';
import '../models/element.dart';
import '../models/gender.dart';
import '../models/race.dart';
import '../ui/creation/creation_step_scaffold.dart';
import '../ui/creation/gender_toggle.dart';
import '../ui/creation/race_card.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  // ── Wizard state ───────────────────────────────────────────────────
  int _step = 0; // 0=race, 1=identity, 2=affinities, 3=confirm

  // Selections (nothing is committed until the end)
  PlayerRace? _race;
  PlayerGender _gender = PlayerGender.male;
  BodyTemperament _temperament = BodyTemperament.mortal;
  final _nameController = TextEditingController(text: 'Li Wei');
  final Set<Element> _baseAffinities = {};
  final Set<DerivedElement> _derivedAffinities = {};

  static const int maxBaseAffinities = 2;
  static const int maxDerivedAffinities = 1;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Navigation guards ──────────────────────────────────────────────
  bool get _canGoNext => switch (_step) {
        0 => _race != null,
        1 => _nameController.text.trim().isNotEmpty,
        2 => _baseAffinities.isNotEmpty,
        _ => true,
      };

  void _next() {
    if (!_canGoNext) return;
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _startGame();
    }
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _step--);
    }
  }

  // ── Final commit ───────────────────────────────────────────────────
  void _startGame() {
    final race = _race;
    if (race == null) return;

    final status = PlayerStatusFactory.newCultivator(
      _nameController.text.trim(),
      baseAffinities: _baseAffinities.toList(),
      derivedAffinities: _derivedAffinities.toList(),
      temperament: _temperament,
      race: race,
    );

    context.read<GameState>().createPlayer(status);
    Navigator.of(context).pushReplacementNamed(AppRoutes.game);
  }

  // ── Build ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: const Text(
          'Create Your Cultivator',
          style: TextStyle(color: Colors.white70, letterSpacing: 2),
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey(_step),
            child: _buildStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() => switch (_step) {
        0 => _buildRaceStep(),
        1 => _buildIdentityStep(),
        2 => _buildAffinitiesStep(),
        _ => _buildConfirmStep(),
      };

  // ═══════════════════════════════════════════════════════════════════
  // STEP 0 — Race + gender
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildRaceStep() {
    return CreationStepScaffold(
      stepLabel: 'Step 1 of 4',
      title: 'Choose Your Lineage',
      subtitle: 'Each race reshapes your body, your dao, and your fate.',
      onBack: _back,
      onNext: _next,
      nextEnabled: _canGoNext,
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'APPEARANCE',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 16),
              GenderToggle(
                value: _gender,
                onChanged: (g) => setState(() => _gender = g),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final r in allRaces) ...[
                        RaceCard(
                          profile: r,
                          gender: _gender,
                          selected: _race == r.race,
                          onTap: () => setState(() => _race = r.race),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // STEP 1 — Name + temperament
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildIdentityStep() {
    return CreationStepScaffold(
      stepLabel: 'Step 2 of 4',
      title: 'Who Are You?',
      subtitle: 'Your name echoes through the heavens. Choose it well.',
      onBack: _back,
      onNext: _next,
      nextEnabled: _canGoNext,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('NAME'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF7FDBFF)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _sectionLabel('BODY TEMPERAMENT'),
            const SizedBox(height: 4),
            const Text(
              'Innate physique — shapes how you cultivate.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: BodyTemperament.values.map((t) {
                final selected = t == _temperament;
                return ChoiceChip(
                  label: Text(_temperamentLabel(t)),
                  selected: selected,
                  onSelected: (_) => setState(() => _temperament = t),
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF7FDBFF),
                  labelStyle: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // STEP 2 — Affinities
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildAffinitiesStep() {
    return CreationStepScaffold(
      stepLabel: 'Step 3 of 4',
      title: 'Awaken Your Elements',
      subtitle: 'The five elements resonate with your soul.',
      onBack: _back,
      onNext: _next,
      nextEnabled: _canGoNext,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel(
              'BASE AFFINITIES (${_baseAffinities.length}/$maxBaseAffinities)',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Element.values.map((e) {
                final selected = _baseAffinities.contains(e);
                return FilterChip(
                  label: Text(_elementLabel(e)),
                  selected: selected,
                  onSelected: (on) {
                    setState(() {
                      if (on) {
                        if (_baseAffinities.length < maxBaseAffinities) {
                          _baseAffinities.add(e);
                        }
                      } else {
                        _baseAffinities.remove(e);
                      }
                    });
                  },
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF7FDBFF),
                  labelStyle: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            _sectionLabel(
              'DERIVED AFFINITIES (${_derivedAffinities.length}/$maxDerivedAffinities)',
            ),
            const SizedBox(height: 4),
            const Text(
              'Rarer mutations. Choose wisely.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DerivedElement.values.map((d) {
                final selected = _derivedAffinities.contains(d);
                return FilterChip(
                  label: Text(_derivedLabel(d)),
                  selected: selected,
                  onSelected: (on) {
                    setState(() {
                      if (on) {
                        if (_derivedAffinities.length < maxDerivedAffinities) {
                          _derivedAffinities.add(d);
                        }
                      } else {
                        _derivedAffinities.remove(d);
                      }
                    });
                  },
                  backgroundColor: Colors.white10,
                  selectedColor: const Color(0xFF7FDBFF),
                  labelStyle: TextStyle(
                    color: selected ? Colors.black : Colors.white70,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // STEP 3 — Confirm
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildConfirmStep() {
    final race = _race;
    if (race == null) return const SizedBox.shrink();
    final profile = raceProfileFor(race);

    return CreationStepScaffold(
      stepLabel: 'Step 4 of 4',
      title: 'Your Path Awaits',
      subtitle: 'The heavens watch. Step forward.',
      onBack: _back,
      onNext: _next,
      nextLabel: 'Begin Cultivation',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Portrait
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              RaceCard.assetFor(race, _gender),
              width: 200,
              height: 320,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 24),
          // Details
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text.trim(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${profile.displayName}  ·  ${_gender == PlayerGender.male ? "Male" : "Female"}',
                    style: const TextStyle(
                      color: Color(0xFF7FDBFF),
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.identity,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _infoRow('Temperament', _temperamentLabel(_temperament)),
                  _infoRow(
                    'Base Affinities',
                    _baseAffinities.isEmpty
                        ? '—'
                        : _baseAffinities.map(_elementLabel).join(', '),
                  ),
                  _infoRow(
                    'Derived Affinities',
                    _derivedAffinities.isEmpty
                        ? '—'
                        : _derivedAffinities.map(_derivedLabel).join(', '),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Small helpers
  // ═══════════════════════════════════════════════════════════════════
  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          letterSpacing: 2,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ],
        ),
      );

  String _elementLabel(Element e) => switch (e) {
        Element.wood => 'Wood 木',
        Element.fire => 'Fire 火',
        Element.earth => 'Earth 土',
        Element.metal => 'Metal 金',
        Element.water => 'Water 水',
      };

  String _derivedLabel(DerivedElement d) => switch (d) {
        DerivedElement.ice => 'Ice 冰',
        DerivedElement.lightning => 'Lightning 雷',
        DerivedElement.wind => 'Wind 风',
        DerivedElement.light => 'Light 光',
        DerivedElement.darkness => 'Darkness 暗',
      };

  String _temperamentLabel(BodyTemperament t) => switch (t) {
        BodyTemperament.mortal => 'Mortal 凡体',
        BodyTemperament.spiritBody => 'Spirit 灵体',
        BodyTemperament.chaosBody => 'Chaos 混沌体',
        BodyTemperament.demonBody => 'Demon 魔体',
        BodyTemperament.swordBody => 'Sword 剑体',
        BodyTemperament.iceBody => 'Ice 冰灵体',
        BodyTemperament.lightningBody => 'Lightning 雷灵体',
      };
}