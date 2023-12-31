import 'package:vootday_admin/screens/calendar/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/blocs/blocs.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:vootday_admin/screens/create_event/cubit/create_event_cubit.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';
import 'package:vootday_admin/screens/users/bloc/blocs.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/profile_stats/profile_stats_bloc.dart';

class BlocProviderConfig {
  static MultiBlocProvider getCalendarMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final thisEndedEventsBloc = CalendarEndedBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return thisEndedEventsBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final thisComignSoonEventsBloc = CalendarComingSoonBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return thisComignSoonEventsBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final thisStatsEventsBloc = CalendarStatsBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return thisStatsEventsBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static BlocProvider getFeedEventBlocProvider(
      BuildContext context, Widget child) {
    return BlocProvider<FeedEventBloc>(
      create: (context) {
        final feedEventBloc = FeedEventBloc(
          eventRepository: context.read<EventRepository>(),
          feedRepository: context.read<FeedRepository>(),
          authBloc: context.read<AuthBloc>(),
        );
        return feedEventBloc;
      },
      child: child,
    );
  }

  static MultiBlocProvider getEventMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventStatsBloc>(
          create: (context) {
            final statsEventBloc = EventStatsBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return statsEventBloc;
          },
        ),
        BlocProvider<EventBloc>(
          create: (context) {
            final eventBloc = EventBloc(
              eventRepository: context.read<EventRepository>(),
            );
            return eventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getProfileMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
          ),
        ),
        BlocProvider<UsersStatsBloc>(
          create: (context) => UsersStatsBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
          ),
        ),
        BlocProvider<ProfileStatsBloc>(
          create: (context) => ProfileStatsBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
          ),
        ),
        /*
        BlocProvider<YourCollectionBloc>(
          create: (context) => YourCollectionBloc(
            postRepository: context.read<PostRepository>(),
          ),
        ),
        */
      ],
      child: child,
    );
  }

  static BlocProvider getCreateEventBlocProvider(
      BuildContext context, Widget child) {
    return BlocProvider<CreateEventCubit>(
      create: (context) {
        final createEventCubit = CreateEventCubit(
          eventRepository: context.read<EventRepository>(),
          storageRepository: context.read<StorageRepository>(),
        );
        return createEventCubit;
      },
      child: child,
    );
  }

/*
  static MultiBlocProvider getHomeMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedOOTDBloc>(
          create: (context) {
            final feedOOTDBloc = FeedOOTDBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            feedOOTDBloc.add(FeedOOTDFetchPostsOOTD());
            return feedOOTDBloc;
          },
        ),
        BlocProvider<FeedMonthBloc>(
          create: (context) {
            final feedMonthBloc = FeedMonthBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            feedMonthBloc.add(FeedMonthFetchPostsMonth());
            return feedMonthBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final homeEventBloc = HomeEventBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return homeEventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getSwipeMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SwipeBloc>(
          create: (context) {
            final swipeBloc = SwipeBloc(
              swipeRepository: context.read<SwipeRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return swipeBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFollowingExplorerMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FollowingBloc>(
          create: (context) {
            final followingBloc = FollowingBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return followingBloc;
          },
        ),
        BlocProvider<ExplorerBloc>(
          create: (context) {
            final explorerBloc = ExplorerBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return explorerBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getMyProfileMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
          ),
        ),
        BlocProvider<MyCollectionBloc>(
          create: (context) => MyCollectionBloc(
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
          ),
        ),
        BlocProvider<RecentPostImageUrlCubit>(
          create: (context) => RecentPostImageUrlCubit(),
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFeedCollectionBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCollectionBloc>(
          create: (context) {
            final feedCollectionBloc = FeedCollectionBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return feedCollectionBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static BlocProvider getCreatePostBlocProvider(
      BuildContext context, Widget child) {
    return BlocProvider<CreatePostCubit>(
      create: (context) {
        final createPostBloc = CreatePostCubit(
          postRepository: context.read<PostRepository>(),
          eventRepository: context.read<EventRepository>(),
          storageRepository: context.read<StorageRepository>(),
          authBloc: context.read<AuthBloc>(),
        );
        return createPostBloc;
      },
      child: child,
    );
  }
}
*/
}
