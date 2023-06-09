import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_puzzle/data.dart';
import 'package:photo_puzzle/level_page.dart';

class PlayGame_Page extends StatefulWidget {
  int index;

  PlayGame_Page(this.index);

  @override
  State<PlayGame_Page> createState() => _PlayGame_PageState();
}

class _PlayGame_PageState extends State<PlayGame_Page> {
  bool temp = false;
  List<img.Image> myList = [];
  int a = 0;
  bool temp_time = false;
  List<bool> temp1 = [];
  List img_list = [];
  List img_list1 = [];

  List<img.Image> splitImage(
      img.Image inputImage, int horizontalPieceCount, int verticalPieceCount) {
    img.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<img.Image>.empty(growable: true);
    int x = 0, y = 0;

    for (int i = 0; i < horizontalPieceCount; i++) {
      for (int j = 0; j < verticalPieceCount; j++) {
        pieceList.add(img.copyCrop(image,
            x: x, y: y, width: pieceWidth, height: pieceHeight));
        x = x + pieceWidth;
      }
      y = y + pieceHeight;
      x = 0;
    }
    return pieceList;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('images/$path');

    var dir_path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS) +
        "/PhotoPuzzle";

    Directory dir = Directory(dir_path);

    if (!await dir.exists()) {
      dir.create();
    }
    final file = File('${dir_path}/${Random().nextInt(1000)}$path');
    print(file.path);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    //print(file.path);
    return file;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFileFromAssets("${Data.photo[widget.index]}").then((value) {
      img.Image? images = img.decodeJpg(value.readAsBytesSync());
      myList = splitImage(images!, 3, 3);
      print(myList);
      for (int i = 0; i < myList.length; i++) {
        img_list.add(
          Image.memory(
            img.encodeJpg(myList[i]),
            fit: BoxFit.fill,
          ),
        );
      }
      img_list1.addAll(img_list);
      img_list.shuffle();
      temp = true;
      temp1 = List.filled(img_list.length, true);
      setState(() {});
    });
  }

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
        body: (temp)
            ? Container(margin: EdgeInsets.all(20),
              child: GridView.builder(
          itemCount: myList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
              return (temp1[index])
                  ? Draggable(
                  data: index,
                  onDragStarted: () {
                    temp1 = List.filled(img_list.length, false);
                    temp1[index] = true;
                    setState(() {});
                  },
                  onDragEnd: (details) {
                    temp1 = List.filled(img_list.length, true);
                    temp1[index] = true;
                    setState(() {});
                  },
                  child: img_list[index],
                  feedback: img_list[index])
                  : DragTarget(
                onAccept: (data) {
                  Image temp_img = img_list[data as int];
                  img_list[data as int] = img_list[index];
                  img_list[index] = temp_img;

                  if (listEquals(img_list, img_list1)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Congratulations.."),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  widget.index++;
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return PlayGame_Page(
                                              widget.index);
                                        },
                                      ));

                                  //   widget.index++;
                                  //
                                  // setState(() {
                                  //
                                  // });
                                },
                                child: Text("Ok"))
                          ],
                        );
                      },
                    );
                  }
                  setState(() {});
                },
                builder:
                    (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(
                            img.encodeJpg(myList[index]),
                          ),
                          fit: BoxFit.fill),
                    ),
                  );
                },
              );
          },
        ),
            )
        // GridView.builder(itemCount: img_list.length,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       crossAxisSpacing: 5,
        //       mainAxisSpacing: 5),
        //   itemBuilder: (context, index) {
        //     return img_list[index];
        //   },)
            : CircularProgressIndicator(),
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
                          return Level_Page();
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
