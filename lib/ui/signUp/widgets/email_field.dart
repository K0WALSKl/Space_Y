import 'package:space_y/blocs/signUp_bloc.dart';
import 'package:flutter/material.dart';

Widget emailField(SignUpBloc signUpBloc, String fieldLabel, double labelSize) =>
    StreamBuilder<String>(
      stream: signUpBloc.email,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return createEmailRequiredTextField(
            context, snapshot, fieldLabel, labelSize, signUpBloc);
      },
    );

Widget createEmailFieldLabel(BuildContext context, String fieldLabel, double labelSize) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      child: Text(
        fieldLabel,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'Rubik',
          fontSize: labelSize,
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget createEmailRequiredTextField(BuildContext context,
    AsyncSnapshot<String> snapshot, String fieldLabel, double labelSize, SignUpBloc signUpBloc) {
  return SizedBox(
    height: 90,
    width: double.infinity,
    child: Column(
      children: <Widget>[
        createEmailFieldLabel(context, fieldLabel, labelSize),
        SizedBox(
          height: 33,
          width: double.infinity,
          child: TextField(
              key: const Key('EmailTextField'),
              cursorWidth: 0.5,
              style: const TextStyle(
                height: 1.2,
                color: Colors.black,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w300,
                fontSize: 20.0,
              ),
              keyboardType: TextInputType.text,
              onChanged: signUpBloc.changeEmail,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  //contentPadding: EdgeInsets.only(bottom: 20),
                  )),
        ),
        Divider(
              thickness: 1, color: Colors.grey[300],
            ),
        if (snapshot.hasError)
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(),
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
