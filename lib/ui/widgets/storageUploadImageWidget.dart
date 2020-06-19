import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:image/image.dart';

class UploadImageWidget extends StatefulWidget {
  TextEditingController controllerUrl;
  String storagePath;
  String title;
  int width = 800;
  bool narrow = false;
  String url;
  bool onlyShow =false;


  UploadImageWidget(
      {Key key,
      this.controllerUrl,
      this.storagePath = "images",
      this.title,
      this.width=800 , this.narrow = false,  this.url="",
        this.onlyShow = false

      })
      : super(key: key);

  @override
  _UploadImageWidgetState createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  fb.StorageReference storageReference =
      fb.storage().refFromURL('gs://fcnn-8e0f7.appspot.com');
  fb.UploadTask _uploadTask;

  String fullUrl;
  String filePath;

  @override
  void initState() {

    if (!widget.onlyShow &&(  widget.controllerUrl.text.isNotEmpty && widget.url == "") ) {
      widget.url=widget.controllerUrl.text;
    }
      if (widget.url != "" ) {
      fb
          .storage()
          .refFromURL(widget.url)
          .getDownloadURL()
          .then((value) => setState(() {
                fullUrl = value.toString();
              }));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.narrow ? 1000.0 : 600.0;


    return Container(
      height:400,
      width: 600,
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (widget.title == null)
                ? Container()
                : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.title),
                    ),

            Expanded(
              flex: widget.narrow ? 2 : 5,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.center,
                        fit: widget.narrow ? BoxFit.fitWidth: BoxFit.fitHeight,
                        image: fullUrl == null
                            ? AssetImage("assets/logosplash.png")
                            : NetworkImage(fullUrl))),
                width: width,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    StreamBuilder<fb.UploadTaskSnapshot>(
                      stream: _uploadTask?.onStateChanged,
                      builder: (context, snapshot) {
                        final event = snapshot?.data;

                        // Default as 0
                        double progressPercent = event != null
                            ? event.bytesTransferred / event.totalBytes * 100
                            : 0;

                        if (progressPercent == 100) {
                          widget.controllerUrl.text =
                              'gs://fcnn-8e0f7.appspot.com/' + filePath;
                          fb
                              .storage()
                              .refFromURL(widget.controllerUrl.text)
                              .getDownloadURL()
                              .then((value) => setState(() {
                                    fullUrl = value.toString();
                                  }));
                          return Text('Успешно загруженно');
                        } else if (progressPercent == 0) {
                          return SizedBox();
                        } else {
                          return LinearProgressIndicator(
                            value: progressPercent,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton:  widget.onlyShow? null  :FloatingActionButton.extended(
          heroTag: 'picker',
          elevation: 0,
          backgroundColor: Colors.tealAccent[400],
          hoverElevation: 0,
          label: Row(
            children: <Widget>[
              Icon(Icons.file_upload),
              SizedBox(width: 10),
              Text('Загрузить изображение')
            ],
          ),
          onPressed: () => uploadImage(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  /// Upload file to firebase storage and updates [_uploadTask] to the latest
  /// file upload
  uploadToFirebase(File imageFile, Uint8List data) async {
    resizeImage(data, width: widget.width).then((data) {
      filePath = widget.storagePath + '/${imageFile.name}';
      setState(() {
        _uploadTask = storageReference.child(filePath).put(data);
      });
    });
  }

  Future<Uint8List> resizeImage(dynamic file, {int width = 800}) async {
    var image = decodeImage(file);
    var thumbnail = copyResize(image, width: width);
    Uint8List sendData = encodeJpg(thumbnail);

    return sendData;
  }

  /// A "select file/folder" window will appear. User will have to choose a file.
  /// This file will be then read, and uploaded to firebase storage;
  uploadImage() async {
    // HTML input element
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (changeEvent) {
        final file = uploadInput.files.first;
        final reader = FileReader();
        // The FileReader object lets web applications asynchronously read the
        // contents of files (or raw data buffers) stored on the user's computer,
        // using File or Blob objects to specify the file or data to read.
        // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader

        reader.readAsArrayBuffer(file);
        // The readAsDataURL method is used to read the contents of the specified Blob or File.
        //  When the read operation is finished, the readyState becomes DONE, and the loadend is
        // triggered. At that time, the result attribute contains the data as a data: URL representing
        // the file's data as a base64 encoded string.
        // Source: https://developer.mozilla.org/en-US/docs/Web/API/FileReader/readAsDataURL

        reader.onLoadEnd.listen(
          // After file finiesh reading and loading, it will be uploaded to firebase storage
          (loadEndEvent) async {
            uploadToFirebase(file, reader.result);
          },
        );
      },
    );
  }
}

// Stream that returns list of links docs
Stream<List<Map<String, dynamic>>> userLinks(fs.Firestore firestore) {
  return firestore
      .collection('links')
      .onSnapshot
      .map((data) => data.docs.map((doc) => doc.data()).toList());
}
