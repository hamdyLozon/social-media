import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/PostModel/post_model.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/cubit/states.dart';
import 'package:social_media/shared/styles/colors.dart';
import 'package:social_media/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length > 0 ,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  margin: EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Image(
                          image: NetworkImage('https://img.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg?w=1060&t=st=1665415814~exp=1665416414~hmac=8df798bbdbe5a72a62654193f02a74e15ef3d48bac8c299a7dd1703d3488111c'),
                          height:200 ,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Communicate with friend',
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                          ),

                        ),
                      ]
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics:NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index) => buildPostItem(SocialCubit.get(context).posts[index],context,index),
                  separatorBuilder:(context,index) => SizedBox(height: 8,),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                SizedBox(height: 8,),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  Widget buildPostItem(PostModel model , context,index)=>Card(
    elevation: 5,
    margin: EdgeInsets.all(8.0),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // الاسم والتاريخ والتوثيق
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: defaultColor,
                        ),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style: Theme.of(context).textTheme.caption?.copyWith(height: 1.3),

                    ),
                  ],
                ),
              ),
              SizedBox(width: 20,),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  size: 20,

                ),
                onPressed: (){

                },
              ),
            ],
          ),
          // خط رمادي فاصل
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              color: Colors.grey[300],
              height:1 ,
              width: double.infinity,
            ),
          ),
          // المنشور النص
          Padding(
            padding: const EdgeInsets.only(top: 5.0,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${model.text}',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black),

                ),
              ],
            ),
          ),
          // TAGS
          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 5,
          //     top: 5,
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end: 6),
          //           child: Container(
          //             height: 25,
          //             child: MaterialButton(
          //               onPressed: (){},
          //               minWidth: 1,
          //               padding: EdgeInsets.zero,
          //               child:Text(
          //                 '#Software',
          //                 style: Theme.of(context).textTheme.caption?.copyWith(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(end: 6),
          //           child: Container(
          //             height: 25,
          //             child: MaterialButton(
          //               onPressed: (){},
          //               minWidth: 1,
          //               padding: EdgeInsets.zero,
          //               child:Text(
          //                 '#flutter',
          //                 style: Theme.of(context).textTheme.caption?.copyWith(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //
          //       ],
          //     ),
          //   ),
          // ),
          // POST IMAGE
          if (model.postImage != '')
              Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(
                    '${model.postImage}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // LIKE & COMMENT
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(IconBroken.Heart,size:18 ,color: Colors.red,),
                          SizedBox(width: 5,),
                          Text('${SocialCubit.get(context).likes[index]}',style: Theme.of(context).textTheme.caption,),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(IconBroken.Chat,size:18 ,color: Colors.amber,),
                          SizedBox(width: 5,),
                          Text('0 comments',style: Theme.of(context).textTheme.caption,),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
          // خط رمادي فاصل
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
              color: Colors.grey[300],
              height:1 ,
              width: double.infinity,
            ),
          ),
          // WRITE A COMMENT
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row (
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('${SocialCubit.get(context).userModel!.image}'),
                      ),
                      SizedBox(width: 15,),
                      Text(
                        'Write a comment... ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: (){

                  },
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(IconBroken.Heart,size:20 ,color: Colors.red,),
                    SizedBox(width: 5,),
                    Text('like',style: Theme.of(context).textTheme.caption,),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                },
              ),

            ],
          ),
        ],
      ),
    ),
  );
}
