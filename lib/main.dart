import 'package:flutter/material.dart';

void main() {
  runApp(const TaskMasterApp());
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMaster UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xff120e2b),
        brightness: Brightness.dark,
      ),
      home: const AuthScreen(),
    );
  }
}

// Model para representar o Usuário cadastrado
class UserAccount {
  final String name;
  final String email;
  final String password;

  UserAccount({required this.name, required this.email, required this.password});
}

// Model para representar a Tarefa
class Task {
  String id;
  String title;
  bool isCompleted;
  DateTime date;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.date,
  });
}

// --- 1. TELA DE LOGIN / CADASTRO ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginView = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // "Banco de dados" de usuários em memória (Já inicia com um usuário padrão fictício para facilitar)
  static final List<UserAccount> _registeredUsers = [
    UserAccount(name: "Raphael", email: "raphael@email.com", password: "123"),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuthentication() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    // Validação básica de campos vazios
    if (email.isEmpty || password.isEmpty || (!isLoginView && name.isEmpty)) {
      _showErrorSnackBar("Por favor, preencha todos os campos!");
      return;
    }

    if (isLoginView) {
      // --- LÓGICA DE LOGIN ---
      try {
        // Procura se existe algum usuário com o email e senha digitados
        final user = _registeredUsers.firstWhere(
          (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
        );

        // Se encontrou, navega para o app passando o nome do usuário encontrado
        _navigateToHome(user.name);
      } catch (e) {
        // Se o firstWhere não encontrar ninguém, ele joga um erro capturado aqui
        _showErrorSnackBar("Usuário ou senha incorretos!");
      }
    } else {
      // --- LÓGICA DE CADASTRO ---
      // Verifica se o e-mail já está em uso
      bool emailExists = _registeredUsers.any((u) => u.email.toLowerCase() == email.toLowerCase());
      
      if (emailExists) {
        _showErrorSnackBar("Este e-mail já está cadastrado!");
        return;
      }

      // Cria a nova conta e adiciona na nossa lista
      final newAccount = UserAccount(name: name, email: email, password: password);
      _registeredUsers.add(newAccount);

      // Limpa os campos e avisa que deu certo, jogando o usuário de volta para a tela de login
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso! Faça seu login."),
          backgroundColor: Colors.teal,
        ),
      );

      setState(() {
        isLoginView = true;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToHome(String name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(userName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff251545), Color(0xff0d0714)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              color: const Color(0xff1e1233).withValues(alpha: 0.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isLoginView ? 'Bem Vindo!' : 'Criar Conta',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    
                    if (!isLoginView) ...[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.pinkAccent),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.pinkAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outlined, color: Colors.pinkAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _handleAuthentication, // Chama a função de validação ativa
                      child: Text(
                        isLoginView ? 'ENTRAR' : 'REGISTRO',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginView = !isLoginView;
                        });
                      },
                      child: Text(
                        isLoginView ? "Não tem uma conta? Cadastre-se" : "Já possui conta? Faça login",
                        style: const TextStyle(color: Colors.purpleAccent),
                      ),
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
}

// --- 2. TELA DE CALENDÁRIO ---
class CalendarScreen extends StatefulWidget {
  final String userName;

  const CalendarScreen({super.key, required this.userName});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  final List<Task> _globalTasks = [
    Task(id: '1', title: 'Estudar Flutter', isCompleted: false, date: DateTime.now()),
    Task(id: '2', title: 'Academia', isCompleted: true, date: DateTime.now()),
    Task(id: '3', title: 'Comprar café', isCompleted: false, date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Tarefas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff1e1233),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Permite deslogar e voltar para a tela de autenticação se necessário
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bem Vindo, ${widget.userName}!",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Selecione um dia para gerenciar suas tarefas",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Card(
              color: const Color(0xff1e1233),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                minimumSize: const Size(220, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 4,
              ),
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              label: const Text(
                'VER TAREFAS DO DIA',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListScreen(
                      selectedDate: _selectedDate,
                      globalTasks: _globalTasks,
                    ),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. TELA DE LISTA DE TAREFAS ---
class TaskListScreen extends StatefulWidget {
  final DateTime selectedDate;
  final List<Task> globalTasks;

  const TaskListScreen({
    super.key,
    required this.selectedDate,
    required this.globalTasks,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  List<Task> _getProcessedTasks() {
    List<Task> dayTasks = widget.globalTasks.where((task) {
      return task.date.year == widget.selectedDate.year &&
          task.date.month == widget.selectedDate.month &&
          task.date.day == widget.selectedDate.day;
    }).toList();

    List<Task> pending = dayTasks.where((t) => !t.isCompleted).toList();
    List<Task> completed = dayTasks.where((t) => t.isCompleted).toList();

    pending.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    completed.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    return [...pending, ...completed];
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1e1233),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Nova Tarefa', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Digite a descrição da tarefa...',
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              onPressed: () {
                if (_taskController.text.trim().isNotEmpty) {
                  setState(() {
                    widget.globalTasks.add(
                      Task(
                        id: DateTime.now().toString(),
                        title: _taskController.text.trim(),
                        date: widget.selectedDate,
                      ),
                    );
                  });
                  _taskController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Task> processedTasks = _getProcessedTasks();
    String formattedDate = "${widget.selectedDate.day.toString().padLeft(2, '0')}/${widget.selectedDate.month.toString().padLeft(2, '0')}/${widget.selectedDate.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas - $formattedDate'),
        backgroundColor: const Color(0xff1e1233),
        elevation: 0,
      ),
      body: processedTasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhuma tarefa para este dia!', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: processedTasks.length,
              itemBuilder: (context, index) {
                final task = processedTasks[index];
                return Card(
                  color: task.isCompleted ? const Color(0xff161124) : const Color(0xff251b3a),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: task.isCompleted ? Colors.transparent : Colors.purpleAccent.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      activeColor: Colors.tealAccent,
                      checkColor: const Color(0xff120e2b),
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                          task.isCompleted = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          widget.globalTasks.removeWhere((t) => t.id == task.id);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}