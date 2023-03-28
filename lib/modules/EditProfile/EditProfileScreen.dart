import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/cubit/states.dart';
import 'package:social_media/shared/styles/icon_broken.dart';

import '../../shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var userModel = SocialCubit.get(context).userModel;

        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit profile',
            actions: [
              defaultTextButton(
                function: (){
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                  );
                  SocialCubit.get(context).removeButtonUploadImages();
                },
                text: 'Update',
                isBold: true,
              ),
              SizedBox(width: 15,),
            ],
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUpdateUserLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUpdateUserLoadingState)
                    SizedBox(height: 10,),

                  Container(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              child: Container(
                                height: 160,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null ? NetworkImage(
                                      '${userModel.cover}',
                                    ) : FileImage(coverImage) as ImageProvider ,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              alignment: AlignmentDirectional.topCenter,
                            ),
                            CircleAvatar(
                              radius: 20,
                                child: IconButton(
                                    onPressed: (){
                                      SocialCubit.get(context).getCoverImage();
                                    },
                                    icon: Icon(IconBroken.Camera,size: 18,),)
                            ),
                          ],
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 56,
                                backgroundImage: profileImage == null ?(NetworkImage(
                                    '${userModel.image}'
                                )) :(FileImage(profileImage)) as ImageProvider ,
                              ),
                            ),
                            CircleAvatar(
                                radius: 20,
                                child: IconButton(
                                  onPressed: (){
                                    SocialCubit.get(context).getProfileImage();
                                  },
                                  icon: Icon(IconBroken.Camera,size: 18,),)
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                  SizedBox(height: 20,),
                  if (profileImage != null || coverImage != null)
                     Row(
                    children: [
                      if(profileImage != null)
                        Expanded(
                            child: Column(
                              children: [
                                defaultButton(function: (){
                                  SocialCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                  );
                                }, text: 'Upload Profile',height: 40),
                                if (state is SocialUploadProfileImageLoadingState)
                                  SizedBox(height: 8,),
                                if (state is SocialUploadProfileImageLoadingState)
                                  LinearProgressIndicator(),
                              ],

                            )),
                      SizedBox(width: 5,),
                      if(coverImage != null)
                        Expanded(
                            child: Column(
                              children: [
                                defaultButton(function: (){
                                  SocialCubit.get(context).uploadCoverImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                  );
                                }, text: 'Upload Cover',height: 40),
                                if (state is SocialUploadCoverImageLoadingState)
                                  SizedBox(height: 5,),
                                if (state is SocialUploadCoverImageLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                        ),
                    ],
                  ),
                  if ((profileImage != null || coverImage != null) && (state is !SocialUpdateUserLoadingState))
                    SizedBox(height: 20,),
                  defaultFormFiled(
                      newcontroller: nameController,
                      text: 'Name',
                      keyboardType:TextInputType.name,
                      prefixIcon: Icon(IconBroken.User1),
                      textValidator: 'name must not be empty',
                  ),

                  SizedBox(height: 10,),
                  defaultFormFiled(
                    newcontroller: bioController,
                    text: 'Bio',
                    keyboardType:TextInputType.text,
                    prefixIcon: Icon(IconBroken.Info_Circle),
                    textValidator: 'bio must not be empty',
                  ),
                  SizedBox(height: 10,),
                  defaultFormFiled(
                    newcontroller: phoneController,
                    text: 'Phone',
                    keyboardType:TextInputType.phone,
                    prefixIcon: Icon(IconBroken.Call),
                    textValidator: 'phone must not be empty',
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
