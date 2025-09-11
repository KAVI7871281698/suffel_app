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
  late List<String> boxNumbers;

  @override
  void initState() {
    super.initState();
    boxNumbers = _generateBoxNumbers();
  }

  // 🔹 Function to create the 6 box values row-wise
  List<String> _generateBoxNumbers() {
    List<String> boxValues = [];

    String fullString = widget.enteredNumbers + widget.remainingNumbers;
    if (fullString.length < 10) {
      fullString = fullString.padRight(10, '0');
    }

    // Row 1 → 12, 09, 34
    if (widget.enteredNumbers.length >= 2) {
      boxValues.add(widget.enteredNumbers.substring(0, 2));
    } else if (widget.enteredNumbers.isNotEmpty) {
      boxValues.add("${widget.enteredNumbers[0]}0");
    } else {
      boxValues.add("00");
    }

    if (widget.enteredNumbers.length >= 4) {
      boxValues.add(widget.enteredNumbers.substring(2, 4));
    } else if (widget.enteredNumbers.length == 3) {
      boxValues.add("${widget.enteredNumbers[2]}0");
    } else {
      boxValues.add("00");
    }

    if (widget.remainingNumbers.length >= 2) {
      boxValues.add(widget.remainingNumbers.substring(0, 2));
    } else {
      boxValues.add("00");
    }

    // Row 2 → 56, 78, repeat 1st box (12)
    if (widget.remainingNumbers.length >= 4) {
      boxValues.add(widget.remainingNumbers.substring(2, 4));
    } else {
      boxValues.add("00");
    }

    if (widget.remainingNumbers.length >= 6) {
      boxValues.add(widget.remainingNumbers.substring(4, 6));
    } else {
      boxValues.add("00");
    }

    // Repeat 1st box
    boxValues.add(boxValues[0]);

    return boxValues;
  }

  // 🔹 Generate right side column logic
  List<String> _generateRightColumn(String top, String bottom) {
    return [
      "$top${bottom[0]}",
      "${bottom[0]}$top",
      "$top${bottom[1]}",
      "${bottom[1]}$top",
      "$bottom${top[0]}",
      "${top[0]}$bottom",
      "$bottom${top[1]}",
      "${top[1]}$bottom",
      "$top${bottom[0]}",
      "${bottom[0]}$top",
    ];
  }

  // 🔹 Generate full right side grid values
  List<String> _getRightSideValues() {
    String col1Top = boxNumbers[0];
    String col1Bottom = boxNumbers[3];
    String col2Top = boxNumbers[1];
    String col2Bottom = boxNumbers[4];
    String col3Top = boxNumbers[2];
    String col3Bottom = boxNumbers[5];

    List<String> col1 = _generateRightColumn(col1Top, col1Bottom);
    List<String> col2 = _generateRightColumn(col2Top, col2Bottom);
    List<String> col3 = _generateRightColumn(col3Top, col3Bottom);

    List<String> rightSideValues = [];
    for (int i = 0; i < 10; i++) {
      rightSideValues.add(col1[i]);
      rightSideValues.add(col2[i]);
      rightSideValues.add(col3[i]);
    }
    return rightSideValues;
  }

  // 🔹 Shuffle logic
  void _shuffle() {
    setState(() {
      boxNumbers = [
        boxNumbers[1],
        boxNumbers[2],
        boxNumbers[3],
        boxNumbers[4],
        boxNumbers[0],
        boxNumbers[1],
      ];
    });
  }

  // 🔹 Shuffle back (reverse shift)
  void _shuffleBack() {
    setState(() {
      boxNumbers = [
        boxNumbers[4],
        boxNumbers[0],
        boxNumbers[1],
        boxNumbers[2],
        boxNumbers[3],
        boxNumbers[4],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> rightSideValues = _getRightSideValues();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Next Page",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // LEFT SIDE (3 cols × 2 rows row-wise)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: boxNumbers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.deepPurple, width: 1.2),
                          ),
                          child: Center(
                            child: Text(
                              boxNumbers[index],
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

                // RIGHT SIDE (3 cols × 10 rows)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: rightSideValues.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade300, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              rightSideValues[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
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
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Back to Home (Red)
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.red, size: 32),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                // Shuffle Back (Orange)
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.orange, size: 32),
                  onPressed: _shuffleBack,
                ),
                // Shuffle (Green with text)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
