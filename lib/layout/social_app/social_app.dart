import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/modules/NewPost/NewPostScreen.dart';
import 'package:social_media/shared/components/components.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/cubit/states.dart';
import 'package:social_media/shared/styles/icon_broken.dart';

class SocialApp extends StatelessWidget {
  const SocialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {
        if(state is SocialNewPostState){
          navigatorTo(context, NewPostScreen());
        }
      },
      builder: (BuildContext context, Object? state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(icon: const Icon(IconBroken.Notification),onPressed: (){}),
              IconButton(icon: const Icon(IconBroken.Search),onPressed: (){}),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home),
                  label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat),
                  label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Location),
                  label: 'Users',
              ),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Setting),
                  label: 'Settings',
              ),
            ],
          ),

        );
      },
    );
  }
}
