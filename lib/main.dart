import 'package:flutter/material.dart';
import 'models/game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: GamePage())),
    );
  }
}

// ---------------- TILE ----------------
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Text(letter, style: const TextStyle(fontSize: 24)),
    );
  }
}

// ---------------- GAME PAGE ----------------
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  void handleGuess(String guess) {
    if (guess.length != 5) return;

    setState(() {
      if (_game.isLegalGuess(guess)) {
        _game.guess(guess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5,
        children: [
          for (var guess in _game.guesses) Row(spacing: 5, children: [for (var letter in guess) Tile(letter.char, letter.type)]),
          GuessInput(onSubmitGuess: handleGuess),
        ],
      ),
    );
  }
}

// ---------------- INPUT ----------------
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35))),
                hintText: 'Digite uma palavra',
              ),
              onSubmitted: (value) {
                onSubmitGuess(value);
                _controller.clear();
                _focusNode.requestFocus();
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: () {
            onSubmitGuess(_controller.text.trim());
            _controller.clear();
            _focusNode.requestFocus();
          },
        ),
      ],
    );
  }
}
