import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/layout/social_app/social_app.dart';
import 'package:social_media/shared/components/components.dart';
import 'package:social_media/shared/components/constants.dart';
import 'package:social_media/shared/cubit/cubit.dart';
import 'package:social_media/shared/network/local/cach_helper.dart';
import 'package:social_media/shared/network/remote/dio_helper/dio_helper.dart';
import 'package:social_media/shared/styles/themes.dart';

import 'firebase_options.dart';
import 'modules/login/login.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('On Background Message');
  print(message.data.toString());
  showToast(text: 'On Background Message', state: ToastStates.SUCCESS);
}

initialMessage  () async{
  var message = await FirebaseMessaging.instance.getInitialMessage() ;
  if (message != null){
    print('On Terminate Message');
    print(message.data.toString());
    showToast(text: 'On Terminate Message', state: ToastStates.SUCCESS);
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // للاشعارات
  var token = await FirebaseMessaging.instance.getToken();
  print('=======================================================');
  print('${token}');
  print('=======================================================');

  // لو كان الابليكشن مفتوح بستقبل مباشرة هيك
  FirebaseMessaging.onMessage.listen((event) {
    print('On Message');
    print(event.data.toString());
    showToast(text: 'On Message', state: ToastStates.SUCCESS);
  });

  // لو كان الابليكشن بالخلفية بستقبل هيك
  // لما اضغط على الاشعار شو يعمل او وين يفتح مثلا
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('On Message Opend App');
    print(event.data.toString());
    showToast(text: 'On Message Opend App', state: ToastStates.SUCCESS);
  });

  // Terminateعند الضغط على الاشعار والتطبيق مغلق
  initialMessage();


  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
  uId = CacheHelper.getData(key: 'uId');
  print('uid is : $uId');
  if (uId != null)
    widget = SocialApp();
  else
    widget = LoginScreen();

  runApp(
      MyApp(startWidget: widget)
  );

}

class MyApp extends StatelessWidget {

  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SocialCubit()..getUserData()..getPosts()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme:darkTheme ,
        home: startWidget,
      ),
    );
  }
}

