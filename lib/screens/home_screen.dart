import 'dart:io';

import 'package:flutter/material.dart';
import 'package:register_app/model/userdata.dart';
import 'package:register_app/routes/routes.dart';

import '../global/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserData> userList = [];

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          IconButton(
              onPressed: () async {
                navigateToAdd();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        child: userList.isEmpty
            ? Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text("No Data", style: TextStyle(fontSize: 20)),
                      MaterialButton(
                        color: Colors.blueAccent,
                        onPressed: () {
                          navigateToAdd();
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  var user = userList[index];
                  return Container(
                    child: ListTile(
                      onTap: () {
                        print(user.id);
                      },
                      title: Text("${user.firstName} ${user.lastName}"),
                      subtitle: Text("${user.date}"),
                      leading: Text("${index + 1}"),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: user.image.isNotEmpty
                            ? Image.file(File(user.image))
                            : SizedBox(),
                      ),
                    ),
                  );
                },
                itemCount: userList.length,
              ),
      ),
    );
  }

  getAllUsers() async {
    var db = await Database.getDatabase();
    List<UserData> users = await db.getAllUsers();
    setState(() {
      userList.addAll(users);
    });
  }

  void navigateToAdd() async {
    var data = await Routes().navigateToRegistration(context);
    if (data != null) {
      setState(() {
        userList.add(data);
      });
    }
  }
}
