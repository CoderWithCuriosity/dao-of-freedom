  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:provider/provider.dart';

  import 'app/game_state.dart';
  import 'app/routes.dart';
  import 'screens/character_creation_screen.dart';
  import 'screens/game_screen.dart';
  import 'screens/main_menu_screen.dart';
  import 'screens/splash_screen.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Create the GameState instance
    final gameState = GameState();
    // Tell it to load any existing save
    await gameState.loadFromDisk();

    runApp(
      ChangeNotifierProvider(create: (_) => gameState, child: const DaoApp()),
    );
  }

  class DaoApp extends StatelessWidget {
    const DaoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Dao of Freedom',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.mainMenu: (_) => const MainMenuScreen(),
          AppRoutes.characterCreation: (_) => const CharacterCreationScreen(),
          AppRoutes.game: (_) => const GameScreen(),
        },
      );
    }
  }
