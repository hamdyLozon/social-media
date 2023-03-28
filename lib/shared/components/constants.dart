
import '../../modules/login/login.dart';
import '../network/local/cach_helper.dart';
import 'components.dart';

void singOut(context){
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value){
      navigateAndFinish(context, LoginScreen());
    }
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=> print(match.group(0)));
}

var uId;