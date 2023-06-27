import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_lab/blocs/register_bloc.dart';
import 'package:firebase_lab/resources/dimens.dart';
import 'package:firebase_lab/resources/strings.dart';
import 'package:firebase_lab/utils/extensions.dart';
import 'package:firebase_lab/widgets/label_and_textfield_view.dart';
import 'package:firebase_lab/widgets/loading_view.dart';
import 'package:firebase_lab/widgets/or_view.dart';
import 'package:firebase_lab/widgets/primary_button_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        body: Selector<RegisterBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) => Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: LOGIN_SCREEN_TOP_PADDING,
                  bottom: MARGIN_LARGE,
                  left: MARGIN_XLARGE,
                  right: MARGIN_XLARGE,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        LBL_REGISTER,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TEXT_BIG,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Profile Picture"),
                              Stack(
                                children: [
                                  Container(
                                    child: (bloc.userProfile == null)
                                        ? GestureDetector(
                                      child: const CircleAvatar(
                                        backgroundColor:
                                        Colors.transparent,
                                        backgroundImage: NetworkImage(
                                          "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640",
                                        ),
                                        radius: 50,
                                      ),
                                      onTap: () async {
                                        final ImagePicker picker =
                                        ImagePicker();
                                        // Pick an image
                                        final XFile? image =
                                        await picker.pickImage(
                                            source:
                                            ImageSource.gallery);
                                        if (image != null) {
                                          bloc.onImageChosen(
                                              File(image.path));
                                        }
                                      },
                                    )
                                        : CircleAvatar(
                                      child: Image.file(
                                        bloc.userProfile ?? File(""),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Visibility(
                                      visible: bloc.userProfile != null,
                                      child: GestureDetector(
                                        onTap: () {
                                          bloc.onTapDeleteImage();
                                        },
                                        child: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) =>
                            LabelAndTextFieldView(
                              label: LBL_EMAIL,
                              hint: HINT_EMAIL,
                              onChanged: (email) => bloc.onEmailChanged(email),
                            ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) =>
                            LabelAndTextFieldView(
                              label: LBL_USER_NAME,
                              hint: HINT_USER_NAME,
                              onChanged: (userName) =>
                                  bloc.onUserNameChanged(userName),
                            ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) =>
                            LabelAndTextFieldView(
                              label: LBL_PASSWORD,
                              hint: HINT_PASSWORD,
                              onChanged: (password) =>
                                  bloc.onPasswordChanged(password),
                              isSecure: true,
                            ),
                      ),
                      const SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer<RegisterBloc>(
                        builder: (context, bloc, child) => TextButton(
                          onPressed: () {
                            bloc
                                .onTapRegister()
                                .then((value) => Navigator.pop(context))
                                .catchError((error) => showSnackBarWithMessage(
                                context, error.toString()));
                          },
                          child: const PrimaryButtonView(
                            label: LBL_REGISTER,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const ORView(),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const LoginTriggerView()
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: LoadingView(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTriggerView extends StatelessWidget {
  const LoginTriggerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          LBL_ALREADY_HAVE_AN_ACCOUNT,
        ),
        const SizedBox(width: MARGIN_SMALL),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            LBL_LOGIN,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
