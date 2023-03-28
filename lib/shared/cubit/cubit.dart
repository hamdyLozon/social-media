import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/models/MessageModel/message_model.dart';
import 'package:social_media/models/PostModel/post_model.dart';
import 'package:social_media/models/SocialMediaModel/social_user_model.dart';
import 'package:social_media/modules/feeds/feeds_screen.dart';
import 'package:social_media/modules/settings/settings_screen.dart';
import 'package:social_media/modules/useres/users_screen.dart';
import 'package:social_media/shared/cubit/states.dart';

import '../../modules/NewPost/NewPostScreen.dart';
import '../../modules/chats/chats_screen.dart';
import '../components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;



class SocialCubit extends Cubit<SocialStates> {

  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      print('map is : ${value.data()} ');
      userModel = SocialUserModel.fromJson((value.data())!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
      print('error is : ${error.toString()} ');
    });
  }


  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1){
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  // لتغير الصورة بشكل مبدئي بالتطبيق
  File ?profileImage;

  var picker = ImagePicker();

  Future getProfileImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    }
    else {
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // لتغير الصورة بشكل مبدئي بالتطبيق
  File ?coverImage;

  Future getCoverImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }
    else {
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  // لرفع الصورة على فايربيز
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      // ____________________________________________________
      value.ref.getDownloadURL()
          .then((value) {
        // emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
      // ____________________________________________________
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

// /data/user/0/com.example.social_media/cache/image_picker2317320657565358624.jpg
// image_picker2317320657565358624.jpg   <= (the last path)

  // لرفع الصورة على فايربيز
  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      // ____________________________________________________
      value.ref.getDownloadURL()
          .then((value) {
        // emit(SocialUploadCoverImageSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
      // ____________________________________________________
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  //
  // }){
  //   emit(SocialUpdateUserLoadingState());
  //   if (coverImage != null){
  //     uploadCoverImage();
  //   }else if (profileImage != null){
  //     uploadProfileImage();
  //   }else if(coverImage != null && profileImage != null){
  //
  //   }else{
  //     updateUser(name: name, phone: phone, bio: bio);
  //   }
  // }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }) {
    emit(SocialUpdateUserLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name,
      email: userModel!.email,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      // اذا كانت ال image = null خود القيمة الاساسية يلي بالمودل
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(model.toMap()).then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }

  void removeButtonUploadImages() {
    profileImage = null;
    coverImage = null;
    emit(SocialRemoveButtonUploadImagesState());
  }

  /////////////////////////////////////////////////////////////////////////////

  File ?postImage;

  Future getPostImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }
    else {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    String? dateTime,
    String? text,
    String? postImageUrl,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      // ____________________________________________________
      value.ref.getDownloadURL()
          .then((value) {
        print(value);
        CreatePost(
          dateTime: dateTime,
          text: text,
          postImageUrl: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
      // ____________________________________________________
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void CreatePost({
    String? dateTime,
    String? text,
    String? postImageUrl,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      // هان باخدهم جاهزين من المودل يلي قبل
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      // باخدهم من الادخال عادي
      dateTime: dateTime,
      text: text,
      postImage: postImageUrl ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
    // ال add بتعمل id لحالها في الفاير بيز
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // جوا البوست جوا اللايك جيبلي عدد ال docs
        element.reference.collection('likes').get()
            .then((value) {
          likes.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          postsId.add(element.id);
        }).catchError((error) {

        });
      });

      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState());
      print('error is : ${error.toString()} ');
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId)
        .collection('likes').doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState());
    });
  }

    // chats
    List<SocialUserModel> allUsers = [];
    void getAllUsers() {
      emit(SocialGetAllUsersLoadingState());
      if(allUsers.length == 0)
          FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.id != userModel!.uId)
            allUsers.add(SocialUserModel.fromJson(element.data()));
        });

        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
        print('error is : ${error.toString()} ');
      });
    }

    void sendMessage({
  required String receiverId,
  required String dateTime,
  required String text,
}){
      MessageModel model = MessageModel(
        senderId: userModel!.uId,
        receiverId: receiverId,
        dateTime: dateTime,
        text: text,
      );
      
      FirebaseFirestore.instance
      .collection('users')
      .doc(userModel!.uId)
      .collection('chats')
      .doc(receiverId)
      .collection('messages')
          .add(model.toMap()).then((value){
        emit(SocialSendMessageSuccessState());
      }).catchError((error){
        emit(SocialSendMessageErrorState());
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(userModel!.uId)
          .collection('messages')
          .add(model.toMap()).then((value){
        emit(SocialSendMessageSuccessState());
      }).catchError((error){
        emit(SocialSendMessageErrorState());
      });
  }

  List<MessageModel> messages = [];
  void getMessage({
    required String receiverId,
  }) {
    emit(SocialGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users').doc(userModel!.uId)
    .collection('chats').doc(receiverId)
    .collection('messages')
    // رتبلي المسجات على حسب الوقت
        .orderBy('dateTime')
    // ال snapshots هاي بتكون طابور من ال futures
    // ال futuers بتجبلي الداتا وبتوقف اما ال streme لا بتجيب وبتضل شغال
        .snapshots()
        .listen((event) {
          // هان بفضي ال list عشان ال listen بتجيب القديم والجديد
          messages = [];
          event.docs.forEach((element) {
            messages.add(MessageModel.fromJson(element.data()));
          });
          emit(SocialGetMessageSuccessState());
    });
  }
  void clearContentsTextFormField(){

  }

}
