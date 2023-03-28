import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/SocialMediaModel/social_user_model.dart';
import 'package:social_media/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }){
    emit(RegisterLoadingState());
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        print(value.user!.email);
        print(value.user!.uid);
        userCreate(name: name, email: email, phone: phone, uId: value.user!.uid);
      }).catchError((error){
        print(error.toString());
        emit(RegisterErrorState(error));
      });
  }
  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
}){
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write your bio ...',
      image: 'https://as1.ftcdn.net/v2/jpg/02/43/12/34/1000_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
      cover: 'https://img.freepik.com/free-photo/back-view-male-professional-works-puts-his-ideas-stick-notes-going-write-main-info-creating-business-plan_273609-34113.jpg?w=1060&t=st=1665997703~exp=1665998303~hmac=304178964f26ab0d2a21593253dc2a74dae58cdcb9269eefa0c2a52be7f6f5b2',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
    // اذا موجود ال user بعبي فيه واذا لا بنشأ واحد جديد
        .collection('users')
    // بعد مدخلت ع الuser بدخل عليا انا
        .doc(uId)
    // الان بدي ماب ف بروح بعمل مودل خاص فيا
        .set(model.toMap())
        .then((value){
          print ('true in create');
          emit(RegisterCreateUserSuccessState(uId));
    }).catchError((error){
      print ('false in create');
      emit(RegisterCreateUserErrorState(error.toString()));
    });
}
// لاخفاء واظهار كلمة السر
  IconData suffix = Icons.visibility;
  bool obscureText = true;
  void changePasswordVisibility(){
    obscureText = !obscureText;
    suffix = obscureText ? Icons.visibility : Icons.visibility_off;
    emit(RegisterChangPasswordVisibilityState());
  }


}