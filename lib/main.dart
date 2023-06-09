import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_puzzle/level4.dart';
import 'package:photo_puzzle/level_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashBoard(),
  ));
}

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  get_Permit() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> statusess;
    if (androidInfo.version.sdkInt <= 32) {
      statusess = await [
        Permission.storage,
      ].request();
    } else {
      statusess = await [Permission.photos, Permission.notification].request();
    }
    var allAccepted = true;
    statusess.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    //print(allAccepted);


  }
  void initState() {
    // TODO: implement initState
    super.initState();
    get_Permit();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Photo Puzzle",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
           decoration: BoxDecoration(
          //   colors: [
          //     Colors.black,
          //     Colors.white,
          //   ],
          // ),
            image: DecorationImage(
                image: AssetImage("images/myback.jpg"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Level_Page();
                },));
              },
                child: Container(
                  height: 50,
                  width: 110,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "3 X 3",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Level4();
                },));
              },
                child: Container(
                  height: 50,
                  width: 110,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "4 X 4",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
