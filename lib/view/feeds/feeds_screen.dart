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
import '../user/user_screen.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.isNotEmpty &&
              SocialCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 15,
                  margin: const EdgeInsets.all(10),
                  child: Image.network(
                    'https://mqalaat.net/images/8/81/%D8%B1%D9%85%D8%B2_%D8%A8%D8%B1%D8%AC_%D8%A7%D9%84%D8%AC%D9%88%D8%B2%D8%A7%D8%A1.jpg',
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(
                      SocialCubit.get(context).posts[index], context, index),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          fallback: (context) => const Center(
              child: CircularProgressIndicator(
            color: buttonsColor,
          )),
        );
      },
    );
  }
}

Widget buildPostItem(PostModel model, context, index) {
  // bool isLiked = SocialCubit.get(context).isLiked(SocialCubit.get(context).postsId[index]);

  return Card(
    color: Theme.of(context).scaffoldBackgroundColor,
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
                    if (model.uId != SocialCubit.get(context).userModel!.uId) {
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
                    //  SocialCubit.get(context).listOfIsLiked[index] ? Icon(Icons.favorite , color: Colors.red,) :
                    const Icon(Icons.favorite_border),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${SocialCubit.get(context).likes[index]}',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 16),
                    )
                  ],
                ),
                onTap: () {
                  SocialCubit.get(context)
                      .likePost(SocialCubit.get(context).postsId[index]);
                  SocialCubit.get(context)
                      .getComments(SocialCubit.get(context).postsId[index]);
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
                          SocialCubit.get(context).postsId[index]));
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
                navigateTo(context,
                    AddCommentScreen(SocialCubit.get(context).postsId[index]));
                SocialCubit.get(context)
                    .getComments(SocialCubit.get(context).postsId[index]);
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
}
