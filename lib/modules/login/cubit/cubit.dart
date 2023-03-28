import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/modules/login/cubit/states.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);


  void userLogin({
    required String email,
    required String password,
  }){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword
      (
        email: email,
        password: password,
    ).then((value){
      print('success sami good');
      print(value.user!.email);
      print(value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      print('error sami not good');
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });

  }
// لاخفاء واظهار كلمة السر
  IconData suffix = Icons.visibility;
  bool obscureText = true;
  void changePasswordVisibility(){
    obscureText = !obscureText;
    suffix = obscureText ? Icons.visibility : Icons.visibility_off;
    emit(LoginChangPasswordVisibilityState());
  }


}