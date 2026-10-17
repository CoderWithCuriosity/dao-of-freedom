import 'package:flutter/material.dart' hide Element;
import 'package:provider/provider.dart';

import '../app/routes.dart';
import '../factories/player_status_factory.dart';
import '../models/body_temperament.dart';
import '../models/element.dart';
import '../app/game_state.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameController = TextEditingController(text: 'Li Wei');

  BodyTemperament _temperament = BodyTemperament.mortal;
  final Set<Element> _baseAffinities = {Element.water, Element.wood};
  final Set<DerivedElement> _derivedAffinities = {};

  static const int maxBaseAffinities = 2;
  static const int maxDerivedAffinities = 1;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _baseAffinities.isNotEmpty;

  void _startGame() {
    if (!_isValid) return;

    final status = PlayerStatusFactory.newCultivator(
      _nameController.text.trim(),
      baseAffinities: _baseAffinities.toList(),
      derivedAffinities: _derivedAffinities.toList(),
      temperament: _temperament,
    );

    // Store it globally, then navigate.
    context.read<GameState>().createPlayer(status);

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.game
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // In landscape, split into two columns so it doesn't scroll much.
            final isWide = constraints.maxWidth > 700;
            final content = _buildForm(context);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildLeftColumn()),
                        const SizedBox(width: 32),
                        Expanded(child: _buildRightColumn()),
                      ],
                    )
                  : content,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isValid ? _startGame : null,
        backgroundColor: _isValid ? const Color(0xFF7FDBFF) : Colors.white12,
        foregroundColor: _isValid ? Colors.black : Colors.white24,
        label: const Text('Begin Cultivation'),
      ),
    );
  }

  Widget _buildForm(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeftColumn(),
          const SizedBox(height: 24),
          _buildRightColumn(),
        ],
      );

  Widget _buildLeftColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Name'),
          TextField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF7FDBFF)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Body Temperament'),
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
      );

  Widget _buildRightColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Base Affinities (${_baseAffinities.length}/$maxBaseAffinities)',
          ),
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
          const SizedBox(height: 24),
          _sectionTitle(
            'Derived Affinities (${_derivedAffinities.length}/$maxDerivedAffinities)',
          ),
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
      );

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
            letterSpacing: 2,
          ),
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