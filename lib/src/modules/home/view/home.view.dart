import 'package:ewu_map/src/constants/constants.dart';
import 'package:ewu_map/src/modules/home/model/ewu.model.dart';
import 'package:ewu_map/src/utils/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/custom.routes.dart';
import '../../floor.design/view/floor.design.dart';
import '../../setting/view/setting.view.dart';
import '../../wifi.hunter/view/wifi.hunter.dart';
import '../provider/home.provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Body(),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async => await fadePush(context, const SettingView()),
        child: const Icon(Icons.settings),
      ),
    );
  }
}

class Body extends ConsumerWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: mainSpaceAround,
          children: [
            const TableDescription(),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 1),
                    child: const Text('1st Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 2),
                    child: const Text('2nd Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 3),
                    child: const Text('3rd Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 4),
                    child: const Text('4th Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 5),
                    child: const Text('5th Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 6),
                    child: const Text('6th Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 7),
                    child: const Text('7th Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 8),
                    child: const Text('8th Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 9),
                    child: const Text('9th Floor'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await goToBaseFloorDesign(context, ref, 10),
                    child: const Text('Department Corridor Live Trace'),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async =>
                        await preCheckAndGoWifiHunterPage(context)
                            .then((res) async {
                      if (res) {
                        await fadePush(context, const WifiHunterView());
                      }
                    }),
                    child: const Text('Wifi Hunter Check'),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> preCheckAndGoWifiHunterPage(BuildContext context) async {
  final snack = ScaffoldMessenger.of(context);
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    final currStatus = await Permission.location.status;
    if (currStatus == PermissionStatus.permanentlyDenied ||
        currStatus == PermissionStatus.denied) {
      final status = await Permission.location.request();
      if (status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.denied) {
        snack.showSnackBar(
          const SnackBar(
            content: Text('Location permission is required*'),
            duration: Duration(seconds: 1),
          ),
        );
        return false;
      } else if (status == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  } else {
    snack.showSnackBar(
      const SnackBar(
        content: Text('Only available on mobile devices.'),
        duration: Duration(seconds: 1),
      ),
    );
    return false;
  }
}

Future<void> goToBaseDesign(BuildContext context, EwuMap data, int f) async {
  if (data.floors.any((e) => e.floor == f)) {
    await fadePush(context,
        FloorDesign(floor: data.floors.firstWhere((e) => e.floor == f)));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No data for ${f}th floor'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

Future<void> goToBaseFloorDesign(
    BuildContext context, WidgetRef ref, int f) async {
  final nav = Navigator.of(context);
  final path = 'assets/files/floor_$f.json';
  final sts = (await rootBundle.loadString(path)).isNotEmpty;
  if (sts) {
    final floor = await ref.watch(loadFloorProvider(path).future);
    await nav.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FloorDesign(floor: floor),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
      ),
    );
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No data for ${f}th floor'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class TableDescription extends StatelessWidget {
  const TableDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FixedColumnWidth(160),
          1: FixedColumnWidth(300),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
            ), // Header row background color
            children: const [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Department',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Description',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'CSE',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '6th floor (Lift-5) - 632 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'EEE',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '5th floor (Lift-4) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'ECE',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '4th floor (Lift-3) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'GEB',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '8th floor (Lift-7) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'PHARMA',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '7th & 8th floor (Lift-6 & 7) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'CIVIL',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '7th floor (Lift-6) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'MPS',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '3rd floor (Lift-2) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'ENG',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '2nd floor (Lift-1) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'LAW',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '8th floor (Lift-7) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'SOCIAL RELATIONS',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '9th floor (Lift-8) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'INFORMATION STUDIES',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      // '0th floor (Lift-0) - 000 No Room',
                      '-',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'SOCIOLGY',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '7th floor (Lift-6) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'BBA',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '4th & 5th floor (lift-3 & 4) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'MBA & EMBA',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Ground floor (Lift-0) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'ECO',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      '3rd floor (Lift-2) - 000 No Room',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
