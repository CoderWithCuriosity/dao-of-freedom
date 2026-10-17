import 'package:flutter/foundation.dart';
import '../services/save_service.dart';
import '../models/player_status.dart';
import '../game/worlds/world_registry.dart';

/// Holds the current player's status for the whole app.
///
/// Any widget can read it via `context.watch<GameState>()` and will
/// rebuild when `notifyListeners()` fires.
class GameState extends ChangeNotifier {
  final SaveService _saveService = SaveService();
  PlayerStatus? _playerStatus;
  PlayerStatus? get playerStatus => _playerStatus;
  bool get hasPlayer => _playerStatus != null;

  String _currentWorldId = WorldRegistry.verdantPlains.id;
  String get currentWorldId => _currentWorldId;

  void setWorld(String id) {
    _currentWorldId = id;
    notifyListeners();
  }

  // Call this on app start to load any existing save
  Future<void> loadFromDisk() async {
    _playerStatus = await _saveService.loadPlayer();
    notifyListeners();
  }

  // Call this from character creation
  Future<void> createPlayer(PlayerStatus status) async {
    _playerStatus = status;
    await _saveService.savePlayer(status); // Save to disk
    notifyListeners();
  }

  /// Wipe the current game (used by "Return to main menu").
  // Call this to wipe the game
  Future<void> clear() async {
    _playerStatus = null;
    await _saveService.deleteSave(); // Delete the file
    notifyListeners();
  }
}
