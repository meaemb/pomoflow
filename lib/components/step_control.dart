import 'package:flutter/material.dart';

class StepControl extends StatefulWidget {
  final void Function(int) addToSession;

  const StepControl({
    required this.addToSession,
    super.key,
  });

  @override
  State<StepControl> createState() => _StepControlState();
}

class _StepControlState extends State<StepControl> {
  int _stepNumber = 1;

  Widget _buildMinusButton() {
    return IconButton(
      icon: const Icon(Icons.remove),
      onPressed: () {
        setState(() {
          if (_stepNumber > 1) {
            _stepNumber--;
          }
        });
      },
      tooltip: 'Decrease quantity',
    );
  }

  Widget _buildStepNumberContainer(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        _stepNumber.toString(),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildPlusButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          _stepNumber++;
        });
      },
      tooltip: 'Increase quantity',
    );
  }

  Widget _buildAddToSessionButton() {
    return FilledButton(
      onPressed: () {
        widget.addToSession(_stepNumber);
      },
      child: const Text('Add to Session'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMinusButton(),
        _buildStepNumberContainer(colorScheme),
        _buildPlusButton(),
        const Spacer(),
        _buildAddToSessionButton(),
      ],
    );
  }
}