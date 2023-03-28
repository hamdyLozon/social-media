import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/models/SocialMediaModel/social_user_model.dart';
import 'package:social_media/modules/ChatDetails/chat_details_screen.dart';
import 'package:social_media/shared/components/components.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).allUsers.length > 0,
          builder: (BuildContext context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index) => buildChatItems(SocialCubit.get(context).allUsers[index],context),
            separatorBuilder:(context,index) => myDivider(),
            itemCount: SocialCubit.get(context).allUsers.length,
          ),
          fallback: (BuildContext context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  Widget buildChatItems(SocialUserModel model,context) => InkWell(
    onTap: (){
      navigatorTo(context, ChatDetailsScreen(model: model));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('${model.image}'),
          ),
          SizedBox(width: 20,),
          Text(
            '${model.name}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
