import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/colors.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';
import '../../data/models/post_model.dart';
import '../newPost/comments.dart';

class UserScreen extends StatelessWidget {
  dynamic userId;
  UserScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getAnotherUser(userId);
    SocialCubit.get(context).getSomeonePosts(userId);
    SocialCubit.get(context).getNumOfFollowers(userId);
    SocialCubit.get(context).isMyProfile(userId);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialFollowSomeoneSuccessState) {
          SocialCubit.get(context).myId = true;
          SocialCubit.get(context).followers =
              SocialCubit.get(context).followers + 1;
        }
      },
      builder: (context, state) {
        var model = SocialCubit.get(context).anotherUserModel;
        return ConditionalBuilder(
          condition: state is! SocialGetSomeonePostsLoadingState,
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(model!.name!),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 170,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: NetworkImage(model.cover!),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                backgroundImage: NetworkImage(model.image!),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    model.name!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 24),
                  ),
                  Text(
                    model.bio!,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  'Homies',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontSize: 18),
                                ),
                                Text(
                                  "${SocialCubit.get(context).followers}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                                height: 45, child: buildButton(context))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildSomeonePostItem(
                          SocialCubit.get(context).someonePosts[index],
                          context,
                          index),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: SocialCubit.get(context).someonePosts.length),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ),
          fallback: (context) => const Scaffold(
              body: Center(
            child: CircularProgressIndicator(
              color: buttonsColor,
            ),
          )),
        );
      },
    );
  }

  Widget buildButton(context) => SocialCubit.get(context).myId
      ? OutlinedButton(
          onPressed: () {},
          child: const Text(
            'You can\'t lose your Homies !',
            style: TextStyle(color: Colors.red),
          ),
        )
      : defaultButton(
          function: () {
            SocialCubit.get(context).followSomeone(userId);
            buildButton(context);
          },
          text: 'Homie');
}

Widget buildSomeonePostItem(PostModel model, context, index) => Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 15,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (model.uId != SocialCubit.get(context).userModel!.uId) {
                      navigateTo(context, UserScreen(model.uId));
                    } else {
                      SocialCubit.get(context).changeBottomNav(3);
                    }
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('${model.image}'),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (model.uId !=
                          SocialCubit.get(context).userModel!.uId) {
                        navigateTo(context, UserScreen(model.uId));
                      } else {
                        SocialCubit.get(context).changeBottomNav(3);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${model.name}'),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          '${model.date}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: myDivider(),
            ),
            Text(
              '${model.postText}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: const [
                    // Padding(
                    //   padding: const EdgeInsetsDirectional.only(end : 8 ),
                    //   child: Container(
                    //     height: 25,
                    //     child: MaterialButton(onPressed: (){},
                    //       padding: EdgeInsets.zero,
                    //       minWidth: 1,
                    //       height: 25,
                    //       child: Text(
                    //         '#Flutter',style: TextStyle(color: Colors.blue),),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            if (model.postImage != '')
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Image.network(
                  '${model.postImage}',
                  fit: BoxFit.cover,
                  height: 140,
                  width: double.infinity,
                ),
              ),
            Row(
              children: [
                InkWell(
                  child: Row(
                    children: [
                      const Icon(Iconly_Broken.Heart),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${SocialCubit.get(context).someoneLikes[index]}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () {
                    SocialCubit.get(context).likePost(
                        SocialCubit.get(context).someonePostsId[index]);
                    SocialCubit.get(context).getComments(
                        SocialCubit.get(context).someonePostsId[index]);
                  },
                ),
                const Spacer(),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(Iconly_Broken.Chat),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Comments',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 16),
                      )
                    ],
                  ),
                  onTap: () {
                    navigateTo(
                        context,
                        AddCommentScreen(
                            SocialCubit.get(context).someonePostsId[index]));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            myDivider(),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: InkWell(
                onTap: () {
                  navigateTo(
                      context,
                      AddCommentScreen(
                          SocialCubit.get(context).someonePostsId[index]));
                  SocialCubit.get(context).getComments(
                      SocialCubit.get(context).someonePostsId[index]);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Write a Comment...',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
