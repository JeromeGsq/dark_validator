import 'package:dark_validator/services/algo.dart';
import 'package:dark_validator/services/feeder.dart';
import 'package:dark_validator/services/time.dart';
import 'package:dark_validator/widgets/arrow_value.dart';
import 'package:dark_validator/widgets/chart.dart';
import 'package:dark_validator/widgets/chart_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

final paths = [
  'assets/raw/20240613_231150_DDT.edf',
];

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final feeder = feederEdfSignalProvider(edfFilePath: paths[0], start: 10000);
  final algos = <String, AlgoSignalProvider>{
    'aboveZero': algoSignalProvider(id: '0'),
    'derivative': algoSignalProvider(id: '1', bufferSize: 10),
  };

  @override
  void initState() {
    super.initState();

    _update();
  }

  Future<void> _update() async {
    await Future.delayed(const Duration(milliseconds: 40));

    // 0 == 100000000000ms
    // 1  == 40ms
    // 2 == 20ms
    // 3 == 10ms

    while (true) {
      final timeValue = ref.read(timeProvider);
      final delay = switch (timeValue) {
        0 => 0, // Practically infinite
        1 => 40000,
        2 => 20000,
        3 => 10000,
        4 => 5000,
        5 => 2000,
        6 => 1000,
        7 => 500,
        8 => 250,
        9 => 125,
        10 => 62,
        _ => 40000,
      };

      if (delay == 0) {
        await Future.delayed(const Duration(milliseconds: 16));
        continue;
      }

      await Future.delayed(Duration(microseconds: delay));
      await ref.read(feeder.notifier).update();

      await ref.read(algos['aboveZero']!.notifier).update(
            feeder: feeder,
            compute: (buffer) {
              // Check if most of the buffer is above 0
              final pointsAboveZero = (buffer.lastOrNull?.dy ?? 0) > 0;
              return pointsAboveZero ? 1 : 0;
            },
          );

      await ref.read(algos['derivative']!.notifier).update(
            feeder: feeder,
            compute: (buffer) {
              if (buffer.length < 2) {
                return 0;
              }
              final current = buffer.last.dy;
              final previous = buffer[buffer.length - 2].dy;
              return current - previous;
            },
          );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final breathSignal = ref.watch(feeder);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Breathing
            SizedBox(
              height: 200,
              child: Consumer(
                builder: (context, ref, _) {
                  return ChartStream(
                    label: 'Input',
                    chartData: ChartData(data: breathSignal),
                  );
                },
              ),
            ),
            Container(height: 1, color: Colors.grey),

            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    for (final algo in algos.entries) ...[
                      const Gap(16),
                      SizedBox(
                        height: 300,
                        child: Consumer(
                          builder: (context, ref, _) {
                            final algoSignal = ref.watch(algo.value);

                            return ChartStream(
                              label: algo.key,
                              chartData: ChartData(data: algoSignal),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 1024)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ArrowValue(
            label: 'Speed',
            value: '${ref.watch(timeProvider)}',
            upper: () {
              ref.read(timeProvider.notifier).update(1);
            },
            lower: () {
              ref.read(timeProvider.notifier).update(-1);
            },
          ),
          const SizedBox(width: 16),
          ArrowValue(
            label: 'Samples',
            value: '${ref.watch(chartStreamZoomProvider)}',
            upper: () => ref.read(chartStreamZoomProvider.notifier).zoomIn(),
            lower: () => ref.read(chartStreamZoomProvider.notifier).zoomOut(),
          ),
          const SizedBox(width: 16),
          ArrowValue(
            label: 'Time Padding',
            value: '${ref.watch(chartStreamTimePaddingProvider)}',
            upper: () => ref.read(chartStreamTimePaddingProvider.notifier).zoomOut(),
            lower: () => ref.read(chartStreamTimePaddingProvider.notifier).zoomIn(),
          ),
        ],
      ),
    );
  }
}
