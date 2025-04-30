import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/constants/assets.dart';
import 'package:presentation/screens/auth/store/auth_state.dart';
import 'package:presentation/screens/auth/store/auth_store.dart';
import 'package:presentation/screens/navigation_service.dart';
import 'package:presentation/store/form/form_state.dart';
import 'package:presentation/store/form/form_store.dart';
import 'package:presentation/utils/device/device_utils.dart';
import 'package:presentation/utils/locale/app_localization.dart';
import 'package:presentation/widgets/empty_app_bar_widget.dart';
import 'package:presentation/widgets/progress_indicator_widget.dart';
import 'package:presentation/widgets/rounded_button_widget.dart';
import 'package:presentation/widgets/textfield_widget.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';
import 'package:rizzlt_flutter_starter/main.dart';

class LoginScreen extends StatefulWidget {
  final NavigationService navigationService;
  const LoginScreen({super.key, required this.navigationService});
  static Widget create() {
    return LoginScreen(
      navigationService: GetIt.instance<NavigationService>(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  final MyFormStore _formStore = getIt<MyFormStore>();
  final AuthStore _authStore = getIt<AuthStore>();

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        MediaQuery.of(context).orientation == Orientation.landscape
            ? Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _buildLeftSide(),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildRightSide(),
                  ),
                ],
              )
            : Center(child: _buildRightSide()),
        _buildLoginProgressIndicator(),
        _buildLoggedInStatusListener(),
      ],
    );
  }

  Widget _buildLoginProgressIndicator() {
    return BlocBuilder<AuthStore, AuthState>(
      bloc: _authStore,
      builder: (context, state) {
        if (state.isLoggingIn) {
          return const CustomProgressIndicatorWidget();
        } else if (state.hasLoginError && state.loginErrorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorMessage(state.loginErrorMessage!);
          });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoggedInStatusListener() {
    return BlocListener<AuthStore, AuthState>(
        bloc: _authStore,
        listener: (context, state) {
          if (state.isLoggedIn) {
            widget.navigationService.goToHome();
          } else if (state.hasLoginError) {
            _showErrorMessage(state.loginErrorMessage!);
          }
        },
        child: const SizedBox.shrink());
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Login In',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            _buildEmailField(),
            _buildPasswordField(),
            _buildForgotPasswordButton(),
            _buildSignInButton()
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return BlocBuilder<MyFormStore, MyFormState>(
      bloc: _formStore,
      buildWhen: (previous, current) =>
          previous.userEmail != current.userEmail ||
          previous.formErrorState.userEmail != current.formErrorState.userEmail,
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Colors.black),
          ),
          child: TextFieldWidget(
            hint: AppLocalizations.of(context).translate('login_et_user_email'),
            inputType: TextInputType.emailAddress,
            icon: Icons.person,
            iconColor: Colors.black,
            textController: _userEmailController,
            inputAction: TextInputAction.next,
            autoFocus: false,
            onChanged: (value) {
              _formStore.setUserId(_userEmailController.text);
            },
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            errorText: state.formErrorState.userEmail,
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return BlocBuilder<MyFormStore, MyFormState>(
      bloc: _formStore,
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.formErrorState.password != current.formErrorState.password,
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Colors.black),
          ),
          child: Center(
            child: TextFieldWidget(
              hint: AppLocalizations.of(context)
                  .translate('login_et_user_password'),
              isObscure: true,
              padding: EdgeInsets.only(top: 16.0),
              icon: Icons.lock,
              iconColor: Colors.black,
              textController: _passwordController,
              focusNode: _passwordFocusNode,
              errorText: state.formErrorState.password,
              onChanged: (value) {
                _formStore.setPassword(_passwordController.text);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: MaterialButton(
        padding: EdgeInsets.all(0.0),
        child: Text(
          AppLocalizations.of(context).translate('login_btn_forgot_password'),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<MyFormStore, MyFormState>(
      bloc: _formStore,
      buildWhen: (previous, current) => previous.canLogin != current.canLogin,
      builder: (context, state) {
        return RoundedButtonWidget(
          buttonText:
              AppLocalizations.of(context).translate('login_btn_sign_in'),
          buttonColor: Colors.black,
          textColor: Colors.white,
          onPressed: () async {
            if (state.canLogin) {
              DeviceUtils.hideKeyboard(context);
              _authStore.login(
                _userEmailController.text,
                _passwordController.text,
              );
            } else {
              _showErrorMessage('Please fill in all fields');
            }
          },
        );
      },
    );
  }

  Widget navigate(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      widget.navigationService.goToHome();
    });

    return Container();
  }

  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
