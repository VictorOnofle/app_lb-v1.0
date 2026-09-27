import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Cobranca.dart'; // Mudei para cobranca_model.dart como criado nos passos
import '../viewmodels/tesouraria_viewmodel.dart';

class TesourariaTab extends StatelessWidget {
  const TesourariaTab({super.key});

  final List<String> _nomeMeses = const [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  void _processarPagamento(BuildContext context, TesourariaViewModel viewModel) async {
    final formaPagamento = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              const Text('Finalizar Pagamento', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Total: R\$ ${viewModel.totalCarrinho.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(fontSize: 24, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ListTile(
                onTap: () => Navigator.pop(context, 'PIX'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
                leading: const Icon(Icons.pix, color: Colors.tealAccent),
                title: const Text('PIX', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Baixa imediata'),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              ),
              const SizedBox(height: 12),
              ListTile(
                onTap: () => Navigator.pop(context, 'Crédito'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
                leading: const Icon(Icons.credit_card, color: Colors.orangeAccent),
                title: const Text('Cartão de Crédito', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Requer confirmação'),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              ),
              const SizedBox(height: 12),
              ListTile(
                onTap: () => Navigator.pop(context, 'Dinheiro'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
                leading: const Icon(Icons.money, color: Colors.green),
                title: const Text('Dinheiro em Espécie', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Entregar à diretoria'),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );

    if (formaPagamento != null && context.mounted) {
      viewModel.processarPagamento(formaPagamento);
      String msg = formaPagamento == 'PIX'
          ? 'Pagamento confirmado! O Caixa agradece.'
          : 'Pagamento registrado. Aguardando confirmação da Diretoria.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: formaPagamento == 'PIX' ? Colors.green : Colors.orange),
      );
    }
  }

  void _justificarAtraso(BuildContext context, Cobranca cobranca) async {
    final justificativaCtrl = TextEditingController(text: cobranca.justificativa);

    final textoJustificativa = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Justificar Pendência', style: TextStyle(color: Colors.amber)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Referente a: ${cobranca.titulo}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              TextField(
                controller: justificativaCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Explique para a diretoria o motivo...', hintStyle: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.white54))),
            ElevatedButton(onPressed: () => Navigator.pop(context, justificativaCtrl.text), child: const Text('ENVIAR'))
          ],
        );
      },
    );

    if (textoJustificativa != null && context.mounted) {
      cobranca.justificativa = textoJustificativa;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Justificativa enviada à Diretoria.'), backgroundColor: Colors.amber, behavior: SnackBarBehavior.floating),
      );
    }
  }

  // ==========================================
  // CONSTRUTORES DE LISTA
  // ==========================================

  Widget _buildListaCobrancasPessoais(BuildContext context, TesourariaViewModel viewModel, List<Cobranca> lista) {
    if (lista.isEmpty) return const Center(child: Text('Nenhum registro encontrado.', style: TextStyle(color: Colors.white54)));

    return ListView.separated(
      itemCount: lista.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white10),
      itemBuilder: (context, index) {
        final item = lista[index];
        final isPago = item.status == 'Pago';
        final isSelecionado = viewModel.carrinho.contains(item.id);
        final isPendente = item.status == 'Pendente';

        return ListTile(
          onTap: (!isPago && !isPendente) ? () => viewModel.toggleNoCarrinho(item.id) : null,
          selected: isSelecionado,
          selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          leading: (!isPago && !isPendente)
              ? Checkbox(
            value: isSelecionado, activeColor: Theme.of(context).colorScheme.primary, checkColor: Colors.black, shape: const CircleBorder(),
            onChanged: (bool? value) => viewModel.toggleNoCarrinho(item.id),
          )
              : CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(isPago ? Icons.check_circle : Icons.access_time, color: isPago ? Colors.green : Colors.orange),
          ),
          title: Text(item.titulo, style: TextStyle(color: isPago ? Colors.white54 : Colors.white, decoration: isPago ? TextDecoration.lineThrough : null)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.subtitulo} • ${item.status}', style: TextStyle(color: isPago ? Colors.green : (isPendente ? Colors.orange : Colors.redAccent))),
              if (item.justificativa != null) const Text('Justificado: Aguardando Diretoria', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('R\$ ${item.valor.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontWeight: FontWeight.bold, color: isPago ? Colors.white54 : Colors.white, fontSize: 16)),
              if (!isPago && !isSelecionado && !isPendente)
                IconButton(icon: const Icon(Icons.info_outline, color: Colors.white54), onPressed: () => _justificarAtraso(context, item)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListaGestaoDiretor(BuildContext context, TesourariaViewModel viewModel, List<Cobranca> lista, {bool isPendenteTab = false}) {
    if (lista.isEmpty) return const Center(child: Text('Nenhuma cobrança neste status para este mês.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)));

    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final item = lista[index];
        return Card(
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.membroAlvo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('R\$ ${item.valor.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${item.titulo} • ${item.subtitulo}', style: const TextStyle(color: Colors.white54)),

                if (item.justificativa != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [const Icon(Icons.message, size: 16, color: Colors.amber), const SizedBox(width: 8), Expanded(child: Text('Justificativa: "${item.justificativa}"', style: const TextStyle(color: Colors.amber, fontStyle: FontStyle.italic)))]),
                  )
                ],

                if (item.metodoPendente != null) ...[
                  const SizedBox(height: 8),
                  Text('Pagamento informado via: ${item.metodoPendente}', style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                ],

                if (isPendenteTab) ...[
                  const Divider(color: Colors.white10, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento Recusado.'), backgroundColor: Colors.redAccent));
                        },
                        icon: const Icon(Icons.close), label: const Text('RECUSAR'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento Confirmado!'), backgroundColor: Colors.green));
                        },
                        icon: const Icon(Icons.check), label: const Text('CONFIRMAR'),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // CONSTRUTORES DE VISÃO (MEMBRO / DIRETOR)
  // ==========================================

  Widget _buildVisaoMembro(BuildContext context, TesourariaViewModel viewModel, bool isNomade) {
    List<Cobranca> mensalidades = isNomade ? [] : viewModel.minhasCobrancas.where((c) => c.tipo == 'Mensalidade').toList();
    List<Cobranca> rateios = viewModel.minhasCobrancas.where((c) => c.tipo == 'Rateio').toList();
    List<Cobranca> doacoes = viewModel.minhasCobrancas.where((c) => c.tipo == 'Doacao').toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Colors.amber, labelColor: Colors.amber, unselectedLabelColor: Colors.white54,
            tabs: [Tab(text: 'Mensalidades'), Tab(text: 'Rateios e Coletes')],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children: [
                isNomade ? _buildCaixinhaNomade(context, viewModel, doacoes) : _buildListaCobrancasPessoais(context, viewModel, mensalidades),
                _buildListaCobrancasPessoais(context, viewModel, rateios),
              ],
            ),
          ),
          Visibility(
              visible: viewModel.carrinho.isNotEmpty,
              maintainState: true,
              child: _buildBarraCarrinho(context, viewModel)
          ),
        ],
      ),
    );
  }

  Widget _buildVisaoGestaoDiretoria(BuildContext context, TesourariaViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Gestão Financeira', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            TextButton.icon(
              onPressed: () async {
                await viewModel.exportarParaExcel();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Planilha exportada com sucesso!'), backgroundColor: Colors.green),
                  );
                }
              },
              icon: viewModel.isLoadingExcel ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.table_view, color: Colors.greenAccent),
              label: const Text('Exportar', style: TextStyle(color: Colors.greenAccent)),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const Icon(Icons.filter_alt_outlined, color: Colors.white54, size: 20),
              const SizedBox(width: 8),
              const Text('Mês de Ref.:', style: TextStyle(color: Colors.white54)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: viewModel.mesFiltroGestao,
                      dropdownColor: Colors.grey[900],
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
                      items: List.generate(12, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text(_nomeMeses[index], style: const TextStyle(color: Colors.white)),
                        );
                      }),
                      onChanged: (novoMes) {
                        if (novoMes != null) viewModel.alterarMesFiltro(novoMes);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                      child: const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab, indicatorColor: Colors.amber, labelColor: Colors.amber, unselectedLabelColor: Colors.white54,
                        tabs: [Tab(text: 'MENSALIDADES'), Tab(text: 'RATEIOS')],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildSubTabsGestao(context, viewModel, 'Mensalidade'),
                          _buildSubTabsGestao(context, viewModel, 'Rateio'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabsGestao(BuildContext context, TesourariaViewModel viewModel, String tipo) {
    List<Cobranca> cobrancas = viewModel.cobrancasGerais.where((c) =>
    c.tipo == tipo && c.membroAlvo != 'Meu Perfil' && c.mes == viewModel.mesFiltroGestao
    ).toList();

    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true, indicatorColor: Colors.white, labelColor: Colors.white, unselectedLabelColor: Colors.white30,
                tabs: [Tab(text: 'PAGO'), Tab(text: 'NÃO PAGO'), Tab(text: 'PENDENTES')],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildListaGestaoDiretor(context, viewModel, cobrancas.where((c) => c.status == 'Pago').toList()),
                    _buildListaGestaoDiretor(context, viewModel, cobrancas.where((c) => c.status == 'Não Pago').toList()),
                    _buildListaGestaoDiretor(context, viewModel, cobrancas.where((c) => c.status == 'Pendente').toList(), isPendenteTab: true),
                  ],
                ),
              )
            ],
          ),
        ),
        // BOTÃO DE NOVO RATEIO AQUI!
        if (tipo == 'Rateio')
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => _mostrarCriadorRateio(context, viewModel),
              backgroundColor: Colors.amber,
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
      ],
    );
  }

  // ==========================================
  // CAIXAS E BARRAS AUXILIARES
  // ==========================================

  Widget _buildVisaoConvidado() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_motorsports, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 24),
          const Text('Bem-vindo, Convidado!', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text('Como convidado, você é isento das mensalidades do Clube. Aproveite o rolê!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildCaixinhaNomade(BuildContext context, TesourariaViewModel viewModel, List<Cobranca> doacoes) {
    final doacaoCtrl = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.primary)),
            child: Column(
              children: [
                const Icon(Icons.volunteer_activism, size: 48, color: Color(0xFFFDD835)),
                const SizedBox(height: 16),
                const Text('Como Nômade, você não tem mensalidades. Mas sua doação fortalece o Clube.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 16),
                TextField(
                  controller: doacaoCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Valor (R\$)', prefixIcon: Icon(Icons.attach_money), labelStyle: TextStyle(color: Colors.white54)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    doacaoCtrl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Doação adicionada ao carrinho!')));
                  },
                  child: const Text('ADICIONAR AO CARRINHO'),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Histórico de Contribuições:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54)),
          const SizedBox(height: 8),
          Expanded(child: _buildListaCobrancasPessoais(context, viewModel, doacoes)),
        ],
      ),
    );
  }

  Widget _buildBarraCarrinho(BuildContext context, TesourariaViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 10, offset: const Offset(0, -5))]),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${viewModel.carrinho.length} item(s)', style: const TextStyle(color: Colors.white54)),
                Text('R\$ ${viewModel.totalCarrinho.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: viewModel.limparCarrinho),
                ElevatedButton.icon(onPressed: () => _processarPagamento(context, viewModel), icon: const Icon(Icons.payment), label: const Text('PAGAR')),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ==========================================
  // LÓGICA E MODAL DO RATEIO
  // ==========================================

  void _mostrarCriadorRateio(BuildContext context, TesourariaViewModel viewModel) {
    List<MembroClube> membrosElegiveis = viewModel.todosOsMembros.where((m) => m.cargo != 'Convidado').toList();
    List<MembroClube> membrosSelecionados = [];

    final nomeRateioCtrl = TextEditingController();
    final valorCtrl = TextEditingController();
    double parcelas = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isTodosSelecionados = membrosSelecionados.length == membrosElegiveis.length;

            return DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                expand: false,
                builder: (context, scrollController) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(10)))),
                        const SizedBox(height: 16),
                        const Text('Novo Rateio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                        const SizedBox(height: 16),
                        TextField(controller: nomeRateioCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Motivo (Ex: Festa da Sede)', labelStyle: TextStyle(color: Colors.white54))),
                        const SizedBox(height: 12),
                        TextField(controller: valorCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Valor Unitário por Membro (R\$)', labelStyle: TextStyle(color: Colors.white54))),
                        const SizedBox(height: 16),
                        Text('Parcelamento: ${parcelas.toInt()}x', style: const TextStyle(color: Colors.white70)),
                        Slider(
                          value: parcelas,
                          min: 1, max: 12, divisions: 11,
                          activeColor: Theme.of(context).colorScheme.primary,
                          label: parcelas.toInt().toString(),
                          onChanged: (val) => setModalState(() => parcelas = val),
                        ),
                        const Divider(color: Colors.white24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Selecionar Memembros', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () {
                                setModalState(() {
                                  if (isTodosSelecionados) {
                                    membrosSelecionados.clear();
                                  } else {
                                    membrosSelecionados = List.from(membrosElegiveis);
                                  }
                                });
                              },
                              child: Text(isTodosSelecionados ? 'Desmarcar Todos' : 'Selecionar Todos', style: const TextStyle(color: Colors.amber)),
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: membrosElegiveis.length,
                            itemBuilder: (context, index) {
                              final membro = membrosElegiveis[index];
                              final isSelecionado = membrosSelecionados.contains(membro);
                              return CheckboxListTile(
                                title: Text(membro.nome, style: const TextStyle(color: Colors.white)),
                                subtitle: Text(membro.cargo, style: const TextStyle(color: Colors.white54)),
                                value: isSelecionado,
                                activeColor: Colors.amber,
                                checkColor: Colors.black,
                                onChanged: (bool? val) {
                                  setModalState(() {
                                    if (val == true) {
                                      membrosSelecionados.add(membro);
                                    } else {
                                      membrosSelecionados.remove(membro);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: membrosSelecionados.isEmpty ? null : () {
                            double valorBase = double.tryParse(valorCtrl.text.replaceAll(',', '.')) ?? 0;
                            if(valorBase <= 0 || nomeRateioCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha nome e valor corretamente.')));
                              return;
                            }

                            double valorTotal = valorBase * membrosSelecionados.length;
                            double valorParcela = valorBase / parcelas;

                            Navigator.pop(context); // Fecha o sheet
                            _mostrarConfirmacaoRateio(
                                context,
                                viewModel,
                                nomeRateioCtrl.text,
                                valorTotal,
                                valorParcela,
                                parcelas.toInt(),
                                membrosSelecionados
                            );
                          },
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                          child: const Text('REVISAR E GERAR'),
                        ),
                      ],
                    ),
                  );
                }
            );
          },
        );
      },
    );
  }

  void _mostrarConfirmacaoRateio(BuildContext context, TesourariaViewModel viewModel, String nome, double valorTotal, double valorParcela, int qtdParcelas, List<MembroClube> membros) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _ConfirmacaoRateioDialog(
          nome: nome,
          valorTotal: valorTotal,
          valorParcela: valorParcela,
          qtdParcelas: qtdParcelas,
          membros: membros,
          onConfirm: () {
            viewModel.gerarCobrancasRateio(nome, valorParcela, qtdParcelas, membros);
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rateio gerado com sucesso!'), backgroundColor: Colors.green));
          },
        );
      },
    );
  }

  // ==========================================
  // CONSTRUÇÃO PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Consumer<TesourariaViewModel>(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Dropdown para testes de perfil (Simula o tipo de usuário logado)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[800]!)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: viewModel.perfilTeste,
                      dropdownColor: Colors.grey[900],
                      isExpanded: true,
                      icon: const Icon(Icons.swap_vert, color: Color(0xFFFDD835)),
                      items: ['Membro', 'Nômade', 'Convidado', 'Diretor'].map((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text('Testar visão como: $value', style: const TextStyle(color: Colors.white)));
                      }).toList(),
                      onChanged: (novoPerfil) {
                        if (novoPerfil != null) viewModel.alterarPerfilTeste(novoPerfil);
                      },
                    ),
                  ),
                ),

                // Toggle "Minha Conta / Gestão" exclusivo para Diretor
                if (viewModel.perfilTeste == 'Diretor')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('Gestão do Clube'), icon: Icon(Icons.admin_panel_settings)),
                        ButtonSegment(value: false, label: Text('Minha Conta'), icon: Icon(Icons.person)),
                      ],
                      selected: {viewModel.diretorModoGestao},
                      onSelectionChanged: (Set<bool> newSelection) {
                        viewModel.alternarModoGestao(newSelection.first);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) return Colors.amber;
                          return Colors.grey[900]!;
                        }),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) return Colors.black;
                          return Colors.white54;
                        }),
                      ),
                    ),
                  ),

                // RENDERIZAÇÃO DO CONTEÚDO BASEADO NO PERFIL
                Expanded(
                  child: viewModel.perfilTeste == 'Convidado'
                      ? _buildVisaoConvidado()
                      : (viewModel.perfilTeste == 'Diretor' && viewModel.diretorModoGestao)
                      ? _buildVisaoGestaoDiretoria(context, viewModel)
                      : _buildVisaoMembro(context, viewModel, viewModel.perfilTeste == 'Nômade'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// CLASSE ISOLADA DO DIALOG (EXTERNA)
// ==========================================

class _ConfirmacaoRateioDialog extends StatefulWidget {
  final String nome;
  final double valorTotal;
  final double valorParcela;
  final int qtdParcelas;
  final List<MembroClube> membros;
  final VoidCallback onConfirm;

  const _ConfirmacaoRateioDialog({
    required this.nome,
    required this.valorTotal,
    required this.valorParcela,
    required this.qtdParcelas,
    required this.membros,
    required this.onConfirm,
  });

  @override
  State<_ConfirmacaoRateioDialog> createState() => _ConfirmacaoRateioDialogState();
}

class _ConfirmacaoRateioDialogState extends State<_ConfirmacaoRateioDialog> {
  int _segundosRestantes = 3;
  bool _botaoLiberado = false;

  @override
  void initState() {
    super.initState();
    _iniciarContagem();
  }

  void _iniciarContagem() async {
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _segundosRestantes = i - 1;
        });
      }
    }
    if (mounted) {
      setState(() {
        _botaoLiberado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text('Confirmar Rateio', style: TextStyle(color: Colors.amber)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Atenção!', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Você está prestes a gerar o rateio "${widget.nome}".', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            Text('• ${widget.membros.length} membro(s) selecionado(s)', style: const TextStyle(color: Colors.white70)),
            Text('• ${widget.qtdParcelas} parcela(s) de R\$ ${widget.valorParcela.toStringAsFixed(2).replaceAll('.', ',')} para cada', style: const TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white24, height: 24),
            Text('Total Arrecadado Estimado: R\$ ${widget.valorTotal.toStringAsFixed(2).replaceAll('.', ',')}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: _botaoLiberado ? widget.onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            disabledBackgroundColor: Colors.grey[700],
          ),
          child: Text(
            _botaoLiberado ? 'CONFIRMAR' : 'AGUARDE... ($_segundosRestantes)',
            style: TextStyle(color: _botaoLiberado ? Colors.black : Colors.white54),
          ),
        ),
      ],
    );
  }
}