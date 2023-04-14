import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/shared/components/constants.dart';

import 'login_states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>{
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email ,
    required String password
}){
    emit(SocialLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
        password: password
    ).then((value) {
      uId = value.user!.uid;
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined ;
  bool isPassword = true ;

  void changePasswordVisibility(){
    isPassword = !isPassword ;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;
    emit(SocialChangePasswordVisibilityState());
  }
}