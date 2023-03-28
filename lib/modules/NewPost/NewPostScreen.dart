import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/cubit/states.dart';
import 'package:social_media/shared/styles/icon_broken.dart';

import '../../shared/components/components.dart';
class NewPostScreen extends StatelessWidget {

  var textController = TextEditingController();
  final now = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var cubit = SocialCubit.get(context);
        var postImage = cubit.postImage;
        return Scaffold(
        appBar: defaultAppBar(
              context: context,
              title: 'Create Post',
              actions: [
                defaultTextButton(function: (){
                  if (postImage == null){
                    cubit.CreatePost(
                      dateTime: now.toString() ,
                      text: textController.text,
                    );
                  }else{
                    cubit.uploadPostImage(
                      dateTime: now.toString() ,
                      text: textController.text,
                    );
                  }
                }, text: 'Post'),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(height: 10,),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('https://img.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg?w=1060&t=st=1665415814~exp=1665416414~hmac=8df798bbdbe5a72a62654193f02a74e15ef3d48bac8c299a7dd1703d3488111c'),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sami Madane',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          Text(
                            'public',
                            style: Theme.of(context).textTheme.caption?.copyWith(height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'what is on your mind ...',
                      border: InputBorder.none,
                    ),
                    controller: textController,
                  ),
                ),
                if (postImage != null)
                  SizedBox(height: 20,),
                if (postImage != null)
                  Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Align(
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          image: DecorationImage(
                            image:FileImage(postImage),
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
                            cubit.removePostImage();
                          },
                          icon: Icon(Icons.close,size: 18,),
                          padding: EdgeInsets.zero,
                        )
                    ),
                  ],
                ),
                if (postImage != null)
                  SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: (){
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5,),
                            Text('Add Photo')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: (){},
                        child: Text('# tags'),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
