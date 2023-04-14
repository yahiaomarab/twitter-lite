import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/colors.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          backgroundColor: textColor,
          appBar:
              defaultAppBar(context: context, title: 'Edit Profile', actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: defaultTextButton(
                  function: () {
                    SocialCubit.get(context).updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  },
                  text: 'Submit',
                  color: Colors.white),
            )
          ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is SocialUserUpdateLoadingState)
                  const LinearProgressIndicator(
                    color: lightColor,
                  ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage: NetworkImage('${userModel.image}'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 500,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40.0, horizontal: 30),
                        child: Column(
                          children: [
                            defaultTxtForm(
                              controller: nameController,
                              type: TextInputType.name,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "Whats your name !";
                                }
                                return null;
                              },
                              label: 'Name',
                              prefix: Iconly_Broken.User,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultTxtForm(
                              controller: bioController,
                              type: TextInputType.text,
                              validate: (value) {},
                              label: 'Bio',
                              prefix: Iconly_Broken.Info_Square,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            defaultTxtForm(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validate: (value) {},
                              label: 'Phone',
                              prefix: Iconly_Broken.Call,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
