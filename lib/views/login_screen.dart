import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade400,
                  Colors.pink.shade600,
                  Colors.purple.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Contenido principal
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Espacio superior
                        SizedBox(height: 20),
                        // Imagen de la Virgen (completa y centrada)
                        Center(
                          child: Container(
                            height: 120, // Ajusta la altura según sea necesario
                            width: 120,  // Ajusta el ancho según sea necesario
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/logo.png'),
                                fit: BoxFit.contain, // Asegura que la imagen completa se vea
                              ),
                            ),
                          ),
                        ),
                        // Espacio debajo de la imagen
                        SizedBox(height: 20),
                        // Título
                        Center(
                          child: Text(
                            'Clínica Virgen de Guadalupe',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Inicia sesión para continuar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Campo de correo electrónico
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        // Campo de contraseña
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 24),
                        // Botón de inicio de sesión
                        Consumer<AuthViewModel>(
                          builder: (context, authViewModel, child) {
                            return authViewModel.isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                              onPressed: () async {
                                final email = emailController.text.trim();
                                final password =
                                passwordController.text.trim();

                                if (email.isEmpty ||
                                    password.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Por favor, llena todos los campos.'),
                                    ),
                                  );
                                  return;
                                }

                                final success = await authViewModel
                                    .signIn(email, password);

                                if (success) {
                                  Navigator.of(context)
                                      .pushReplacementNamed(
                                      '/homeadmin');
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(authViewModel
                                          .errorMessage ??
                                          'Error desconocido al iniciar sesión.'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.purple.shade700,
                              ),
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        // Botón de registro
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            '¿No tienes cuenta? Regístrate',
                            style: TextStyle(color: Colors.purple.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
