import 'package:cotacao/constants/constants.dart';
import 'package:cotacao/pages/base_screen.dart';
import 'package:cotacao/repository/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
        body: Stack(
      children: [
        Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Logo(),
                      SingleChildScrollView(child: _FormContent()),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )),
      ],
    ));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Image(
            width: isSmallScreen ? 230 : 200,
            image: const AssetImage(
              'assets/images/aprovado.png',
            ),
          ),
        ),
        // FlutterLogo(size: isSmallScreen ? 100 : 200),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final usuarioController = TextEditingController(text: 'paulopennacchi');
  final passwordController = TextEditingController(text: '12345678');

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Login>(context, listen: false)
          .logar(usuarioController.text, passwordController.text)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value == true) {
          Get.offAll(() => const BaseScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário ou senha inválidos')));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usuarioController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre com algum texto';
                }
                return null;
              },
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Usuário',
                hintText: 'Digite seu usuário',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: 22,
                  color: Constants.verde,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre com algum texto';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    size: 22,
                    color: Constants.verde,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Constants.verde),
                  )
                : SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'ENTRAR',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      onPressed: () {
                        _submit();
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
