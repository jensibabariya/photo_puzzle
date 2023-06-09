import 'package:flutter/material.dart';
import 'package:photo_puzzle/data.dart';
import 'package:photo_puzzle/main.dart';
import 'package:photo_puzzle/playgame_page.dart';

class Level_Page extends StatefulWidget {
  const Level_Page({Key? key}) : super(key: key);

  @override
  State<Level_Page> createState() => _Level_PageState();
}

class _Level_PageState extends State<Level_Page> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
                title: Text(
                  "Photo Puzzle",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black),
            body: ListView.builder(
              itemCount: Data.photo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PlayGame_Page(index);
                      },
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 2),
                    height: 400,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/${Data.photo[index]}"),
                            fit: BoxFit.fill)),
                  ),
                );
              },
            ),
          )),
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are you sure you want to exit ?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return DashBoard();
                        },
                      ));
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No")),
              ],
            );
          },
        );
        return true;
      },
    );
  }
}
