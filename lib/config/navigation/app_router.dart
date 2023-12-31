import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/config/navigation/bloc_provider_config.dart';
import 'package:vootday_admin/config/navigation/route_config.dart';
import 'package:vootday_admin/config/navigation/scaffold_with_navbar.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:vootday_admin/screens/about/abouts.dart';
import 'package:vootday_admin/screens/calendar/calendars.dart';
import 'package:vootday_admin/screens/comment/bloc/comments_bloc.dart';
import 'package:vootday_admin/screens/comment/comments.dart';
import 'package:vootday_admin/screens/create_event/create_event_screen.dart';
import 'package:vootday_admin/screens/event/events.dart';
import 'package:vootday_admin/screens/event/feed_event.dart';
import 'package:vootday_admin/screens/login/cubit/login_cubit.dart';
import 'package:vootday_admin/screens/login/logins.dart';
import 'package:vootday_admin/screens/post/posts.dart';
import 'package:vootday_admin/screens/screens.dart';
import 'package:vootday_admin/screens/users/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
// final GlobalKey<NavigatorState> _sectionANavigatorKey =
//    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

GoRouter createRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();
  final goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/home',
    routes: <RouteBase>[
      //Login
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<LoginCubit>(
          create: (context) =>
              LoginCubit(authRepository: context.read<AuthRepository>()),
          child: const LoginScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'termsandconditions',
            builder: (BuildContext context, GoRouterState state) =>
                const TermsAndConditions(),
          ),
          GoRoute(
            path: 'privacypolicy',
            builder: (BuildContext context, GoRouterState state) =>
                const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: 'help',
            builder: (BuildContext context, GoRouterState state) =>
                const LoginHelpScreen(),
          ),
          GoRoute(
            path: 'mail',
            builder: (BuildContext context, GoRouterState state) =>
                BlocProvider<LoginCubit>(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: LoginMailScreen(),
            ),
          ),
        ],
      ),
      // FeedEvent
      GoRoute(
        path: '/feedevent/:eventId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final eventId = RouteConfig.getEventId(state);
          final title = RouteConfig.getTitle(state);
          final logoUrl = RouteConfig.getLogoUrl(state);
          return MaterialPage<void>(
            key: state.pageKey,
            child: BlocProviderConfig.getFeedEventBlocProvider(
              context,
              FeedEvent(eventId: eventId, title: title, logoUrl: logoUrl),
            ),
          );
        },
      ),
      // Post
      GoRoute(
        path: '/post/:postId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final postId = RouteConfig.getPostId(state);
          final fromPath = state.extra as String? ?? 'defaultFromPath';
          return MaterialPage<void>(
            key: state.pageKey,
            child: PostScreen(postId: postId, fromPath: fromPath),
          );
        },
        routes: [
          GoRoute(
            path: 'comment',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final postId = RouteConfig.getPostIdUri(state);
              return MaterialPage<void>(
                key: state.pageKey,
                child: BlocProvider<CommentsBloc>(
                  create: (_) => CommentsBloc(
                    postRepository: context.read<PostRepository>(),
                    authBloc: context.read<AuthBloc>(),
                  )..add(CommentsFetchComments(postId: postId)),
                  child: CommentScreen(postId: postId),
                ),
              );
            },
          ),
        ],
      ),
      // StatefulShellBranch
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          String title;
          Widget? actionButton;
          // Switch on the state's location
          switch (state.matchedLocation) {
            case '/home':
              title = "Home";
              actionButton = null;
              break;
            case '/swipe':
              title = "Swipe";
              actionButton = null;
              break;
            case '/search':
              title = "Search";
              actionButton = null;
              break;
            case '/profile':
              title = "Ctbast";
              actionButton = null;
              break;
            case '/profile/settings':
              title = "Settings";
              actionButton = null;
              break;
            case '/profile/parameters':
              title = "Parameters";
              actionButton = null;
              break;
            default:
              title = "Default Screen";
              actionButton = null;
          }
          return ScaffoldWithNavBar(
            currentLocation: state.uri.toString(),
            navigationShell: navigationShell,
            appTitle: title,
            appBar: state.uri.toString().startsWith('/home') ||
                    state.uri.toString().startsWith('/events') ||
                    state.uri.toString().startsWith('/calendar') ||
                    state.uri.toString().startsWith('/users') ||
                    state.uri.toString().startsWith('/profile') ||
                    state.uri.toString().startsWith('/swipe') ||
                    state.uri.toString().startsWith('/settings')
                ? null
                : AppBar(
                    // If the current location is '/** */', display a leading IconButton
                    leading: state.uri.toString() == '/***'
                        ? IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          )
                        : null,
                    // If the current location is '/swipe', don't display a title
                    title: state.uri.toString() == '/swipe' ||
                            state.uri.toString() == '/profile'
                        ? null
                        : Text(
                            title,
                            style: const TextStyle(color: Colors.black),
                          ),
                    backgroundColor: Colors.white,
                    // If an actionButton is defined, display it. Otherwise, don't display anything
                    actions: actionButton != null ? [actionButton] : null,
                    // Setting the color of the icons in the AppBar
                    iconTheme: const IconThemeData(color: Colors.black),
                    elevation: 0,
                  ),
          );
        },
        branches: <StatefulShellBranch>[
          // Home
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: const HomeScreen(),
                  );
                },
              ),
            ],
          ),
          // Calendar Event
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/calendar',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: BlocProviderConfig.getCalendarMultiBlocProvider(
                        context, const CalendarScreen()),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'createevent',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: BlocProviderConfig.getCreateEventBlocProvider(
                            context, CreateEventScreen()),
                      );
                    },
                  ),
                  GoRoute(
                      path: 'event/:eventId',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        final eventId = RouteConfig.getEventId(state);
                        String currentPath = RouteConfig.getCurrentPath(state);
                        return MaterialPage<void>(
                          key: state.pageKey,
                          child: BlocProviderConfig.getEventMultiBlocProvider(
                              context,
                              EventScreen(
                                fromPath: currentPath,
                                eventId: eventId,
                              )),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'feedevent',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            final eventId = RouteConfig.getEventId(state);
                            final title = RouteConfig.getTitle(state);
                            final logoUrl = RouteConfig.getLogoUrl(state);
                            return MaterialPage<void>(
                              key: state.pageKey,
                              child:
                                  BlocProviderConfig.getFeedEventBlocProvider(
                                context,
                                FeedEvent(
                                    eventId: eventId,
                                    title: title,
                                    logoUrl: logoUrl),
                              ),
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),
          // Users
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/users',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: BlocProviderConfig.getProfileMultiBlocProvider(
                          context, UsersScreen()),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'user/:userId',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        final userId = RouteConfig.getUserId(state);
                        return MaterialPage<void>(
                          key: state.pageKey,
                          child: BlocProviderConfig.getProfileMultiBlocProvider(
                              context,
                              ProfileScreen(
                                userId: userId,
                              )),
                        );
                      },
                    ),
                  ]),
            ],
          ),
          // Profile
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
            ],
          ),
          // Settings
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  authBloc.stream.listen((state) {
    if (state.status == AuthStatus.unauthenticated) {
      goRouter.go('/login');
    } else if (state.status == AuthStatus.authenticated) {
      goRouter.go('/home');
    }
  });

  return goRouter;
}
