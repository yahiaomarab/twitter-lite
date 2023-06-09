import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';
import 'package:twitter_lite/view/search/search_screen.dart';

import '../newPost/new_post_screen.dart';
import '../chats/chats_screen.dart';
import '../notifications/notifications_screen.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                navigateTo(context, NewPostScreen());
              },
              child: const Icon(Iconly_Broken.Paper_Plus),
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    SocialCubit.get(context).currentIndex == 1
                        ? navigateTo(context, SearchScreen())
                        : navigateTo(context, NotificationScreen());
                  },
                  icon: SocialCubit.get(context).currentIndex == 1
                      ? const Icon(Iconly_Broken.Search)
                      : const Icon(Iconly_Broken.Heart),
                ),
                IconButton(
                    onPressed: () {
                      SocialCubit.get(context).getUsers();
                      navigateTo(context, ChatsScreen());
                    },
                    icon: const Icon(Iconly_Broken.Send)),
              ],
              centerTitle: true,
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Iconly_Broken.Home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Iconly_Broken.Location), label: 'Location'),
                BottomNavigationBarItem(
                    icon: Icon(Iconly_Broken.Profile), label: 'Profile'),
                BottomNavigationBarItem(
                    icon: Icon(Iconly_Broken.More_Circle), label: 'More'),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        });
  }
}
