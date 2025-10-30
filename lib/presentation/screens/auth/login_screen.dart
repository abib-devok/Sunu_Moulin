import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF5F7F8);
    const Color textColor = Color(0xFF101418);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.yellow.shade100, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.yellow.shade800, size: 16),
                      const SizedBox(width: 8),
                      Text('Hors ligne', style: GoogleFonts.lexend(color: Colors.yellow.shade800, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          "https://lh3.googleusercontent.com/aida-public/AB6AXuDRO0dyDTh_DzszaZ2yqPLq6sGYAbeL4tcWXwFlURJtibsgrKz_7lYBbBobjB9bDqBT6rsxX_6oh0U6KVsqhA6l8qYMNvDXsavqixn-HEtqp1aDJUJKrckBmRuJ8I79bqPYOFEWqv7lMEU11MQgctIGEdh1bRPh7unWpPLH_MoCuNw6zRhj3ICdTLBVH3AKoKpBS8o-DC0SFPGtrBqxKZUr6JhPiXs_Pwb0A8WylS7HulAnIOp03ueI98nzewMdLuZdAZSaty7oWw4",
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        Text('Content de te revoir !', textAlign: TextAlign.center, style: GoogleFonts.lexend(color: textColor, fontSize: 32, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 32),
                        _buildUsernameField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 24),
                        _buildLoginButton(),
                        const SizedBox(height: 16),
                        _buildErrorMessages(),
                        const SizedBox(height: 24),
                        _buildRegisterLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return _buildTextField(
      controller: _usernameController,
      label: 'Nom d’utilisateur',
      hint: "Entrez votre nom d'utilisateur",
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre nom d\'utilisateur';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _passwordController,
      label: 'Mot de passe',
      hint: 'Entrez votre mot de passe',
      icon: Icons.lock_outline,
      isPassword: true,
      isPasswordVisible: _isPasswordVisible,
      onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    const Color primaryColor = Color(0xFFE85A24);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return ElevatedButton(
          onPressed: isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 18),
            elevation: 5,
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text('Se connecter', style: GoogleFonts.lexend(fontWeight: FontWeight.bold, fontSize: 16)),
        );
      },
    );
  }

  Widget _buildErrorMessages() {
    const Color errorColor = Color(0xFFD32F2F);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthError) {
          return Column(
            children: [
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(color: errorColor, fontWeight: FontWeight.w500),
              ),
            ],
          );
        }
        return const SizedBox(height: 24);
      },
    );
  }

  Widget _buildRegisterLink() {
    const Color primaryColor = Color(0xFFE85A24);
    const Color hintColor = Color(0xFF5E758D);
    return TextButton(
      onPressed: () => context.go(AppRouter.register),
      child: RichText(
        text: TextSpan(
          text: 'Pas encore de compte ? ',
          style: GoogleFonts.lexend(color: hintColor, fontSize: 16),
          children: [
            TextSpan(text: 'Créer un compte', style: GoogleFonts.lexend(color: primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    const Color textColor = Color(0xFF101418);
    const Color hintColor = Color(0xFF5E758D);
    const Color primaryColor = Color(0xFFE85A24);
    const Color inputBorderColor = Color(0xFFDAE0E7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.lexend(color: textColor, fontWeight: FontWeight.w500, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          style: GoogleFonts.lexend(color: textColor),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.lexend(color: hintColor),
            prefixIcon: Icon(icon, color: hintColor),
            suffixIcon: isPassword ? IconButton(icon: Icon(isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: hintColor), onPressed: onToggleVisibility) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: inputBorderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: inputBorderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
          ),
        ),
      ],
    );
  }
}