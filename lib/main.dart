import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'next_page.dart'; // Import your next page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maths App Calculator',
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
  final TextEditingController _outputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _outputController.text = "0123456789"; // Default digits
    _inputController.addListener(_updateOutput);
  }

  void _updateOutput() {
    String input = _inputController.text;

    if (input.isEmpty) {
      setState(() {
        _outputController.text = "0123456789";
      });
      return;
    }

    String lastChar = input[input.length - 1];

    // Prevent repeated numbers
    if (input.indexOf(lastChar) != input.lastIndexOf(lastChar)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Repeated number not accepted"),
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

    setState(() {
      _outputController.text = digits;
    });
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
    setState(() {
      _inputController.clear();
      _outputController.text = "0123456789";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Input cleared!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Input Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: false, // Align left
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align start
          children: [
            const SizedBox(height: 20),

            Text(
              "Enter Your Numbers",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),

            const SizedBox(height: 30),

            // Input & Output Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              shadowColor: Colors.deepPurple.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Input Box
                    TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Enter unique numbers",
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Plus Icon
                    const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                      size: 50,
                    ),

                    const SizedBox(height: 20),

                    // Output Box
                    TextField(
                      controller: _outputController,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Available numbers (0–9)",
                        prefixIcon: const Icon(Icons.calculate_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Buttons Row (only icons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Submit (Green ✔)
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                    elevation: 4,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 28),
                ),

                // Clear (Navy Blue 🔄)
                ElevatedButton(
                  onPressed: _handleCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                    padding: const EdgeInsets.all(16),
                    shape: const CircleBorder(),
                    elevation: 4,
                  ),
                  child:
                      const Icon(Icons.refresh, color: Colors.white, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
