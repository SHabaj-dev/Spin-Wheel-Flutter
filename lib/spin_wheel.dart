import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with SingleTickerProviderStateMixin {
  List<double> sectors = [100, 20, 0.15, 0.5, 50, 20, 100, 50, 20, 50];
  int randomSectorIndex = -1;
  List<double> sectorRadians = [];
  double angle = 0;
  bool isSpinning = false;
  double earnedValue = 0;
  double totalValue = 0;
  int spins = 0;

  math.Random random = math.Random();

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    generateSectorsRadians();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );

    controller.addListener(() {
      if (controller.isCompleted) {
        setState(() {
          recordStats();
          isSpinning = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void generateSectorsRadians() {
    double sectorRadian = 2 * math.pi / sectors.length;
    for (int i = 0; i < sectors.length; i++) {
      sectorRadians.add((i + 1) * sectorRadian);
    }
  }

  void startSpin() {
    if (!isSpinning) {
      setState(() {
        isSpinning = true;
        randomSectorIndex = random.nextInt(sectors.length);
        angle = 2 * math.pi * 10 +
            (sectorRadians[randomSectorIndex] -
                (2 * math.pi / sectors.length) / 2);
        controller.forward(from: 0);
      });
    }
  }

  void recordStats() {
    earnedValue = sectors[sectors.length - (randomSectorIndex + 1)];
    totalValue += earnedValue;
    spins++;
  }

  Widget _gameStats() {
    return Positioned(
      top: 150,
      left: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spins: $spins',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last Win: $earnedValue',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total: $totalValue',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wood.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            _gameTitle(),
            _gameWheel(),
            _gameActions(),
            _gameStats(),
          ],
        ),
      ),
    );
  }

  Widget _gameTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: CupertinoColors.systemYellow,
            width: 2,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0XFF2D014C),
              Color(0XFF6A0572),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: const Text(
          'Spin Wheel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _gameWheel() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 5),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.9,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage('assets/images/belt.png'),
          ),
        ),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.value * angle,
              child: Container(
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/wheel.png'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _gameActions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0XFF6A0572),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          onPressed: isSpinning ? null : startSpin,
          child: const Text(
            "SPIN!",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
