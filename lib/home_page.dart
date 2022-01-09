import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int emptyPosition = 0;
  final List<int> environment = <int>[1, 2, 3, 4, 5, 6, 7, 8, 0];

  @override
  void initState() {
    super.initState();

    _restartGame();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('PUZZLE'),
          ),
          body: Column(
            children: <Widget>[
              Expanded(child: _buildBoard()),
              _buildRestartButton(),
            ],
          ),
        ),
      );

  Widget _buildBoard() => Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            if (index == emptyPosition) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '${environment[index]}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onTap: () {
                if (_isMovementValid(index)) {
                  _moveBlock(index);
                }

                _checkWinner();
              },
            );
          },
        ),
      );

  Widget _buildRestartButton() => TextButton(
        child: const Text(
          'Restart',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onPressed: _restartGame,
      );

  void _initialEmptyPosition() {
    for (int i = 0; i < environment.length; i++) {
      if (environment[i] == 0) {
        emptyPosition = i;
        break;
      }
    }
  }

  void _moveBlock(int index) {
    environment[emptyPosition] = environment[index];
    emptyPosition = index;
    environment[index] = 0;

    setState(() {});
  }

  bool _isMovementValid(int index) {
    if (index == emptyPosition) {
      return false;
    }

    if (index == emptyPosition - 3 || index == emptyPosition + 3) {
      return true;
    }

    if (index == emptyPosition - 1 && (emptyPosition % 3) != 0) {
      return true;
    }

    if (index == emptyPosition + 1 && (emptyPosition % 3) != 2) {
      return true;
    }

    return false;
  }

  void _checkWinner() {
    if (isGameFinished()) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('You win!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.pop(context);

                _restartGame();
              },
            ),
          ],
        ),
      );
    }
  }

  void _restartGame() {
    environment.shuffle();
    _initialEmptyPosition();

    setState(() {});
  }

  bool isGameFinished() {
    for (int i = 0; i < environment.length - 1; i++) {
      if (environment[i] != i + 1) {
        return false;
      }
    }

    return true;
  }
}
