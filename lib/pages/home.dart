import 'package:dark_validator/services/feeder.dart';
import 'package:dark_validator/widgets/chart.dart';
import 'package:dark_validator/widgets/chart_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paths = [
  'assets/raw/20240613_215311_DDT.edf',
];

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Validator'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Consumer(
              builder: (context, ref, _) {
                final signal = ref.watch(feederEdfSignalProvider(
                  edfFilePath: paths[0],
                  start: 2000,
                ));

                return signal.when(
                  data: (data) => ChartStream(
                    chartData: ChartData(data: data ?? []),
                  ),
                  error: (err, stack) => Text('Error: $err'),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            ),
          ),
          // ListView.builder(
          //   padding: const EdgeInsets.all(16),
          //   itemCount: paths.length,
          //   itemBuilder: (context, index) {
          //     return SizedBox(
          //       height: 300,
          //       child: ChartEdf(
          //         path: paths[index],
          //         start: 0,
          //         end: 1000,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            onPressed: () {
              ref.read(chartStreamZoomProvider.notifier).update(-50);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'zoom_out',
            onPressed: () {
              ref.read(chartStreamZoomProvider.notifier).update(50);
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
