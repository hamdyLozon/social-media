
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/shared/styles/icon_broken.dart';


void navigatorTo (context,Widget) => Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) => Widget
  ),
);
void navigateAndFinish (context,Widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
      builder: (context) => Widget
  ),
      (Route<dynamic> route) => false,
);
Widget myDivider () => Padding(
  padding: const EdgeInsetsDirectional.only(start: 10),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey,
  ),
);
Widget defaultButton(
    {
      var color = Colors.blue,
      double width = double.infinity,
      double? height ,
      bool isUpperCase = true,
      required VoidCallback function ,
      required String text ,

    }) =>  Container(
  color: color,
  width: width,
  height: height,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      '${isUpperCase?text.toUpperCase():text}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color:Colors.white,
      ),
    ),

  ),
);

Widget defaultFormFiled({
  double radius = 0 ,
  Icon? prefixIcon,
  IconButton? suffixIcon,
  TextInputType? keyboardType,
  VoidCallback? onTap,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  bool obscureText = false,
  required TextEditingController newcontroller,
  required String text,
  String textValidator = '',


}) => TextFormField(
  validator: (value) {
    if (value!.isEmpty){
      return '${textValidator}';
    }
    return null;
  },

  obscureText:obscureText,
  controller: newcontroller,
  decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    labelText: text,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  ),
  keyboardType: keyboardType,
  onTap:onTap,
  onChanged: onChange,
  onFieldSubmitted: onSubmit ,

);

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  bool isBold = false,
  Color color = Colors.blue,
}) => TextButton(onPressed: function, child: Text(text.toUpperCase(),
  style: isBold? TextStyle(fontWeight: FontWeight.bold,color: color):TextStyle(fontWeight: FontWeight.normal),
)
);

AppBar defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) => AppBar(
  leading: IconButton(
      onPressed: (){
    Navigator.pop(context);
  },
      icon: Icon(IconBroken.Arrow___Left_2)
  ),
  titleSpacing: 2.0,
  title: Text('${title}'),
  actions: actions,
);

// ************************************************
void showToast({
  required String text,
  required ToastStates state,
})=>Fluttertoast.showToast(
  msg: text,
  // وقت للاندرويد
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  // وقت لل ios و web
  timeInSecForIosWeb: 5,
  backgroundColor: choseToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);
// لما اكون بدي اختار شي من اكتر من شي
enum ToastStates {SUCCESS,ERROR,WARNING}

Color choseToastColor(ToastStates state){
  Color color;
  switch (state){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}
// ************************************************


