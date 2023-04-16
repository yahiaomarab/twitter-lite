import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/data/models/post_model.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/view/feeds/feeds_screen.dart';

import '../../app_cubit/app_cubit.dart';

class SomeOnePostImage extends StatelessWidget {
  PostModel? model;
  SomeOnePostImage({required this.model});
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      SocialCubit.get(context).getSomeonePosts(model!.uId!);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) => GestureDetector(
          onTap: () {
            navigateTo(context, const FeedsScreen());
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 70,
                  left: 15,
                  right: 15,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: 'postImage',
                      child: Image(
                        image: NetworkImage(model!.postImage!),
                        width: double.infinity,
                        height: 400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
