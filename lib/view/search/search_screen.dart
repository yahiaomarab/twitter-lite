import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/components/components.dart';

import '../chats/chats_screen.dart';

class SearchScreen extends StatelessWidget {

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit , SocialStates>(
      listener: (context , state){},
      builder: (context , state){
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultTxtForm(
                  onChanged: (value){
                    SocialCubit.get(context).getSearch(value);

                  },
                  validate: (String? value) {
                    if(value!.isEmpty){
                      return 'What are you want to search for ?';
                    }
                    return null ;
                  },
                  controller: searchController,
                  type: TextInputType.text,
                  label: 'search',
                  prefix: Icons.search,
                ),
              ),
              Expanded(
                  child: ConditionalBuilder(
                    condition: SocialCubit.get(context).users.isNotEmpty,
                    builder: (context) => SocialCubit.get(context).search.isNotEmpty ? ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context , index) => buildSearchItem(SocialCubit.get(context).search[index] , context),
                    separatorBuilder: (context , index) => myDivider(),
                    itemCount: SocialCubit.get(context).search.length
                ) :  ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context , index) => buildSearchItem(SocialCubit.get(context).users[index] , context),
                        separatorBuilder: (context , index) => myDivider(),
                        itemCount: SocialCubit.get(context).users.length
                    ),
                fallback: (context) =>  Center(
                  child: Container(),
                ) ,

              ) )
            ],
          ),
        ) ;
      },
    );
  }
}

