//import 'package:derot/Cities/settings.dart';
// ignore_for_file: unused_field, unused_import

import 'package:derot/Customer/districtHouse.dart';
import 'package:derot/HouseRent/ApartmentIcons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool changed = false;

String prices = '';
String citycont = '';
String housekinds = '';
String neibcont = '';
String streetncont = '';
String roomscont = '';

class EditChoices extends StatefulWidget {
  const EditChoices({super.key});
  @override
  State<EditChoices> createState() {
    return _EditChoiceState();
  }
}

class _EditChoiceState extends State<EditChoices> {
  double _sliderValue = 20000;
  //final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  int _counter = 0;

  Kind _selectedhouse = Kind.partners;

  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _building = TextEditingController();
  String neighbor = '';

  @override
  void dispose() {
    //_titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _increaseCounter() {
    if (_counter < 10) {
      setState(() {
        _counter++;
      });
    }
  }

  void _decreaseCounter() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    }
  }

  void search() {
    prices = _sliderValue.toString();
    citycont = _cityController.text;
    housekinds = _selectedhouse.toString();
    neibcont = _building.text;
    streetncont = _streetController.text;
    roomscont = _counter.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Row(
            children: [
              SizedBox(width: 100),
              Text(
                '30'.tr,
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                ' ${_sliderValue.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),

          SizedBox(height: 1.0),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 20000,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),

          Row(
            children: [
              Container(
                width: 170,
                child: Row(
                  children: [
                    Text('31'.tr),
                    IconButton(
                      onPressed: _increaseCounter,
                      icon: Icon(Icons.add),
                    ),
                    Text('$_counter'),
                    IconButton(
                      onPressed: _decreaseCounter,
                      icon: Icon(Icons.minimize_rounded),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
          //const SizedBox(height: 16),
          Row(
            children: [
              // Text('32'.tr),
              // // Text(
              // //   'Switch Status: ${_isSwitched ? 'On' : 'Off'}',
              // //   style: TextStyle(fontSize: 20.0),
              // // ),

              // SizedBox(height: 16.0),
              // Switch(
              //   value: _isSwitched,
              //   onChanged: (value) {
              //     setState(() {
              //       _isSwitched = value;
              //     });
              //   },
              //   activeColor: Color.fromARGB(
              //       255, 19, 157, 6), // Customize the active color
              // ),
            ],
          ),

          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      color: Colors.white,
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(), // Default border sides
                            ),
                            labelText: '34'.tr,
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,

                        border: Border.all(
                            color: Colors.grey), // Border on all sides
                        borderRadius: BorderRadius.circular(
                            4.0), // Optional: rounded corners
                      ),
                      child: DropdownButton(
                          underline: Container(
                              color: const Color.fromARGB(0, 255, 255, 255)),
                          value: _selectedhouse,
                          items: Kind.values
                              .map(
                                (lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Text(
                                    lang.kindValue.toString(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedhouse = value;
                            });
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    //textDirection: TextDirection.rtl,
                    child: Container(
                      height: 50,
                      color: Colors.white,
                      child: TextFormField(
                        controller: _streetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(), // Default border sides
                            ),
                            labelText: '42'.tr,
                            labelStyle: TextStyle(color: Colors.black)),
                        onSaved: (value) {
                          _streetController = value as TextEditingController;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: Colors.white,
                      child: TextFormField(
                        controller: _building,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(), // Default border sides
                            ),
                            labelText: '104'.tr,
                            labelStyle: TextStyle(color: Colors.black)),
                        onSaved: (value) {
                          _building = value as TextEditingController;
                          neighbor = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),

          Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('37'.tr),
                  ),
                  ElevatedButton(
                    onPressed: search,
                    child: Text('36'.tr),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
