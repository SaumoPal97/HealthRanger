import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:flutter/material.dart';

class RadialGauge extends StatelessWidget {
  final double value;
  final Color color;
  const RadialGauge({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedRadialGauge(
        builder: (context, _, value) => RadialGaugeLabel(
              style: const TextStyle(
                color: Color(0xFF002E5F),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              value: value,
            ),
        duration: const Duration(seconds: 1),
        value: value,
        curve: Curves.elasticOut,
        radius: 120,
        axis: GaugeAxis(
          min: 0,
          max: 100,
          degrees: 180,
          pointer: null,
          style: const GaugeAxisStyle(
            thickness: 20,
            background: Color(0xFFDFE2EC),
          ),
          progressBar: GaugeProgressBar.rounded(
            color: color,
          ),
        ),
        child: const RadialGaugeLabel(
          style: TextStyle(
            color: Color(0xFF002E5F),
          ),
          value: 67,
        ));
  }
}
