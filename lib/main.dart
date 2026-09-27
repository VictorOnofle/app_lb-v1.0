import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'viewmodels/tesouraria_viewmodel.dart';
import 'views/login_page.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/irmandade_viewmodel.dart';
import 'viewmodels/mural_viewmodel.dart';
import 'viewmodels/calendario_viewmodel.dart';
import 'viewmodels/perfil_viewmodel.dart';
import 'viewmodels/recuperacao_viewmodel.dart';
import 'viewmodels/registro_viewmodel.dart';
import 'viewmodels/rota_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Aqui nós injetamos a "inteligência" do app
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TesourariaViewModel()),
        ChangeNotifierProvider(create: (_) => IrmandadeViewModel()..carregarMembros()),
        ChangeNotifierProvider(create: (_) => MuralViewModel()..carregarPosts()),
        ChangeNotifierProvider(create: (_) => CalendarioViewModel()..carregarEventos()),
        ChangeNotifierProvider(create: (_) => PerfilViewModel()..carregarDados()),
        ChangeNotifierProvider(create: (_) => RecuperacaoViewModel()),
        ChangeNotifierProvider(create: (_) => RegistroViewModel()),
        ChangeNotifierProvider(create: (_) => RotaViewModel())
      ],
      child: const LobosCafajestesApp(),
    ),
  );
}

class LobosCafajestesApp extends StatelessWidget {
  const LobosCafajestesApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mcGold = Color(0xFFFDD835);
    const Color mcDarkSurface = Color(0xFF1E1E1E);

    return MaterialApp(
      title: 'Lobos Cafajestes MC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: mcGold,
          secondary: mcGold,
          surface: mcDarkSurface,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.oswald(fontWeight: FontWeight.bold, color: mcGold),
          titleLarge: GoogleFonts.oswald(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: mcGold),
          titleTextStyle: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.bold, color: mcGold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mcGold,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 55),
            elevation: 4,
            textStyle: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: mcDarkSurface,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: mcGold, width: 2),
          ),
          prefixIconColor: Colors.grey,
        ),
      ),
      home: const LoginPage(), // Aponta para o novo arquivo
    );
  }
}