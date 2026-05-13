import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final _phoneController =
  TextEditingController();

  final _codeController =
  TextEditingController();

  void _login() {

    if (_formKey.currentState!.validate()) {

      Get.offAll(

            () => MainNavigation(
          phone: _phoneController.text,
        ),
      );
    }
  }

  @override
  void dispose() {

    _phoneController.dispose();

    _codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Connexion'),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              const SizedBox(height: 40),

              /// TELEPHONE
              TextFormField(

                controller: _phoneController,

                keyboardType: TextInputType.phone,

                decoration: InputDecoration(

                  labelText: 'Numéro',

                  hintText: '01 23 45 67',

                  prefixIcon: Padding(

                    padding:
                    const EdgeInsets.all(10),

                    child: Row(

                      mainAxisSize:
                      MainAxisSize.min,

                      children: [

                        const Text(
                          '🇲🇷',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(width: 8),

                        const Text(

                          '+222',

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  border: OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return
                      'Entrez votre numéro';
                  }

                  if (!RegExp(
                      r'^[2-4][0-9]{7}$')
                      .hasMatch(value)) {

                    return
                      'Numéro invalide '
                          '(8 chiffres, doit commencer '
                          'par 2, 3 ou 4)';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// CODE
              TextFormField(

                controller: _codeController,

                obscureText: true,

                decoration:
                const InputDecoration(

                  labelText: 'Code',

                  border:
                  OutlineInputBorder(),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return
                      'Entrez votre code';
                  }

                  if (!RegExp(r'^[0-9]{4}$')
                      .hasMatch(value)) {

                    return
                      'Code invalide '
                          '(4 chiffres)';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: _login,

                  child: const Text(
                    'SE CONNECTER',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}