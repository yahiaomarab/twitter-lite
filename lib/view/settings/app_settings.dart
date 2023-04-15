import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';

import '../../app_cubit/app_cubit.dart';
import '../../app_cubit/app_states.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(50),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(100)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Mode'),
                      const Spacer(),
                      Switch(value: SocialCubit.get(context).isDark, onChanged: (value) {
                        SocialCubit.get(context).changeMode();
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: (){
                      SocialCubit.get(context).signOut(context);
                    },
                    child: Row(
                      children: [
                        const Text('Logout'),
                        const Spacer(),
                        IconButton(icon: const Icon(Iconly_Broken.Logout), onPressed: (){
                         SocialCubit.get(context).signOut(context);
                        },),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
