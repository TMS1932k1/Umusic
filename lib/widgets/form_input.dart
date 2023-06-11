import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:umusic/constants/color_constant.dart';
import 'package:umusic/constants/dimen_constant.dart';
import 'package:umusic/constants/text_style_constant.dart';
import 'package:umusic/widgets/progress_loading.dart';

enum AuthState {
  LOGIN,
  REGISTER,
}

class FormInput extends StatefulWidget {
  const FormInput({super.key});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> with TickerProviderStateMixin {
  var authState = AuthState.LOGIN;
  var isLoading = false;

  Map<String, String> auth = {
    'email': '',
    'passwotd': '',
  };

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Set auth state
  // With param:
  //   -- [AuthState state] to set into authState
  void changeAuthState(AuthState state) {
    setState(() {
      if (authState == AuthState.LOGIN) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      if (authState != state) authState = state;
    });
  }

  // Onclick Login or Register button
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return; // Invalid
    _formKey.currentState!.save();

    // Set waitting in time waitting to login or register
    setState(() {
      isLoading = true;
    });

    if (authState == AuthState.REGISTER) {
      await createUserWithEmailAndPassword().then(
        (value) => setState(() {
          isLoading = false;
        }),
      );
    } else if (authState == AuthState.LOGIN) {
      await signInWithEmailAndPassword().then(
        (value) => setState(() {
          isLoading = false;
        }),
      );
    }
  }

  // Check email password to sign up
  // If success will
  // If failed will show snackbar mes to show error
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: auth['email']!,
        password: auth['password']!,
      );

      await signInWithEmailAndPassword(); // Auto sign in
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(
          context,
          'The password provided is too weak!!',
        );
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
          context,
          'The account already exists for that email!!',
        );
      }
    } catch (e) {
      showSnackBar(
        context,
        'Have error in sign up!!',
      );
    }
  }

  // Check email password to sign in
  // If success will pop screen
  // If failed will show snackbar mes to show error
  Future<void> signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: auth['email']!,
        password: auth['password']!,
      );

      Navigator.of(context).pop(); // Back screen
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
          context,
          'No user found for that email!!',
        );
      } else if (e.code == 'wrong-password') {
        showSnackBar(
          context,
          'Wrong password provided for that user!!',
        );
      }
    }
  }

  void showSnackBar(BuildContext context, String mes) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      height: authState == AuthState.LOGIN
          ? kHeightAuthFormInputCollapsed
          : kHeightAuthFormInputExpand,
      width: kWidthAuthFormInput,
      decoration: BoxDecoration(
        border: Border.all(
          color: colorWhite,
        ),
        borderRadius: BorderRadius.circular(kRadiusMedium),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: kPandingMedium,
        horizontal: kPandingLarge,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                authState.name,
                style: titleMedium,
              ),
              const SizedBox(height: kPandingSmall),
              TextFormField(
                decoration: InputDecoration(
                  icon: const FaIcon(FontAwesomeIcons.envelope),
                  hintText: 'Input your email',
                  hintStyle: textSmall.copyWith(color: colorGray),
                ),
                validator: (value) {
                  // Check format email
                  if (value == null) return 'Invalid email!';
                  final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (value.trim().isEmpty || !emailValid) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (newValue) => auth['email'] = newValue!,
                style: textSmall.copyWith(color: colorWhite),
                maxLines: 1,
              ),
              const SizedBox(height: kPandingSmall),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  icon: const FaIcon(FontAwesomeIcons.key),
                  hintText: 'Input password',
                  hintStyle: textSmall.copyWith(color: colorGray),
                ),
                validator: (value) {
                  // Check format password
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 7) {
                    return 'Invalid password!';
                  }
                  return null;
                },
                onSaved: (newValue) => auth['password'] = newValue!,
                style: textSmall.copyWith(color: colorWhite),
                obscureText: true,
                maxLines: 1,
              ),
              const SizedBox(height: kPandingSmall),
              AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
                constraints: BoxConstraints(
                  maxHeight: authState == AuthState.REGISTER ? 80 : 0,
                  minHeight: authState == AuthState.REGISTER ? 80 : 0,
                ),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: kPandingSmall),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: const FaIcon(FontAwesomeIcons.circleCheck),
                            hintText: 'Confirm password',
                            hintStyle: textSmall.copyWith(color: colorGray),
                          ),
                          style: textSmall.copyWith(color: colorWhite),
                          validator: authState == AuthState.REGISTER
                              ? (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                          obscureText: true,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kPandingSmall),
              if (isLoading) const ProgressLoading(),
              if (!isLoading)
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      elevation: 0.0,
                    ),
                    child: Text(
                      authState.name,
                      style: titleSmall,
                    ),
                  ),
                ),
              TextButton(
                onPressed: authState == AuthState.LOGIN
                    ? () => changeAuthState(AuthState.REGISTER)
                    : () => changeAuthState(AuthState.LOGIN),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0.0),
                  elevation: 0.0,
                ),
                child: Text(
                  authState == AuthState.LOGIN
                      ? 'I want to register an account!'
                      : 'I had an account to login',
                  style: textSmall.copyWith(color: colorYellow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
