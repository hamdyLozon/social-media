import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/MessageModel/message_model.dart';
import 'package:social_media/models/SocialMediaModel/social_user_model.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/cubit/states.dart';
import 'package:social_media/shared/styles/colors.dart';
import 'package:social_media/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  var messageController = TextEditingController();
  var scrollController = ScrollController();
  // var formKey = GlobalKey<FormState>();

  SocialUserModel model;
  ChatDetailsScreen({
     required this.model,
});
  @override
  Widget build(BuildContext context) {
    return Builder (
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessage(
            receiverId: (model.uId)!,
        );
        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (BuildContext context, state) {  },
          builder: (BuildContext context, Object? state) {
            return Scaffold(
              appBar:AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage('${model.image}'),
                    ),
                    SizedBox(width: 15,),
                    Text(
                      '${model.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                  condition: SocialCubit.get(context).messages.length > 0,
                  builder: (context) =>  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column (
                      children: [
                        Expanded(
                          child: ListView.separated(
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                              itemBuilder: (context,index)
                              {

                              var message  = SocialCubit.get(context).messages[index];
                              if(message.senderId == SocialCubit.get(context).userModel!.uId)
                                return buildMyMessage(message);
                              else
                                return buildMessage(message);
                              },
                              separatorBuilder:  (context,index) => SizedBox(height: 15,),
                              itemCount: SocialCubit.get(context).messages.length,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.4),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: TextFormField(
                                          controller: messageController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'type your message here ...'
                                          ),

                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: (){
                                        // scroll تلقائي
                                        scrollController.animateTo(scrollController.position.maxScrollExtent,
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeOut);

                                        SocialCubit.get(context).sendMessage(
                                          receiverId: (model.uId)!,
                                          dateTime: DateTime.now().toString(),
                                          text: messageController.text.toString(),
                                        );
                                      },
                                      child: Icon(IconBroken.Send,color: Colors.white,size: 18,),
                                      color: defaultColor,
                                      height: 50,
                                      // عشان يتناسب الحجم مع الايقونة
                                      minWidth: 1,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  fallback: (context) => Center(child: CircularProgressIndicator()),
              )
            );
          },
        );
      },
    );
  }
  Widget buildMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(10),
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      child: Text('${model.text}'),
    ),
  );
  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: defaultColor.withOpacity(0.2),
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      child: Text('${model.text}'),
    ),
  );
}
