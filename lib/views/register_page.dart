import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/registro_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  final String userRole;

  const RegisterPage({super.key, required this.userRole});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();

  final _emergency1Controller = TextEditingController();
  final _emergency2Controller = TextEditingController();

  String _prefContato = 'WhatsApp';
  String _prefEmergencia1 = 'Ligação';
  String _prefEmergencia2 = 'Ligação';
  final List<String> _opcoesContato = ['WhatsApp', 'Ligação'];

  final _allergiesController = TextEditingController();
  final _mainMotoController = TextEditingController();

  final _sponsorCountController = TextEditingController();
  int _sponsorCount = 0;
  final List<TextEditingController> _sponsorNameControllers = [];

  final _vehicleCountController = TextEditingController();
  final _insuranceCountController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _bloodType;
  String? _vestSize;
  bool _hasInsurance = false;
  bool _agreedToLGPD = false;
  int _vehicleCount = 0;
  int _insuranceCount = 0;
  bool _isResponsavelFinanceiro = false;
  int _dependentesCount = 0;
  final List<String?> _dependentesSelecionados = [];
  final _dependentesCountController = TextEditingController();

  final List<String> _membrosAtivos = ['Esposa', 'Filho 1', 'Filho 2', 'João "Pai"', 'Cachorrão', 'Fumaça', 'Caveira'];
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _vestSizes = ['P', 'M', 'G', 'GG', 'EXG'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFDD835),
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Widget _buildAttachmentCard(BuildContext context, String title, IconData icon, bool isAttached, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isAttached ? Colors.green.withOpacity(0.2) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isAttached ? Colors.green : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isAttached ? Colors.green : Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isAttached ? '$title (Anexado)' : title,
                style: TextStyle(color: isAttached ? Colors.green : Colors.white70, fontWeight: FontWeight.bold),
              ),
            ),
            Icon(isAttached ? Icons.check_circle : Icons.upload_file, color: isAttached ? Colors.green : Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isGuest = widget.userRole == 'Convidado';

    return Scaffold(
      appBar: AppBar(title: Text('CADASTRO: ${widget.userRole.toUpperCase()}')),
      body: Consumer<RegistroViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DADOS DE ACESSO', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(controller: _userController, decoration: const InputDecoration(labelText: 'Usuário', prefixIcon: Icon(Icons.person_outline))),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline)),
                    validator: (val) => val == null || val.isEmpty ? 'Digite uma senha' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirme a Senha', prefixIcon: Icon(Icons.lock)),
                    validator: (val) => val != _passwordController.text ? 'As senhas não coincidem' : null,
                  ),
                  const SizedBox(height: 32),

                  Text('DADOS PESSOAIS', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome Completo', prefixIcon: Icon(Icons.badge))),
                  const SizedBox(height: 12),
                  TextFormField(controller: _nicknameController, decoration: const InputDecoration(labelText: 'Apelido (no MC)', prefixIcon: Icon(Icons.sports_motorsports))),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(labelText: 'Data de Nascimento', prefixIcon: Icon(Icons.calendar_today)),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: 'Seu Telefone', prefixIcon: Icon(Icons.phone)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _prefContato,
                          decoration: const InputDecoration(labelText: 'Preferência'),
                          items: _opcoesContato.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (val) => setState(() => _prefContato = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Text('SAÚDE E EMERGÊNCIA', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _bloodType,
                    decoration: const InputDecoration(labelText: 'Tipo Sanguíneo', prefixIcon: Icon(Icons.bloodtype)),
                    items: _bloodTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (val) => setState(() => _bloodType = val),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(controller: _allergiesController, decoration: const InputDecoration(labelText: 'Alergias ou Condições Médicas?', prefixIcon: Icon(Icons.medical_information))),

                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _emergency1Controller,
                          decoration: const InputDecoration(labelText: 'Emergência 1 (Nome/Tel)*', prefixIcon: Icon(Icons.contact_phone)),
                          validator: (val) => val == null || val.isEmpty ? 'Obrigatório' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _prefEmergencia1,
                          decoration: const InputDecoration(labelText: 'Preferência'),
                          items: _opcoesContato.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (val) => setState(() => _prefEmergencia1 = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _emergency2Controller,
                          decoration: const InputDecoration(labelText: 'Emergência 2 (Opcional)', prefixIcon: Icon(Icons.contact_phone_outlined)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _prefEmergencia2,
                          decoration: const InputDecoration(labelText: 'Preferência'),
                          items: _opcoesContato.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                          onChanged: (val) => setState(() => _prefEmergencia2 = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Text('DADOS DO CLUBE', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _vestSize,
                    decoration: const InputDecoration(labelText: 'Tamanho do Colete/Camisa', prefixIcon: Icon(Icons.checkroom)),
                    items: _vestSizes.map((size) => DropdownMenuItem(value: size, child: Text(size))).toList(),
                    onChanged: (val) => setState(() => _vestSize = val),
                  ),
                  const SizedBox(height: 12),

                  SwitchListTile(
                    title: const Text('Sou responsável financeiro por outros membros', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('As mensalidades deles serão unificadas no seu painel.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: _isResponsavelFinanceiro,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() {
                        _isResponsavelFinanceiro = val;
                        if (!val) {
                          _dependentesCount = 0;
                          _dependentesCountController.clear();
                          _dependentesSelecionados.clear();
                        }
                      });
                    },
                  ),

                  if (_isResponsavelFinanceiro) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dependentesCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantos dependentes você possui?',
                        prefixIcon: Icon(Icons.group_add),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _dependentesCount = int.tryParse(val) ?? 0;
                          if (_dependentesSelecionados.length < _dependentesCount) {
                            _dependentesSelecionados.addAll(List.filled(_dependentesCount - _dependentesSelecionados.length, null));
                          } else if (_dependentesSelecionados.length > _dependentesCount) {
                            _dependentesSelecionados.removeRange(_dependentesCount, _dependentesSelecionados.length);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_dependentesCount, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: DropdownButtonFormField<String>(
                          value: _dependentesSelecionados[index],
                          decoration: InputDecoration(
                            labelText: 'Selecione o Dependente ${index + 1}',
                            prefixIcon: const Icon(Icons.person),
                          ),
                          items: _membrosAtivos.map((membro) => DropdownMenuItem(value: membro, child: Text(membro))).toList(),
                          onChanged: (val) => setState(() => _dependentesSelecionados[index] = val),
                          validator: (val) {
                            if (_isResponsavelFinanceiro && (val == null || val.isEmpty)) {
                              return 'Selecione quem é este dependente';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  TextFormField(
                    controller: _sponsorCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantos padrinhos você possui? (Deixe 0 se nenhum)',
                      prefixIcon: Icon(Icons.handshake),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _sponsorCount = int.tryParse(val) ?? 0;
                        if (_sponsorNameControllers.length < _sponsorCount) {
                          _sponsorNameControllers.addAll(
                              List.generate(_sponsorCount - _sponsorNameControllers.length, (_) => TextEditingController())
                          );
                        } else if (_sponsorNameControllers.length > _sponsorCount) {
                          _sponsorNameControllers.removeRange(_sponsorCount, _sponsorNameControllers.length);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_sponsorCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextFormField(
                        controller: _sponsorNameControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Nome do Padrinho ${index + 1}',
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  Text('VEÍCULOS E DOCUMENTAÇÃO', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),

                  if (isGuest)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Membros de Suporte ou Convidados não possuem obrigatoriedade de anexar CNH ou documentos de motocicleta.',
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    )
                  else ...[
                    _buildAttachmentCard(context, 'Anexar CNH', Icons.drive_eta, viewModel.cnhFile != null, () => viewModel.pickCnh()),
                    const SizedBox(height: 12),
                    TextFormField(controller: _mainMotoController, decoration: const InputDecoration(labelText: 'Moto Principal (Modelo e Placa)', prefixIcon: Icon(Icons.two_wheeler))),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _vehicleCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantos veículos possui? (Ex: 2)', prefixIcon: Icon(Icons.format_list_numbered)),
                      onChanged: (val) {
                        setState(() {
                          _vehicleCount = int.tryParse(val) ?? 0;
                          viewModel.atualizarListas(_vehicleCount, _insuranceCount);
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    ...List.generate(_vehicleCount, (index) {
                      return _buildAttachmentCard(
                          context,
                          'Documento do Veículo ${index + 1}',
                          Icons.description,
                          viewModel.vehicleDocs.length > index && viewModel.vehicleDocs[index] != null,
                              () => viewModel.pickVehicleDoc(index)
                      );
                    }),

                    SwitchListTile(
                      title: const Text('Possui Seguro?', style: TextStyle(fontWeight: FontWeight.bold)),
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: _hasInsurance,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _hasInsurance = val),
                    ),

                    if (_hasInsurance) ...[
                      TextFormField(
                        controller: _insuranceCountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Seguro para quantos veículos?', prefixIcon: Icon(Icons.shield)),
                        onChanged: (val) {
                          setState(() {
                            _insuranceCount = int.tryParse(val) ?? 0;
                            viewModel.atualizarListas(_vehicleCount, _insuranceCount);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(_insuranceCount, (index) {
                        return _buildAttachmentCard(
                            context,
                            'Apólice de Seguro ${index + 1}',
                            Icons.security,
                            viewModel.insuranceDocs.length > index && viewModel.insuranceDocs[index] != null,
                                () => viewModel.pickInsuranceDoc(index)
                        );
                      }),
                    ],

                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        String? erro = await viewModel.pickVehiclePhoto();
                        if (erro != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro), backgroundColor: Colors.red));
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text('Adicionar Foto da Moto (${viewModel.vehiclePhotos.length}/5)'),
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.surface, foregroundColor: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    if (viewModel.vehiclePhotos.isNotEmpty)
                      Text('${viewModel.vehiclePhotos.length} foto(s) anexada(s) com sucesso.', style: const TextStyle(color: Colors.green)),
                  ],
                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreedToLGPD,
                          activeColor: Theme.of(context).colorScheme.primary,
                          checkColor: Colors.black,
                          onChanged: (val) {
                            setState(() {
                              _agreedToLGPD = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Abrindo Política de Privacidade e Termos de Uso...')),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Estou ciente e concordo que meus dados pessoais e documentos anexados serão armazenados e tratados de forma segura, exclusivamente para gestão interna do clube, em conformidade com a ',
                              style: const TextStyle(fontSize: 14, color: Colors.white70),
                              children: [
                                TextSpan(
                                  text: 'Lei Geral de Proteção de Dados (LGPD)',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        if (!_agreedToLGPD) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Você precisa aceitar os termos da LGPD para continuar.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        // Chamada ao ViewModel para submissão real!
                        bool sucesso = await viewModel.solicitarCadastro({
                          'usuario': _userController.text,
                          'cargo': widget.userRole,
                          // Aqui no futuro mapearemos todos os dados textuais para o envio
                        });

                        if (sucesso && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cadastro enviado para aprovação da Diretoria!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              backgroundColor: Color(0xFFFDD835),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('SOLICITAR CADASTRO'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}