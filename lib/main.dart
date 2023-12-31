import 'package:firebase_core/firebase_core.dart';
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
import 'package:vootday_admin/repositories/brand/brand_repository.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:vootday_admin/screens/comment/bloc/comments_bloc.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  setUrlStrategy(PathUrlStrategy());
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false));
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
        /*
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(),
        ),
        RepositoryProvider<SwipeRepository>(
          create: (context) => SwipeRepository(),
        ),
        */
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
          /*
          BlocProvider<DeletePostsCubit>(
            create: (context) =>
                DeletePostsCubit(context.read<PostRepository>()),
          ),
          BlocProvider<DeleteCollectionsCubit>(
            create: (context) =>
                DeleteCollectionsCubit(context.read<PostRepository>()),
          ),
          BlocProvider<CreateCollectionCubit>(
            create: (context) => CreateCollectionCubit(
              firebaseFirestore: FirebaseFirestore.instance,
            ),
          ),
          BlocProvider(
            create: (context) {
              final myCollectionBloc = MyCollectionBloc(
                authBloc: context.read<AuthBloc>(),
                postRepository: context.read<PostRepository>(),
              );
              return myCollectionBloc;
            },
          ),
          BlocProvider<UpdatePublicStatusCubit>(
            create: (context) => UpdatePublicStatusCubit(
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider<AddPostToCollectionCubit>(
            create: (context) => AddPostToCollectionCubit(
              firebaseFirestore: FirebaseFirestore.instance,
            ),
          ),
          BlocProvider<AddPostToLikesCubit>(
            create: (context) => AddPostToLikesCubit(
              firebaseFirestore: FirebaseFirestore.instance,
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider<FeedMyLikesBloc>(
            create: (context) {
              final feedMyLikesBloc = FeedMyLikesBloc(
                feedRepository: context.read<FeedRepository>(),
                authBloc: context.read<AuthBloc>(),
                postRepository: context.read<PostRepository>(),
              );
              feedMyLikesBloc.add(FeedMyLikesFetchPosts());
              return feedMyLikesBloc;
            },
          ),
          BlocProvider<RecentPostImageUrlCubit>(
            create: (context) => RecentPostImageUrlCubit(),
          ),
          BlocProvider<FollowersUsersCubit>(
            create: (context) => FollowersUsersCubit(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<FollowingUsersCubit>(
            create: (context) => FollowingUsersCubit(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider( 
            create: (context) {
              final myEventBloc = MyEventBloc(
                eventRepository: context.read<EventRepository>(),
                authBloc: context.read<AuthBloc>(),
              );
              return myEventBloc;
            },
          ),
          */
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
