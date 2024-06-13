import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/firebase_options.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:vootday_admin/screens/comment/bloc/comments_bloc.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';

void main() async {
  // Bloc.observer = SimpleBlocObserver();
  setUrlStrategy(PathUrlStrategy());
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: false));
    }
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(),
        ),
        RepositoryProvider<FeedRepository>(
          create: (context) => FeedRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider<BrandRepository>(
          create: (context) => BrandRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) {
              final eventBloc = EventBloc(
                eventRepository: context.read<EventRepository>(),
              );
              return eventBloc;
            },
          ),
          BlocProvider<CommentsBloc>(
            create: (context) => CommentsBloc(
              authBloc: context.read<AuthBloc>(),
              postRepository: context.read<PostRepository>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) => MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('fr', ''),
            ],
            locale: const Locale('fr', ''),
            title: 'VOOTDAY Admin',
            theme: theme(),
            debugShowCheckedModeBanner: false,
            routerConfig: createRouter(context),
          ),
        ),
      ),
    );
  }
}

Future<void> configLoading() async {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.none
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..displayDuration = const Duration(milliseconds: 1000)
    ..userInteractions = false;
}
