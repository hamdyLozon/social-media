import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/layout/social_app/social_app.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/cach_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (BuildContext context, state) {
          if (state is RegisterCreateUserSuccessState){
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value){
              navigateAndFinish(context, SocialApp());
            }).catchError((error){

            });
            navigateAndFinish(context, SocialApp());
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
                        Text('REGISTER',style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:Colors.black),
                        ),
                        Text('Register now to communicate with friends',style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.grey),),
                        const SizedBox(height: 20,),
                        defaultFormFiled(
                          newcontroller: nameController,
                          text: 'User Name',
                          textValidator: 'please enter your user name',
                          prefixIcon: const Icon(Icons.person),
                          keyboardType:TextInputType.name,
                        ),
                        const SizedBox(height: 12,),
                        defaultFormFiled(
                          newcontroller: emailController,
                          text: 'Email Address',
                          textValidator: 'please enter your email address',
                          prefixIcon: const Icon(Icons.email),
                          keyboardType:TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12,),
                        defaultFormFiled (
                            newcontroller: passwordController,
                            text: 'Password',
                            textValidator: 'password is too short',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: (){
                                RegisterCubit.get(context).changePasswordVisibility();
                              },
                              icon:Icon(RegisterCubit.get(context).suffix),
                            ),
                            keyboardType:TextInputType.visiblePassword,
                            obscureText: RegisterCubit.get(context).obscureText,
                            // عشان بعد ما احط الباسورد واحط صح كاني ضغطت login
                            onSubmit: (value){
                              if (formKey.currentState!.validate()){
                                RegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            }
                        ),
                        const SizedBox(height: 12,),
                        defaultFormFiled(
                          newcontroller: phoneController,
                          text: 'Phone Number',
                          textValidator: 'please enter your phone number',
                          prefixIcon: const Icon(Icons.phone),
                          keyboardType:TextInputType.phone,
                        ),
                        const SizedBox(height: 20,),

                        ConditionalBuilder(
                          condition: state is !RegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: (){
                                if (formKey.currentState!.validate()){
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              text: 'Register',
                              isUpperCase: true
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
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
