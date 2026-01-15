import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ), // Set your desired bottom padding
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            enabled: true,
            touchCallback: (event, response) {
              if (!mounted) return;
              if (!event.isInterestedForInteractions ||
                  response == null ||
                  response.touchedSection == null) {
                setState(() => _touchedIndex = -1);
                return;
              }
              setState(
                () => _touchedIndex =
                    response.touchedSection!.touchedSectionIndex,
              );
            },
          ),
          startDegreeOffset: -90,
          sectionsSpace: 2,
          centerSpaceRadius: 46,
          sections: _sections(textTheme),
        ),
      ),
    );
  }

  List<PieChartSectionData> _sections(TextTheme textTheme) {
    final data = <({double value, Color color, String title})>[
      (value: 40, color: AppColors.primary, title: 'Users'),
      (value: 30, color: Colors.green, title: 'Revenue'),
      (value: 30, color: Colors.orange, title: 'Orders'),
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == _touchedIndex;
      final radius = isTouched ? 62.0 : 54.0;
      final fontSize = isTouched ? 14.0 : 12.0;

      return PieChartSectionData(
        value: data[i].value,
        color: data[i].color,
        radius: radius,
        title: '${data[i].value.toInt()}%',
        titleStyle: (textTheme.bodySmall ?? const TextStyle()).copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black38, blurRadius: 4)],
        ),
        badgeWidget: isTouched
            ? _Badge(label: data[i].title, color: data[i].color)
            : null,
        badgePositionPercentageOffset: 1.35,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
