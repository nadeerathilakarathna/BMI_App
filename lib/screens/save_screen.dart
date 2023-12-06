import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SaveScreen(),
    );
  }
}

class SaveScreen extends StatelessWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    var uid = (currentUser?.uid).toString();
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child("$uid");

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Saved')),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: userRef.once().then((event) => event.snapshot),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.value == null) {
            return Center(child: Text('User data not found.'));
          }

          dynamic userData = snapshot.data!.value;

          if (userData is! Map) {
            return Center(child: Text('Invalid user data.'));
          }

          List<Map<String, dynamic>> userList = [];

          userData.forEach((key, value) {
            if (value is Map) {
              userList.add(Map<String, dynamic>.from(value));
            }
          });

          return ListView.builder(



            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> user = userList[index];

              var genimage = "assets/bmi_female.png";
              if (user["gender"]=="Male"){
                genimage = "assets/bmi_male.png";
              }

              var bmiimg = "assets/bmi_normal.png";
              if (user["state"]=="Overweight"){
                bmiimg = "assets/bmi_overweight.png";
              }else if (user["state"]=="Underweight"){
                bmiimg = "assets/bmi_underweight.png";
              }

              return Card(
                elevation: 5, // You can adjust the elevation for the card
                margin: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Container(
                    padding: EdgeInsets.all(10.0),
                    //color: Colors.blue,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  genimage,
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  "${user["name"]}",
                                  style: TextStyle(
                                    fontSize: 18, // Adjust the size as needed
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            )),

                        Container(
                            child: Column(
                              children: [
                                Image.asset(
                                  bmiimg,
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  "BMI : ${user["bmi"]}",style: TextStyle(
                                  fontSize: 15, // Adjust the size as needed
                                  fontWeight: FontWeight.bold,
                                ),
                                )
                              ],
                            )),
                        Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(child: SizedBox(width: 1,)),
                                        Icon(Icons.scale, color: Colors.black),
                                        Text("  ${user["weight"]}kg"),
                                        Expanded(child: SizedBox(width: 1,)),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(child: SizedBox(width: 1,)),
                                        Icon(Icons.height, color: Colors.black),
                                        Text("${user["height"]}cm"),
                                        Expanded(child: SizedBox(width: 1,)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(child: SizedBox(width: 1,)),
                                        Icon(Icons.location_on, color: Colors.black),
                                        Text("${user["address"]}"),
                                        Expanded(child: SizedBox(width: 1,)),
                                      ],
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(child: SizedBox(width: 1,)),
                                        Icon(Icons.cake, color: Colors.black),
                                        Text(" ${user["birthday"]}"),
                                        Expanded(child: SizedBox(width: 1,)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
