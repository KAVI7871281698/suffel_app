import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'next_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Shuffle App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController(text: "0123456789");

  void _updateOutput() {
    String input = _inputController.text;
    if (input.isEmpty) {
      _outputController.text = "0123456789";
      return;
    }

    String lastChar = input[input.length - 1];

    // Prevent repeated numbers
    if (input.indexOf(lastChar) != input.lastIndexOf(lastChar)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠ Repeated number not accepted"),
          duration: Duration(seconds: 1),
        ),
      );

      _inputController.text = input.substring(0, input.length - 1);
      _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length),
      );
      return;
    }

    // Update remaining digits
    String digits = "0123456789";
    for (var char in _inputController.text.split('')) {
      digits = digits.replaceAll(char, '');
    }

    _outputController.text = digits;
  }

  void _handleSubmit() {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter at least one number!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextPage(
          enteredNumbers: _inputController.text,
          remainingNumbers: _outputController.text,
        ),
      ),
    );
  }

  void _handleCancel() {
    _inputController.clear();
    _outputController.text = "0123456789";
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Input cleared!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_updateOutput);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Number Shuffle App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Enter Numbers",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
            ),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: Colors.deepPurple.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        prefixIcon: const Icon(Icons.edit, color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Icon(Icons.arrow_downward_rounded, color: Colors.green, size: 45),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _outputController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        prefixIcon: const Icon(Icons.calculate_outlined, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.check_circle, size: 28),
                  label: const Text("Submit", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
                ElevatedButton.icon(
                  onPressed: _handleCancel,
                  icon: const Icon(Icons.refresh, size: 28),
                  label: const Text("Clear", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
