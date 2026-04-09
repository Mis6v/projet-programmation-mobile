import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: Padding(
        padding: const EdgeInsets.all(20),

        // ✅ FORM
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // ✅ NOM
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Le nom est obligatoire";
                  }
                  return null;
                },
              ),

              // ✅ EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "L'email est obligatoire";
                  }

                  if (!value.endsWith("@gmail.com")) {
                    return "Email doit contenir @gmail.com";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ✅ BOUTON
              ElevatedButton(
                onPressed: () {

                  // 🔥 Validation
                  if (_formKey.currentState!.validate()) {

                    Navigator.pop(context, {
                      'name': nameController.text,
                      'email': emailController.text,
                    });

                  }

                },
                child: const Text("Enregistrer"),
              )
            ],
          ),
        ),
      ),
    );
  }
}