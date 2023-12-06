// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:bmiapp/screens/login_screen.dart';
import 'package:bmiapp/screens/save_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const BMIApp());
}


class BMIApp extends StatefulWidget {
  const BMIApp({Key? key}) : super(key: key);

  @override
  State<BMIApp> createState() => _BMIAppState();
}

class _BMIAppState extends State<BMIApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen()
    );
  }
}

class HomePage extends StatefulWidget {



  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {




  var ftController = TextEditingController();

  var nmController = TextEditingController();
  var adController = TextEditingController();
  String? gender;
  var bdController = TextEditingController();

  var wtController = TextEditingController();
  var htController = TextEditingController();

  var bdy = DateFormat('dd/MM/yyyy').format(DateTime.now());

  DateTime date = DateTime(2022, 12, 24);

  var result = "";

  FirebaseDatabase database = FirebaseDatabase.instance;
  //DatabaseReference ref = FirebaseDatabase.instance.ref();
  DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");


  @override
  void initState() {
    super.initState();
    // Set the default text
    bdController.text = bdy;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('BMI Calculator'),
        centerTitle: true,

        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              // Handle menu item selection
              print('Selected: $value');
              if (value=="Saved"){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SaveScreen();
                  }),
                );


              }else if (value=="Logout"){

       //         await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );

              }



            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Saved',
                  child: Text('Saved'),
                ),
                PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 350,
            child: Column(
              children: [
                const SizedBox(
                  height: 11,
                ),
                const Text(
                  'Personal Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextField(
                  controller: nmController,
                  decoration: const InputDecoration(
                      labelText: 'Enter name',
                      prefixIcon: Icon(Icons.face_6),
                      hintText: 'Enter your name'),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 11,
                ),
                TextField(
                  controller: adController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Address',
                      prefixIcon: Icon(Icons.location_on),
                      hintText: 'Enter your address'),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    // Text('Gender:'),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Radio(
                          value: 'Male',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        const Text('Male'),
                        const SizedBox(width: 20),
                        Radio(
                          value: 'Female',
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        const Text('Female'),
                      ],
                    ),
                  ],
                ),
                TextField(
                  controller: bdController,
                  decoration: const InputDecoration(
                    label: Text('Enter your Birthday'),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1923),
                        lastDate: DateTime(2024));

                    if (newDate == null) return;

                    setState(() {
                      bdController.text =
                          '${newDate.day}/${newDate.month}/${newDate.year}';
                    });
                  },
                ),
                const SizedBox(
                  height: 55,
                ),
                const Text(
                  'Health Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextField(
                  controller: wtController,
                  onChanged: (text) {
                    print('Changed');
                  },
                  decoration: const InputDecoration(
                    label: Text('Enter your weight in kg'),
                    prefixIcon: Icon(Icons.scale),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 11,
                ),
                TextField(
                  controller: htController,
                  decoration: const InputDecoration(
                    label: Text('Enter your Height (in cm)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 11,
                ),
                const SizedBox(
                  height: 11,
                ),
                ElevatedButton(
                    onPressed: ()  {


                      var nm = nmController.text.toString();
                      var ad = adController.text.toString();
                      // gender is ok
                      var bd = bdController.text.toString();

                      var wt = wtController.text.toString();
                      var ht = htController.text.toString();

                      if (nm != "" &&
                          ad != "" &&
                          gender != null &&
                          wt != "" &&
                          ht != "" &&
                          bd != "") {
                        setState(() {
                          result = '';

                          var iWt = int.parse(wt);
                          var iHt = int.parse(ht);

                          var wtText;
                          var wtTextColor = Colors.red;

                          if (iWt > 595 || iWt < 0) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Invalid Weight'),
                                  content: const Text(
                                      'Fact: The heaviest man in the world is 595kg.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK')),
                                  ],
                                );
                              },
                            );

                            return;
                          } else if (iHt > 251 || iHt < 0) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Invalid Height'),
                                  content: const Text(
                                      'Fact: The Tallest man in the world is 251cm.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK')),
                                  ],
                                );
                              },
                            );

                            return;
                          }

                          var bmiValue = (iWt / ((iHt / 100) * (iHt / 100)));

                          if (gender == 'Female') {
                            if (bmiValue < 18.5) {
                              wtText = "Underweight";
                              wtTextColor = Colors.red;
                            } else if (bmiValue < 25) {
                              wtText = "Normal";
                              wtTextColor = Colors.green;
                            } else {
                              wtText = "Overweight";
                              wtTextColor = Colors.red;
                            }
                          } else if (gender == 'Male') {
                            if (bmiValue < 18.5) {
                              wtText = "Underweight";
                              wtTextColor = Colors.red;
                            } else if (bmiValue < 25) {
                              wtText = "Normal";
                              wtTextColor = Colors.green;
                            } else {
                              wtText = "Overweight";
                              wtTextColor = Colors.red;
                            }
                          }


                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  // title: Text(wtText.toString(),),
                                  content: Column(
                                    children: [
                                      Text(
                                        wtText.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: wtTextColor,
                                        ),
                                      ),
                                      Text(
                                        'BMI: ${bmiValue.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Table(
                                        columnWidths: const {
                                          0: FractionColumnWidth(0.2)
                                        },
                                        //border: TableBorder.all(),
                                        children: [
                                          TableRow(children: [
                                            const TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  child: Icon(Icons.face_6),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(nm),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            const TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  child:
                                                      Icon(Icons.location_on),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(ad),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            const TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  child: Icon(Icons.cake),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(bd),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          const TableRow(children: [
                                            TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  child: Text(""),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(""),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            const TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  child: Icon(Icons.scale),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('${wt}kg'),
                                                ),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            const TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  child: Icon(Icons.height),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('${ht}cm'),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ],
                                  ),

                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            nmController.text = "";
                                            adController.text = "";
                                            bdController.text = "";
                                            wtController.text = "";
                                            htController.text = "";
                                            gender = null;
                                            result = '';
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Reset')),

                                    TextButton(
                                        onPressed: () async{
                                          print(nm);
                                          print(ad);
                                          print(bd);
                                          print(gender.toString());
                                          print(wt);
                                          print(ht);
                                          print(bmiValue.toStringAsFixed(2));
                                          print(wtText);

                                          final userData = {
                                            'name': nm,
                                            'address': ad,
                                            'age': bd,
                                            'gender': gender.toString(),
                                            'weight': wt,
                                          };

                                          var currentUser = FirebaseAuth.instance.currentUser;

                                          if (currentUser != null) {
                                            var uid = currentUser.uid.toString();
                                            var uemail = currentUser.email.toString();
                                            print(uid);
                                            print(uemail);

                                            DateTime currentDateTime = DateTime.now();

                                            String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);

                                            DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid/$formattedDateTime");


                                            await ref.set({
                                              "name": nm,
                                              "address": ad,
                                              "birthday":bd,
                                              "gender":gender.toString(),
                                              "height":ht,
                                              "weight":wt,
                                              "bmi":bmiValue.toStringAsFixed(2),
                                              "state":wtText,
                                            });

                                          }





                                          setState(() {
                                            nmController.text = "";
                                            adController.text = "";
                                            bdController.text = "";
                                            wtController.text = "";
                                            htController.text = "";
                                            gender = null;
                                            result = '';
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Save')),

                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK')),
                                  ],
                                );
                              });
                        });
                      } else {
                        setState(() {
                          result = "Some feilds are null!";
                        });
                      }
                    },
                    child: const Text('Calculate')),
                Text(
                  result,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
