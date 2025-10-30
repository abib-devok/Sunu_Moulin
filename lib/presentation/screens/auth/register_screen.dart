import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matheasy_sn/app/core/routing/app_router.dart';
import 'package:matheasy_sn/presentation/blocs/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF9F1C);
    const Color backgroundLightColor = Color(0xFFFEFAF6);
    const Color textPrimaryLightColor = Color(0xFF003366);
    const Color textSecondaryLightColor = Color(0xFF5E758D);

    return Scaffold(
      backgroundColor: backgroundLightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimaryLightColor),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRouter.login),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AuthUnauthenticated && ModalRoute.of(context)!.isCurrent) {
            // Après l'inscription, on redirige vers le login
             ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text("Inscription réussie ! Veuillez vous connecter.")));
            context.go(AppRouter.login);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.network(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuBGL9DX_PC_1jE6WcBpv-ONH62hs54paVWYY_titrZBMefUF7OrF0D5wxijSDp_k6G6A97pH88RXr7cRohhNoyWbUcBJLFWHxkdSMdwUl3Ng24aaMlO_tTlBjLEKDS5bIUyaZKmskFztxDLYV-pe0Zy4hIfRkPQPiCED595b425AkGaNp3iN-Jfk01cv7KX7jgkDHdeCz9Xeq3rd_SYGvtyLR5hCjOaHDrg6TxGF3R-K-anoaixA_vJxZwNfgogUP0qDkPf3r7u4RI",
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Bienvenue !', textAlign: TextAlign.center, style: GoogleFonts.lexend(color: textPrimaryLightColor, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Crée ton compte pour commencer.', textAlign: TextAlign.center, style: GoogleFonts.lexend(color: textSecondaryLightColor, fontSize: 16)),
                    const SizedBox(height: 32),
                    _buildUsernameField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('S’inscrire', style: GoogleFonts.lexend(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => context.go(AppRouter.login),
                      child: RichText(
                        text: TextSpan(
                          text: 'Tu as déjà un compte ? ',
                          style: GoogleFonts.lexend(color: textSecondaryLightColor, fontSize: 16),
                          children: [
                            TextSpan(text: 'Se connecter', style: GoogleFonts.lexend(color: primaryColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsernameField() {
    return _buildTextField(
      controller: _usernameController,
      label: 'Nom d’utilisateur',
      hint: 'Ex: eleve2024',
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un nom d\'utilisateur';
        }
        if (value.length < 4) {
          return 'Le nom d\'utilisateur doit faire au moins 4 caractères';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _passwordController,
      label: 'Mot de passe',
      hint: 'Au moins 6 caractères',
      icon: Icons.lock_outline,
      isPassword: true,
      isPasswordVisible: _isPasswordVisible,
      onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      helperText: "1 majuscule, 1 chiffre minimum.",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un mot de passe';
        }
        if (value.length < 6) {
          return 'Le mot de passe doit faire au moins 6 caractères';
        }
        // TODO: Ajouter la validation pour la majuscule et le chiffre
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      label: 'Confirmer mot de passe',
      hint: 'Retapez votre mot de passe',
      icon: Icons.lock_outline,
      isPassword: true,
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      },
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
    String? helperText,
    String? Function(String?)? validator,
  }) {
    const Color textPrimaryLightColor = Color(0xFF003366);
    const Color textSecondaryLightColor = Color(0xFF5E758D);
    const Color inputBorderColor = Color(0xFFDAE0E7);
    const Color primaryColor = Color(0xFFFF9F1C);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.lexend(color: textPrimaryLightColor, fontWeight: FontWeight.w500, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.lexend(color: textSecondaryLightColor),
            prefixIcon: Icon(icon, color: textSecondaryLightColor),
            suffixIcon: isPassword ? IconButton(icon: Icon(isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: textSecondaryLightColor), onPressed: onToggleVisibility) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: inputBorderColor)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: inputBorderColor)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8.0),
            child: Text(helperText, style: GoogleFonts.lexend(color: textSecondaryLightColor, fontSize: 12)),
          )
      ],
    );
  }
}