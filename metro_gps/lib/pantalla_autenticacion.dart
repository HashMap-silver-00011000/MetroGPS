import 'dart:convert';

import 'package:flutter/material.dart';

class LoginInput {
  LoginInput({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }
}

class RegistroInput {
  RegistroInput({
    required this.nombre,
    required this.apellidos,
    required this.rol,
    required this.email,
    required this.password,
  });

  final String nombre;
  final String apellidos;
  final String rol;
  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nombre': nombre,
      'apellidos': apellidos,
      'rol': rol,
      'email': email,
      'password': password,
    };
  }
}

enum AuthTab { login, registro }

class PantallaAutenticacion extends StatefulWidget {
  const PantallaAutenticacion({
    super.key,
    this.onLoginSubmit,
    this.onRegistroSubmit,
  });

  final ValueChanged<Map<String, dynamic>>? onLoginSubmit;
  final ValueChanged<Map<String, dynamic>>? onRegistroSubmit;

  @override
  State<PantallaAutenticacion> createState() => _PantallaAutenticacionState();
}

class _PantallaAutenticacionState extends State<PantallaAutenticacion> {
  static const Color _verdeInstitucional = Color(0xFF007A33);
  static const Color _colorTexto = Color(0xFF141414);
  static const Color _colorSubtexto = Color(0xFF3D3D3D);
  static const List<String> _roles = <String>['Conductor', 'Pasajero', 'Admin'];

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registroFormKey = GlobalKey<FormState>();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registroNombreController = TextEditingController();
  final TextEditingController _registroApellidosController = TextEditingController();
  final TextEditingController _registroEmailController = TextEditingController();
  final TextEditingController _registroPasswordController = TextEditingController();

  String? _rolSeleccionado;
  AuthTab _tab = AuthTab.login;
  bool _ocultarPasswordLogin = true;
  bool _ocultarPasswordRegistro = true;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registroNombreController.dispose();
    _registroApellidosController.dispose();
    _registroEmailController.dispose();
    _registroPasswordController.dispose();
    super.dispose();
  }

  String? _validarCampoRequerido(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo $label es obligatorio';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es obligatorio';
    }
    final RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Ingresa un email valido';
    }
    return null;
  }

  String? _validarPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La contrasena es obligatoria';
    }
    if (value.trim().length < 6) {
      return 'Debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _enviarLogin() {
    final FormState? form = _loginFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final LoginInput payload = LoginInput(
      email: _loginEmailController.text.trim(),
      password: _loginPasswordController.text.trim(),
    );

    widget.onLoginSubmit?.call(payload.toJson());
    debugPrint('LoginInput JSON => ${jsonEncode(payload.toJson())}');
  }

  void _enviarRegistro() {
    final FormState? form = _registroFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_rolSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un rol')),
      );
      return;
    }

    final RegistroInput payload = RegistroInput(
      nombre: _registroNombreController.text.trim(),
      apellidos: _registroApellidosController.text.trim(),
      rol: _rolSeleccionado!,
      email: _registroEmailController.text.trim(),
      password: _registroPasswordController.text.trim(),
    );

    widget.onRegistroSubmit?.call(payload.toJson());
    debugPrint('RegistroInput JSON => ${jsonEncode(payload.toJson())}');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE9ECEF)),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Metrolinea Movil',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: _colorTexto,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Accede o crea tu cuenta para continuar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _colorSubtexto,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildSelectorModo(theme),
                    const SizedBox(height: 18),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _tab == AuthTab.login
                          ? _buildLoginForm(theme)
                          : _buildRegistroForm(theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorModo(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _TabBoton(
              texto: 'Login',
              activo: _tab == AuthTab.login,
              verdeInstitucional: _verdeInstitucional,
              onTap: () => setState(() => _tab = AuthTab.login),
            ),
          ),
          Expanded(
            child: _TabBoton(
              texto: 'Registro',
              activo: _tab == AuthTab.registro,
              verdeInstitucional: _verdeInstitucional,
              onTap: () => setState(() => _tab = AuthTab.registro),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey<String>('login-form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextField(
            controller: _loginEmailController,
            label: 'Email',
            hint: 'usuario@correo.com',
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _loginPasswordController,
            label: 'Contrasena',
            hint: 'Ingresa tu contrasena',
            obscureText: _ocultarPasswordLogin,
            validator: _validarPassword,
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => _ocultarPasswordLogin = !_ocultarPasswordLogin,
              ),
              icon: Icon(
                _ocultarPasswordLogin ? Icons.visibility_off : Icons.visibility,
                color: _colorSubtexto,
              ),
            ),
          ),
          const SizedBox(height: 18),
          _buildBotonPrincipal(
            texto: 'Ingresar',
            onPressed: _enviarLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistroForm(ThemeData theme) {
    return Form(
      key: _registroFormKey,
      child: Column(
        key: const ValueKey<String>('registro-form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextField(
            controller: _registroNombreController,
            label: 'Nombre',
            hint: 'Tu nombre',
            validator: (String? v) => _validarCampoRequerido(v, 'nombre'),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _registroApellidosController,
            label: 'Apellidos',
            hint: 'Tus apellidos',
            validator: (String? v) => _validarCampoRequerido(v, 'apellidos'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _rolSeleccionado,
            isExpanded: true,
            decoration: _decoracionInput('Rol', 'Selecciona tu rol'),
            validator: (String? value) => value == null ? 'El rol es obligatorio' : null,
            items: _roles
                .map(
                  (String rol) => DropdownMenuItem<String>(
                    value: rol,
                    child: Text(
                      rol,
                      style: const TextStyle(
                        color: _colorTexto,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? value) => setState(() => _rolSeleccionado = value),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _registroEmailController,
            label: 'Email',
            hint: 'usuario@correo.com',
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _registroPasswordController,
            label: 'Contrasena',
            hint: 'Minimo 6 caracteres',
            obscureText: _ocultarPasswordRegistro,
            validator: _validarPassword,
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => _ocultarPasswordRegistro = !_ocultarPasswordRegistro,
              ),
              icon: Icon(
                _ocultarPasswordRegistro ? Icons.visibility_off : Icons.visibility,
                color: _colorSubtexto,
              ),
            ),
          ),
          const SizedBox(height: 18),
          _buildBotonPrincipal(
            texto: 'Crear cuenta',
            onPressed: _enviarRegistro,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        color: _colorTexto,
        fontFamily: 'SF Pro Text',
      ),
      decoration: _decoracionInput(label, hint, suffixIcon: suffixIcon),
    );
  }

  InputDecoration _decoracionInput(
    String label,
    String hint, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(
        color: _colorSubtexto,
        fontFamily: 'SF Pro Text',
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF7A7A7A),
        fontFamily: 'SF Pro Text',
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD7DDE0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _verdeInstitucional, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB42318)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB42318), width: 1.3),
      ),
    );
  }

  Widget _buildBotonPrincipal({
    required String texto,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _verdeInstitucional,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'SF Pro Display',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(texto),
      ),
    );
  }
}

class _TabBoton extends StatelessWidget {
  const _TabBoton({
    required this.texto,
    required this.activo,
    required this.verdeInstitucional,
    required this.onTap,
  });

  final String texto;
  final bool activo;
  final Color verdeInstitucional;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: activo ? verdeInstitucional : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: activo ? Colors.white : _PantallaAutenticacionState._colorTexto,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
    );
  }
}
