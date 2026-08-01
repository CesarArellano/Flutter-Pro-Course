import 'package:flutter/material.dart';

class UiControlsScreen extends StatefulWidget {
  static const String name = 'ui_screen';
  const UiControlsScreen({Key? key}) : super(key: key);

  @override
  State<UiControlsScreen> createState() => _UiControlsScreenState();
}

enum Transportation { car, plane, boat, submarine }
class _UiControlsScreenState extends State<UiControlsScreen> {

  bool isDeveloper = true;
  Transportation selectedTransportation = Transportation.car;
  bool wantsBreakfast = false;
  bool wantsLunch = false;
  bool wantsDinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Controls'),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SwitchListTile(
            value: isDeveloper,
            title: const Text('Developer Mode'),
            subtitle: const Text('Aditional Controls'),
            onChanged: ( value ) => setState(() {
              isDeveloper = !isDeveloper;
            })
          ),
          ExpansionTile(
            title: const Text('Transportation Vehicule'),
            subtitle: Text(selectedTransportation.toString()),
            children: [
              RadioGroup(
                groupValue: selectedTransportation,
                onChanged: ( value ) => setState(() {
                  selectedTransportation = Transportation.car;
                }),
                child: const Column(
                  children: [
                    RadioListTile(
                      value: Transportation.car,
                      title: Text('Car'),
                    ),
                    RadioListTile(
                      value: Transportation.plane,
                      title: Text('Plane'),
                    ),
                    RadioListTile(
                      value: Transportation.submarine,
                      title: Text('Submarine'),
                    ),
                    RadioListTile(
                      value: Transportation.boat,
                      title: Text('Boat'),
                    ),
                  ],
                )
              ),
            ],
          ),

          CheckboxListTile(
            title: const Text('Breakfast?'),
            value: wantsBreakfast,
            onChanged: (value) => setState(() {
                wantsBreakfast = value ?? false;
            })
          ),
          CheckboxListTile(
            title: const Text('Lunch?'),
            value: wantsLunch,
            onChanged: (value) => setState(() {
                wantsLunch = value ?? false;
            })
          ),
          CheckboxListTile(
            title: const Text('Dinner?'),
            value: wantsDinner,
            onChanged: (value) => setState(() {
                wantsDinner = value ?? false;
            })
          ),
        ],
      )
    );
  }
}