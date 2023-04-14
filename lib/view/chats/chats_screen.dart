import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';

import '../../data/models/social_user_model.dart';
import '../user/user_screen.dart';
import 'chat_details_screen.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('cahts'),
          ),
          body: ConditionalBuilder(
            condition: SocialCubit.get(context).users.length > 0,
            builder: (context) => ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildChatItem(
                    SocialCubit.get(context).users[index], context),
                separatorBuilder: (context, index) => myDivider(),
                itemCount: SocialCubit.get(context).users.length),
            fallback: (Context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Iconly_Broken.Close_Square,
                  size: 100,
                  color: Colors.grey,
                ),
                const Text(
                  'No Chats !',
                  style: TextStyle(fontSize: 50, color: Colors.grey),
                )
              ],
            )),
          ),
        );
      },
    );
  }
}

Widget buildChatItem(UserModel model, context) => InkWell(
      onTap: () {
        navigateTo(
            context,
            ChatDetailsScreen(
              userModel: model,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Text(
                  '${model.name}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );

Widget buildSearchItem(UserModel model, context) => InkWell(
      onTap: () {
        navigateTo(context, UserScreen(model.uId));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Text(
                  '${model.name}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
