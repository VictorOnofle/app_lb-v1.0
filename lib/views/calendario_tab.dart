import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../models/evento_model.dart';
import '../viewmodels/calendario_viewmodel.dart';

class CalendarioTab extends StatelessWidget {
  const CalendarioTab({super.key});

  final List<String> _meses = const ['', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];

  Color _getCorEvento(String tipo) {
    switch (tipo) {
      case 'aniversario': return Colors.blue;
      case 'reuniao': return Colors.red;
      case 'role': default: return const Color(0xFFFDD835);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarioViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFDD835)));
        }

        List<EventoMC> eventosDoMes = viewModel.eventos.where((e) =>
        e.data.month == viewModel.dataFocada.month &&
            e.data.year == viewModel.dataFocada.year &&
            viewModel.podeVerEvento(e)
        ).toList();

        return SafeArea(
          child: Column(
            children: [
              // Toggle Diretoria / Membro
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => viewModel.alterarModoDiretoria(false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !viewModel.isDiretor ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text('Visão Membro', style: TextStyle(color: !viewModel.isDiretor ? Theme.of(context).colorScheme.primary : Colors.white54))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => viewModel.alterarModoDiretoria(true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: viewModel.isDiretor ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(child: Text('Visão Diretoria', style: TextStyle(color: viewModel.isDiretor ? Theme.of(context).colorScheme.primary : Colors.white54))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Destaques do Mês', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),

                      _buildCarrossel(context, eventosDoMes),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _abrirModalSugerirEvento(context, viewModel),
                          icon: const Icon(Icons.add_circle_outline),
                          label: Text(viewModel.isDiretor ? 'CRIAR EVENTO OFICIAL' : 'SUGERIR NOVO EVENTO'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E1E1E),
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              side: BorderSide(color: Theme.of(context).colorScheme.primary)
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Navegação dos Meses
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white), onPressed: () => viewModel.mudarMes(-1)),
                            Text('${_meses[viewModel.dataFocada.month]} ${viewModel.dataFocada.year}'.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFDD835))),
                            IconButton(icon: const Icon(Icons.chevron_right, color: Colors.white), onPressed: () => viewModel.mudarMes(1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildCalendarioGrid(context, viewModel),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =======================================================
  // COMPONENTES VISUAIS (Grid, Carrossel, Botões)
  // =======================================================

  Widget _buildCarrossel(BuildContext context, List<EventoMC> eventosDoMes) {
    List<EventoMC> destaques = eventosDoMes.where((e) => e.status == 'Aprovado').toList();

    if (destaques.isEmpty) {
      return Container(
        height: 220, margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[900]!)),
        alignment: Alignment.center,
        child: const Text('Nenhum evento destacado neste mês', style: TextStyle(color: Colors.white54)),
      );
    }

    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: destaques.length,
        itemBuilder: (context, index) {
          final evento = destaques[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: Colors.black, child: const Icon(Icons.two_wheeler, size: 100, color: Colors.white10)),
                Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: _getCorEvento(evento.tipo), borderRadius: BorderRadius.circular(4)),
                        child: Text('${evento.data.day} de ${_meses[evento.data.month]} • ${evento.horario}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(height: 8),
                      Text(evento.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarioGrid(BuildContext context, CalendarioViewModel viewModel) {
    int diasNoMes = DateUtils.getDaysInMonth(viewModel.dataFocada.year, viewModel.dataFocada.month);
    int primeiroDiaSemana = DateTime(viewModel.dataFocada.year, viewModel.dataFocada.month, 1).weekday % 7;
    const List<String> diasSemana = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    DateTime hoje = DateTime.now();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: diasSemana.map((dia) => Text(dia, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))).toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8,
          ),
          itemCount: diasNoMes + primeiroDiaSemana,
          itemBuilder: (context, index) {
            if (index < primeiroDiaSemana) return const SizedBox();

            int dia = index - primeiroDiaSemana + 1;
            DateTime dataAtual = DateTime(viewModel.dataFocada.year, viewModel.dataFocada.month, dia);
            bool isHoje = dataAtual.year == hoje.year && dataAtual.month == hoje.month && dataAtual.day == hoje.day;

            List<EventoMC> eventosVisiveis = viewModel.eventos.where((e) =>
            e.data.year == dataAtual.year && e.data.month == dataAtual.month && e.data.day == dataAtual.day && viewModel.podeVerEvento(e)
            ).toList();

            return GestureDetector(
              onTap: () => _onDiaTap(context, dataAtual, viewModel),
              child: Container(
                decoration: BoxDecoration(
                  color: isHoje ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : const Color(0xFF1E1E1E),
                  border: Border.all(color: isHoje ? Theme.of(context).colorScheme.primary : Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$dia', style: TextStyle(fontWeight: isHoje ? FontWeight.bold : FontWeight.normal, color: isHoje ? Theme.of(context).colorScheme.primary : Colors.white)),
                    if (eventosVisiveis.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            eventosVisiveis.length > 4 ? 4 : eventosVisiveis.length,
                                (i) {
                              if (eventosVisiveis.length > 4 && i == 3) {
                                return Padding(padding: const EdgeInsets.only(left: 2.0), child: Text('+${eventosVisiveis.length - 3}', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)));
                              }
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                width: 6, height: 6,
                                decoration: BoxDecoration(color: eventosVisiveis[i].status == 'Pendente' ? Colors.orange : _getCorEvento(eventosVisiveis[i].tipo), shape: BoxShape.circle),
                              );
                            }
                        ),
                      )
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =======================================================
  // LÓGICA DE MODAIS E INTERAÇÃO
  // =======================================================

  void _onDiaTap(BuildContext context, DateTime dataAtual, CalendarioViewModel parentViewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151515),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return Consumer<CalendarioViewModel>(
          builder: (context, viewModel, child) {
            List<EventoMC> eventosDoDia = viewModel.eventos.where((e) =>
            e.data.year == dataAtual.year && e.data.month == dataAtual.month && e.data.day == dataAtual.day && viewModel.podeVerEvento(e)
            ).toList();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 24),
                  Text('${dataAtual.day} de ${_meses[dataAtual.month]} de ${dataAtual.year}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),

                  if (eventosDoDia.isNotEmpty) ...[
                    ...eventosDoDia.map((evento) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      color: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: evento.status == 'Pendente' ? Colors.orange : Colors.transparent, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AVISO DE SURPRESA (Se for diretor)
                            if (evento.isFestaSurpresa && viewModel.isDiretor)
                              Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text('🤫 Surpresa para ${evento.aniversarianteNome}!', style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))),

                            // BANNER DO EVENTO
                            if (evento.temBanner)
                              Container(
                                height: 120, width: double.infinity, margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5))),
                                child: const Center(child: Icon(Icons.image, size: 40, color: Colors.white54)),
                              ),

                            // TÍTULO E HORA
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(evento.titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getCorEvento(evento.tipo)))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                                  child: Row(children: [const Icon(Icons.access_time, size: 14, color: Colors.white70), const SizedBox(width: 4), Text(evento.horario, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(evento.descricao, style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 16),

                            // LINK DE MAPA RESTAURADO
                            if (evento.linkLocalizacao != null && evento.linkLocalizacao!.isNotEmpty) ...[
                              OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abrindo GPS para a rota...'), backgroundColor: Colors.blueAccent));
                                },
                                icon: const Icon(Icons.map, color: Colors.blueAccent),
                                label: const Text('VER LOCAL NO MAPA', style: TextStyle(color: Colors.blueAccent)),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blueAccent), minimumSize: const Size(double.infinity, 40)),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // STATUS E REAÇÕES
                            if (evento.status == 'Pendente') ...[
                              if (viewModel.isDiretor)
                                Row(
                                  children: [
                                    Expanded(child: OutlinedButton(onPressed: () { viewModel.alterarStatusEvento(evento.id, 'Recusado'); }, style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)), child: const Text('RECUSAR', style: TextStyle(color: Colors.redAccent)))),
                                    const SizedBox(width: 8),
                                    Expanded(child: ElevatedButton(onPressed: () { viewModel.alterarStatusEvento(evento.id, 'Aprovado'); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evento Aprovado!'), backgroundColor: Colors.green)); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('APROVAR', style: TextStyle(color: Colors.white)))),
                                  ],
                                )
                              else
                                Container(width: double.infinity, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('⏳ Aguardando aprovação da Diretoria', textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)))
                            ]
                            else ...[
                              const Text('Sua Presença:', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildReacaoBtn(context, viewModel, evento, 'joia', '👍'),
                                  _buildReacaoBtn(context, viewModel, evento, 'nao_joia', '👎'),
                                  _buildReacaoBtn(context, viewModel, evento, 'pensando', '🤔'),
                                ],
                              ),

                              // PAINEL DA DIRETORIA RESTAURADO
                              if (viewModel.isDiretor) ...[
                                const SizedBox(height: 24),
                                const Divider(color: Colors.white24, height: 1),
                                const SizedBox(height: 16),
                                const Row(children: [Icon(Icons.admin_panel_settings, color: Color(0xFFFDD835), size: 20), SizedBox(width: 8), Text('PAINEL DA DIRETORIA (Resumo)', style: TextStyle(color: Color(0xFFFDD835), fontWeight: FontWeight.bold, fontSize: 14))]),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildContadorDiretoria('👍', evento.totalJoia + (evento.reacaoUsuario == 'joia' ? 1 : 0), Colors.green),
                                    _buildContadorDiretoria('👎', evento.totalNaoJoia + (evento.reacaoUsuario == 'nao_joia' ? 1 : 0), Colors.redAccent),
                                    _buildContadorDiretoria('🤔', evento.totalPensando + (evento.reacaoUsuario == 'pensando' ? 1 : 0), Colors.orange),
                                  ],
                                ),
                              ]
                            ]
                          ],
                        ),
                      ),
                    ))
                  ] else ...[
                    const Text('Nenhum evento agendado para este dia.', style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 24),
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReacaoBtn(BuildContext context, CalendarioViewModel viewModel, EventoMC evento, String reacao, String emoji) {
    bool selecionado = evento.reacaoUsuario == reacao;
    return InkWell(
      onTap: () {
        viewModel.reagirEvento(evento.id, reacao);
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selecionado ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: selecionado ? Theme.of(context).colorScheme.primary : Colors.grey[800]!),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildContadorDiretoria(String emoji, int total, Color corSinal) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: corSinal.withOpacity(0.5)),
          ),
          child: Text(
            total.toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corSinal),
          ),
        ),
      ],
    );
  }

  void _abrirModalSugerirEvento(BuildContext context, CalendarioViewModel viewModel) {
    final _tituloCtrl = TextEditingController();
    final _dataCtrl = TextEditingController();
    final _horarioCtrl = TextEditingController();
    final _descCtrl = TextEditingController();
    final _linkCtrl = TextEditingController(); // LINK RESTAURADO
    final _aniversarianteCtrl = TextEditingController(); // SURPRESA RESTAURADA

    bool _isSurpresa = false;
    DateTime? _dataEscolhida;
    String _tipoSelecionado = 'role';
    bool _bannerAnexado = false; // BANNER RESTAURADO

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF151515),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(viewModel.isDiretor ? 'Criar Evento Oficial' : 'Sugerir Novo Evento', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFDD835))),
                      const SizedBox(height: 16),

                      // DROPDOWN RESTAURADO
                      DropdownButtonFormField<String>(
                        value: _tipoSelecionado,
                        decoration: const InputDecoration(labelText: 'Tipo de Evento', prefixIcon: Icon(Icons.category)),
                        items: const [
                          DropdownMenuItem(value: 'role', child: Text('Rolê / Viagem (Amarelo)')),
                          DropdownMenuItem(value: 'aniversario', child: Text('Aniversário / Festa (Azul)')),
                          DropdownMenuItem(value: 'reuniao', child: Text('Reunião (Vermelho)')),
                        ],
                        onChanged: (val) => setModalState(() {
                          _tipoSelecionado = val!;
                          if (_tipoSelecionado != 'aniversario') _isSurpresa = false;
                        }),
                      ),
                      const SizedBox(height: 12),

                      TextField(controller: _tituloCtrl, decoration: const InputDecoration(labelText: 'Título do Evento')),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _dataCtrl, decoration: const InputDecoration(labelText: 'Data', prefixIcon: Icon(Icons.calendar_today)), readOnly: true,
                              onTap: () async {
                                final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                                if (picked != null) setModalState(() { _dataEscolhida = picked; _dataCtrl.text = DateFormat('dd/MM/yyyy').format(picked); });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: TextField(controller: _horarioCtrl, decoration: const InputDecoration(labelText: 'Hora', hintText: '20:00'), keyboardType: TextInputType.datetime),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(controller: _descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Descrição ou Ponto de Encontro')),
                      const SizedBox(height: 12),

                      // LINK RESTAURADO
                      TextField(controller: _linkCtrl, decoration: const InputDecoration(labelText: 'Link de Localização (Opcional)', prefixIcon: Icon(Icons.map))),
                      const SizedBox(height: 12),

                      // BOTÃO DE BANNER RESTAURADO
                      OutlinedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                          if (result != null) {
                            setModalState(() => _bannerAnexado = true);
                          }
                        },
                        icon: Icon(_bannerAnexado ? Icons.check_circle : Icons.image, color: _bannerAnexado ? Colors.green : Theme.of(context).colorScheme.primary),
                        label: Text(_bannerAnexado ? 'Banner Anexado com Sucesso' : 'Anexar Banner do Evento (Opcional)'),
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: BorderSide(color: _bannerAnexado ? Colors.green : Theme.of(context).colorScheme.primary),
                            foregroundColor: _bannerAnexado ? Colors.green : Colors.white
                        ),
                      ),
                      const SizedBox(height: 12),

                      // LÓGICA DE SURPRESA RESTAURADA
                      if (_tipoSelecionado == 'aniversario') ...[
                        SwitchListTile(
                          title: const Text('É uma festa surpresa?', style: TextStyle(fontWeight: FontWeight.bold)),
                          activeColor: Colors.purpleAccent,
                          value: _isSurpresa,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) => setModalState(() => _isSurpresa = val),
                        ),
                        if (_isSurpresa) ...[
                          TextField(
                            controller: _aniversarianteCtrl,
                            decoration: const InputDecoration(labelText: 'Nome/Apelido do Aniversariante', prefixIcon: Icon(Icons.visibility_off, color: Colors.purpleAccent)),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],

                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_tituloCtrl.text.isNotEmpty && _dataEscolhida != null) {
                            viewModel.adicionarEvento(EventoMC(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              titulo: _tituloCtrl.text,
                              data: _dataEscolhida!,
                              horario: _horarioCtrl.text.isEmpty ? 'A definir' : _horarioCtrl.text,
                              descricao: _descCtrl.text,
                              status: viewModel.isDiretor ? 'Aprovado' : 'Pendente',
                              tipo: _tipoSelecionado, // Passando o tipo correto
                              linkLocalizacao: _linkCtrl.text, // Passando o link
                              temBanner: _bannerAnexado, // Passando o banner
                              isFestaSurpresa: _isSurpresa, // Passando se é surpresa
                              aniversarianteNome: _isSurpresa ? _aniversarianteCtrl.text : null, // Passando o nome
                              sugeridoPor: viewModel.meuApelido,
                            ));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(viewModel.isDiretor ? 'Evento adicionado à agenda!' : 'Sugestão enviada para aprovação da Diretoria!'), backgroundColor: Colors.green));
                          }
                        },
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        child: Text(viewModel.isDiretor ? 'SALVAR EVENTO' : 'ENVIAR SUGESTÃO'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}