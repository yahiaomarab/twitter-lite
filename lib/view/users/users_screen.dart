import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/shared/components/components.dart';

import '../../app_cubit/app_cubit.dart';
import '../../app_cubit/app_states.dart';
import '../../data/models/social_user_model.dart';
import '../user/user_screen.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.isNotEmpty,
          builder: (context) => Scaffold(

            body: ListView.separated(
              itemBuilder: (context, index) =>
                  builtusers(context, SocialCubit.get(context).users[index]),
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
              itemCount: SocialCubit.get(context).users.length,
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget builtusers(context, UserModel model) {
    return InkWell(
      onTap: () {
        navigateTo(
            context,
            UserScreen(
              model.uId,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.name}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${model.bio}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
