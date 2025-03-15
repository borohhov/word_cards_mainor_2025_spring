import 'dart:math';
import 'package:flutter/material.dart';
import 'package:word_cards_mainor_2025_spring/models/word_card_list.dart';

class CardsPage extends StatefulWidget {
  CardsPage({Key? key, required this.cards}) : super(key: key);

  final WordCardList cards;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> with SingleTickerProviderStateMixin {
  int cardIndex = 0;

  late AnimationController _controller;
  bool _showFrontSide = true;
  // true means we’re currently showing the “front” (original word).
  // Once we’ve flipped, we show the “back” (translation).

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getNextCard() {
    setState(() {
      // Choose a new index different from the current one.
      int nextIndex = Random().nextInt(widget.cards.wordCards.length);
      while (cardIndex == nextIndex) {
        nextIndex = Random().nextInt(widget.cards.wordCards.length);
      }
      cardIndex = nextIndex;
    });
  }

  void flipCard() {
    // If we’re currently showing the front, animate to π (half-flip),
    // then mark the back side as visible. If we’re showing the back,
    // animate in reverse to 0 (so the front is visible again).
    if (_showFrontSide) {
      _controller.forward().then((_) {
        // After the forward animation completes, we’re at π, so show the back.
        setState(() {
          _showFrontSide = false;
        });
      });
    } else {
      _controller.reverse().then((_) {
        // After reversing back to 0, show the front side again.
        setState(() {
          _showFrontSide = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Angle goes from 0..π
    // 0   = fully front
    // π/2 = edge-on (invisible)
    // π   = fully back
    final angle = pi * _controller.value;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    // For angles 0..π/2, show front; for angles π/2..π, show back.
                    final isFront = angle <= pi / 2;

                    // Apply 3D rotation around Y-axis
                    final transform = Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // adds a bit of 3D perspective
                      ..rotateY(angle);

                    // If we’re showing the back, we “flip” its child horizontally
                    // so the text isn’t backwards.
                    Widget cardChild;
                    if (isFront) {
                      cardChild = Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            widget.cards.wordCards[cardIndex].word,
                            style: const TextStyle(fontSize: 60),
                          ),
                        ),
                      );
                    } else {
                      cardChild = Transform(
                        transform: Matrix4.identity()..rotateY(pi),
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              widget.cards.wordCards[cardIndex].translatedWord,
                              style: const TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                      );
                    }

                    return Transform(
                      transform: transform,
                      alignment: Alignment.center,
                      child: cardChild,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons side-by-side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: flipCard,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: getNextCard,
                  child: const Icon(Icons.play_arrow_outlined),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
