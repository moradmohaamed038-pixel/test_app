import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/firebase_init_service.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/mode_selection_screen.dart';
import 'screens/devices_list_screen.dart';
import 'screens/device_discovery_screen.dart';
import 'screens/device_control_screen.dart';
import 'screens/device_settings_screen.dart';
import 'screens/timer_setup_screen.dart';
import 'screens/schedule_setup_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/device_provider.dart';
import 'providers/local_connection_provider.dart';
import 'providers/demo_mode_provider.dart';
import 'providers/cloud_sync_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/analytics_provider.dart';
import 'models/relay_model.dart';
import 'models/esp_device_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🔥 Initializing Firebase...');
    await FirebaseInitService.initialize();
    print('✅ Firebase initialized');
    runApp(const MoradTkApp());
  } catch (e) {
    print('❌ Error: $e');
    runApp(const ErrorApp());
  }
}

class MoradTkApp extends StatelessWidget {
  const MoradTkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseInitService>(create: (_) => FirebaseInitService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => LocalConnectionProvider()),
        ChangeNotifierProvider(create: (_) => DemoModeProvider()),
        ChangeNotifierProvider(create: (_) => CloudSyncProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: MaterialApp(
        title: 'MORAD_TK',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        home: const SplashScreen(),
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/mode_selection': (context) => const ModeSelectionScreen(),
          '/devices_list': (context) => const DevicesListScreen(),
          '/device_discovery': (context) => const DeviceDiscoveryScreen(),
          '/device_control': (context) => const DeviceControlScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/device_settings':
              final device = settings.arguments as EspDevice?;
              return MaterialPageRoute(
                builder: (_) => DeviceSettingsScreen(device: device ?? EspDevice()),
              );
            case '/timer_setup':
              final relay = settings.arguments as Relay?;
              return MaterialPageRoute(
                builder: (_) => TimerSetupScreen(relay: relay ?? Relay()),
              );
            case '/schedule_setup':
              final relay = settings.arguments as Relay?;
              return MaterialPageRoute(
                builder: (_) => ScheduleSetupScreen(relay: relay ?? Relay()),
              );
            default:
              return MaterialPageRoute(builder: (_) => const SplashScreen());
          }
        },
      ),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text('خطأ في تهيئة التطبيق'),
              const SizedBox(height: 10),
              const Text('تحقق من الاتصال بالإنترنت'),
              const Text('تحقق من firebase_options.dart'),
            ],
          ),
        ),
      ),
    );
  }
}