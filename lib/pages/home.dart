import 'package:dark_validator/services/feeder.dart';
import 'package:dark_validator/services/time.dart';
import 'package:dark_validator/widgets/chart.dart';
import 'package:dark_validator/widgets/chart_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paths = [
  'assets/raw/20240613_215311_DDT.edf',
];

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    _update();
  }

  Future<void> _update() async {
    await Future.delayed(const Duration(milliseconds: 40));
    while (true) {
      if (ref.watch(timeProvider) != 0) {
        await ref.watch(feederEdfSignalProvider(edfFilePath: paths[0]).notifier).update();
        setState(() {});
      }

      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  @override
  Widget build(BuildContext context) {
    final signal = ref.watch(feederEdfSignalProvider(edfFilePath: paths[0]));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Validator'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Breathing
            SizedBox(
              height: 300,
              child: Consumer(
                builder: (context, ref, _) {
                  return ChartStream(
                    chartData: ChartData(data: signal),
                  );
                },
              ),
            ),

            // Algo
            SizedBox(
              height: 300,
              child: Consumer(
                builder: (context, ref, _) {
                  return ChartStream(
                    chartData: ChartData(data: signal),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     // Speed up or down
          //     FloatingActionButton(
          //       heroTag: 'speed_up',
          //       onPressed: () => ref.read(timeProvider.notifier).update(0.1),
          //       child: const Icon(Icons.add, size: 12),
          //     ),
          //     const SizedBox(height: 16),
          //     FloatingActionButton(
          //       heroTag: 'speed_down',
          //       onPressed: () => ref.read(timeProvider.notifier).update(-0.1),
          //       child: const Icon(Icons.remove, size: 12),
          //     ),
          //   ],
          // ),
          // const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'pause',
            onPressed: () {
              ref.read(timeProvider.notifier).toggle();
            },
            child: ref.watch(timeProvider) == 0 ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Zoom: ${ref.watch(chartStreamZoomProvider)}'),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'zoom_in',
                onPressed: () => ref.read(chartStreamZoomProvider.notifier).update(-50),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'zoom_out',
                onPressed: () => ref.read(chartStreamZoomProvider.notifier).update(50),
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
