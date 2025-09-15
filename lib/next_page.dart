import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {
  final String enteredNumbers;
  final String remainingNumbers;

  const NextPage({
    super.key,
    required this.enteredNumbers,
    required this.remainingNumbers,
  });

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late List<List<String>> leftColumns; // 3 columns with 10 numbers each
  late List<List<String>> originalLeftColumns;

  @override
  void initState() {
    super.initState();
    leftColumns = _generateLeftColumns();
    originalLeftColumns = List.generate(
        3, (i) => List<String>.from(leftColumns[i])); // store original
  }

  // 🔹 Generate left side 3 columns, each with 10 numbers
  List<List<String>> _generateLeftColumns() {
    List<List<String>> cols = [[], [], []];
    String en = widget.enteredNumbers.padRight(6, '0'); // 6 digits min
    String rem = widget.remainingNumbers.padRight(6, '0'); // 6 digits min

    // Define the pattern for each column
    List<String> col1Pattern = [
      en.substring(0, 2),
      en.substring(2, 4),
      rem.substring(0, 2)
    ];
    List<String> col2Pattern = [
      en.substring(4, 6),
      rem.substring(2, 4),
      rem.substring(4, 6)
    ];
    List<String> col3Pattern = [
      en.substring(0, 2),
      rem.substring(0, 2),
      en.substring(2, 4)
    ];

    // Fill 10 numbers per column
    for (int i = 0; i < 10; i++) {
      cols[0].add(col1Pattern[i % 3]);
      cols[1].add(col2Pattern[i % 3]);
      cols[2].add(col3Pattern[i % 3]);
    }

    return cols;
  }

  // 🔹 Generate right side numbers based on left columns
  List<List<String>> _generateRightColumns() {
    List<List<String>> rightCols = [[], [], []];

    for (int col = 0; col < 3; col++) {
      for (int i = 0; i < 10; i++) {
        String num = leftColumns[col][i];
        // Formula: create 3 numbers from 2-digit number: swap digits, double, append '0', etc.
        String n1 = "${num[0]}${num[1]}";
        String n2 = "${num[1]}${num[0]}";
        String n3 = "${num[0]}${num[0]}";
        rightCols[col].addAll([n1, n2, n3]);
      }
    }

    return rightCols;
  }

  void _shuffle() {
    setState(() {
      for (var col in leftColumns) {
        col.shuffle();
      }
    });
  }

  void _shuffleBack() {
    setState(() {
      leftColumns = List.generate(
          3, (i) => List<String>.from(originalLeftColumns[i]));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> rightColumns = _generateRightColumns();

    // Flatten left columns for GridView
    List<String> leftNumbersFlat = [];
    for (int i = 0; i < 10; i++) {
      for (int col = 0; col < 3; col++) {
        leftNumbersFlat.add(leftColumns[col][i]);
      }
    }

    // Flatten right columns
    List<String> rightNumbersFlat = [];
    for (int i = 0; i < 10; i++) {
      for (int col = 0; col < 3; col++) {
        rightNumbersFlat.addAll(rightColumns[col].sublist(i * 3, i * 3 + 3));
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Number Shuffle",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // LEFT GRID
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: leftNumbersFlat.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.deepPurple, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              leftNumbersFlat[index],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // RIGHT GRID
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: rightNumbersFlat.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.deepPurple.shade300, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              rightNumbersFlat[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Bottom Buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 32),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      color: Colors.orangeAccent, size: 32),
                  onPressed: _shuffleBack,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.loop, color: Colors.white),
                  label: const Text(
                    "Shuffle",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: _shuffle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}