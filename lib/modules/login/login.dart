
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/shared/network/local/cach_helper.dart';

import '../../layout/social_app/social_app.dart';
import '../../shared/components/components.dart';
import '../register/register.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';



class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (BuildContext context, state) {
          if (state is LoginErrorState){
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is LoginSuccessState){
            CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
            ).then((value){
              navigateAndFinish(context, SocialApp());
            }).catchError((error){

            });
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN',style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:Colors.black),
                        ),
                        Text('Login now to communicate with friends',style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.grey),),
                        const SizedBox(height: 30,),
                        defaultFormFiled(
                          newcontroller: emailController,
                          text: 'Email Address',
                          textValidator: 'please enter your email address',
                          prefixIcon: const Icon(Icons.email),
                          keyboardType:TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15,),
                        defaultFormFiled (
                            newcontroller: passwordController,
                            text: 'Password',
                            textValidator: 'password is too short',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: (){
                                LoginCubit.get(context).changePasswordVisibility();
                              },
                              icon:Icon(LoginCubit.get(context).suffix),
                            ),
                            keyboardType:TextInputType.visiblePassword,
                            obscureText: LoginCubit.get(context).obscureText,
                            // عشان بعد ما احط الباسورد واحط صح كاني ضغطت login
                            onSubmit: (value){
                              if (formKey.currentState!.validate()){
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            }

                        ),
                        const SizedBox(height: 30,),

                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if (formKey.currentState!.validate()){
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'login',
                              isUpperCase: true
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?',style: TextStyle(fontWeight: FontWeight.bold),),
                            defaultTextButton(function: (){
                              navigatorTo(context, RegisterScreen());
                            }, text: 'Register',isBold: true),
                          ],
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
