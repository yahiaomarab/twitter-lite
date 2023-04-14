import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:twitter_lite/shared/colors.dart';
import 'package:twitter_lite/styles/Iconly-Broken_icons.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Widget defaultTxtForm(
        {required TextEditingController controller,
        required TextInputType type,
        Function(String)? onSubmit,
        VoidCallback? onTap,
        Function(String)? onChanged,
        required String? Function(String?)? validate,
        required String label,
        IconData? prefix,
        IconData? suffix,
        bool isPassword = false,
        bool isClickable = true,
        VoidCallback? onSuffixPressed,
        Color prefixColor = buttonsColor}) =>
    TextFormField(
      validator: validate,
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            prefix,
            color: prefixColor,
          ),
          suffixIcon: GestureDetector(
            onTap: onSuffixPressed,
            child: Icon(suffix),
          ),
          border: const OutlineInputBorder()),
      keyboardType: type,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      onTap: onTap,
    );

Widget defaultButton({
  double width = double.infinity,
  double height = 50,
  Color background = buttonsColor,
  required VoidCallback function,
  required String text,
  bool isUpperCase = true,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: background,
      ),
      child: MaterialButton(
        height: height,
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  Color color = buttonsColor,
}) =>
    TextButton(
        onPressed: function,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: color, fontSize: 16),
        ));

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { success, error, warning }

Color? chooseToastColor(ToastStates state) {
  Color? color;
  switch (state) {
    case ToastStates.success:
      color = buttonsColor;
      break;
    case ToastStates.error:
      color = Colors.pink;
      break;
    case ToastStates.warning:
      color = Colors.yellow;
      break;
  }
  return color;
}

Widget myDivider() => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    );

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  dynamic title,
  List<Widget>? actions,
  Color color = textColor,
  Color titleColor = Colors.white,
}) =>
    AppBar(
      backgroundColor: color,
      leading: IconButton(
        color: titleColor,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Iconly_Broken.Arrow___Left_2),
      ),
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      titleSpacing: 0,
      actions: actions,
    );
PreferredSizeWidget buildAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      title: Text(title!),
      actions: actions,
    );
