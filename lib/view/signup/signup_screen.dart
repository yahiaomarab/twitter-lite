import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/shared/colors.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/shared/components/constants.dart';
import 'package:twitter_lite/shared/network/local/cache_helper.dart';

import '../../view_model/register_cubit/register_cubit.dart';
import '../../view_model/register_cubit/register_states.dart';
import '../layout/social_layout.dart';

class SignupScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialSignupCubit(),
      child: BlocConsumer<SocialSignupCubit, SocialSignupStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            SocialCubit.get(context).getUserData();
            CacheHelper.setString('uId', uId).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
            showToast(text:'تم تسجيل الدخول بنجاح', state: ToastStates.success);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signup',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: textColor),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Register to be with our family !',
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTxtForm(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "What's your name !";
                              } else {
                                return null;
                              }
                            },
                            label: 'Name',
                            prefix: Icons.person),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTxtForm(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "We need your phone !";
                              } else {
                                return null;
                              }
                            },
                            label: 'Phone',
                            prefix: Icons.phone_iphone_outlined),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTxtForm(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return "Your email can't be empty !";
                              } else {
                                return null;
                              }
                            },
                            label: 'Email',
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTxtForm(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "Password is too short !";
                              } else {
                                return null;
                              }
                            },
                            onSubmit: (value) {},
                            label: 'Password',
                            isPassword:
                                SocialSignupCubit.get(context).isPassword,
                            prefix: Icons.lock_open_outlined,
                            suffix: SocialSignupCubit.get(context).suffix,
                            onSuffixPressed: () {
                              SocialSignupCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialSignupLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialSignupCubit.get(context).userSignup(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'Signup'),
                          fallback: (context) => const Center(
                              child: CircularProgressIndicator(
                            color: buttonsColor,
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
