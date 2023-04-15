import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_cubit.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/bloc_observer.dart';
import 'package:twitter_lite/shared/components/constants.dart';
import 'package:twitter_lite/shared/network/local/cache_helper.dart';
import 'package:twitter_lite/styles/themes.dart';
import 'package:twitter_lite/view/layout/social_layout.dart';
import 'package:twitter_lite/view/login/login_screen.dart';

//Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print(message.data.toString());
//   showToast(text: 'on background Message', state: ToastStates.success);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

//  var token = await FirebaseMessaging.instance.getToken();
//   print(token);
//   FirebaseMessaging.onMessage.listen((event) {
//     print(event.data.toString());
//     showToast(text: 'on Message', state: ToastStates.success);
//   });
//   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//     print(event.data.toString());
//     showToast(text: 'on Message opened App', state: ToastStates.success);
//   });
//
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  bool isDark = await CacheHelper.getBool('isDark');
  uId = await CacheHelper.getString('uId');
  Widget widget;
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    widget,
    isDark,
  ));
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  final bool isDark;
  const MyApp(this.startWidget, this.isDark);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getPosts()
            ..changeMode(fromShare: isDark),
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: SocialCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
