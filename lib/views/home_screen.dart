import 'package:flutter/material.dart';
import 'package:lobos_cafajestes/views/irmandade_tab.dart';
import 'package:lobos_cafajestes/views/calendario_tab.dart';
import 'package:lobos_cafajestes/views/mural_tab.dart';
import 'package:lobos_cafajestes/views/perfil_tab.dart';
import 'package:lobos_cafajestes/views/rota_tab.dart';
import 'package:lobos_cafajestes/views/tesouraria_tab.dart';


// import 'package:lottie/lottie.dart'; // Se for colar a aba de Rota aqui embaixo por enquanto

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Como o TabController é apenas visual (muda as telas),
// ele fica na View mesmo, não precisa ir pro ViewModel.
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(tag: 'mc_logo', child: Image.asset('assets/logo.png', height: 35)),
            const SizedBox(width: 12),
            const Text('LOBOS CAFAJESTES'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 3,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.newspaper_rounded), text: 'Mural'),
            Tab(icon: Icon(Icons.map), text: 'Rota'),
            Tab(icon: Icon(Icons.groups), text: 'Irmandade'),
            Tab(icon: Icon(Icons.attach_money), text: 'Tesouraria'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Agenda'),
            Tab(icon: Icon(Icons.person), text: 'Perfil'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MuralTab(),
          RotaTab(),
          IrmandadeTab(),
          TesourariaTab(),
          CalendarioTab(),
          PerfilTab(),
        ],
      ),
    );
  }
}
