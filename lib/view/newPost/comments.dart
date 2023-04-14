import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';

import '../../app_cubit/app_cubit.dart';
import '../../shared/components/components.dart';

class AddCommentScreen extends StatelessWidget {
  String postId;
  AddCommentScreen(this.postId);
  var textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(
            context: context,
            title: 'comment',
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCommentLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialCommentLoadingState)
                  const SizedBox(
                    height: 10,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'),
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Yahia omar',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: TextFormField(
                    controller: textcontroller,
                    decoration: const InputDecoration(
                      hintText: 'write a comment....',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.image),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'add photo',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Iconly_Broken.Send),
                        onPressed: () {
                          SocialCubit.get(context).commentOnPost(
                            dateTime: DateTime.now().toString(),
                            text: textcontroller.text,
                            postId: postId,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
