import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(Detectionpage());
}

class Detectionpage extends StatefulWidget {
  Detectionpage({Key? key}) : super(key: key);
  @override
  _DetectionpageState createState() => _DetectionpageState();
}

class _DetectionpageState extends State<Detectionpage> {
  late ImagePicker imagePicker;
  File? _image;
  var image;
  //TODO declare detector
  late ObjectDetector objectDetector;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    //TODO initialize detector
    // this lines are used for default model of google mlkit
    // final options = ObjectDetectorOptions(
    //     mode: DetectionMode.single,
    //     classifyObjects: true,
    //     multipleObjects: true);
    // objectDetector = ObjectDetector(options: options);
    // it ends here

    // add this line if u want to access the custom trained model of mlkit lib
    loadModel();
  }

  // loadmodel uses custom trained model and if u want to add it un-comment it
  loadModel() async {
    final modelPath = await getModelPath('ml/model.tflite');
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.single,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    objectDetector = ObjectDetector(options: options);
  }

  //to use custom trained model add this code
  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
// it ends here

  @override
  void dispose() {
    super.dispose();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doObjectDetection();
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doObjectDetection();
    }
  }

  //TODO face detection code here
  List<DetectedObject> objects = [];
  doObjectDetection() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    objects = await objectDetector.processImage(inputImage);

    for (DetectedObject detectedObject in objects) {
      final rect = detectedObject.boundingBox;
      final trackingId = detectedObject.trackingId;
// each lables of objects
      for (Label label in detectedObject.labels) {
        print('${label.text} ${label.confidence}');
      }
    }
    setState(() {
      _image;
    });
    drawRectanglesAroundObjects();
  }

  //TODO draw rectangles
  drawRectanglesAroundObjects() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {
      image;
      objects;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Object Detection',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: 100,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Stack(children: <Widget>[
                    Center(
                      child: ElevatedButton(
                        onPressed: _imgFromGallery,
                        onLongPress: _imgFromCamera,
                        style: ElevatedButton.styleFrom(

                            // backgroundColor: Colors.transparent,
                            //foregroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),

                        // child: Container(
                        //   margin: EdgeInsets.only(top: 8),
                        //   // padding: EdgeInsets.all(2),
                        //   // margin: const EdgeInsets.symmetric(
                        //   //     vertical: 50, horizontal: 30),
                        //   child: _image != null
                        //       ? Image.file(
                        //           _image!,
                        //           width: 400,
                        //           height: 500,
                        //           fit: BoxFit.fill,
                        //         )
                        //       : Container(
                        //           width: 300,
                        //           height: 300,
                        //           child: const Icon(
                        //             Icons.camera_alt,
                        //             color: Colors.white,
                        //             size: 100,
                        //           ),
                        //         ),
                        // ),

                        child: Container(
                          width: 350,
                          height: 350,
                          margin: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: image != null
                              ? Center(
                                  child: FittedBox(
                                    child: SizedBox(
                                      width: image.width.toDouble(),
                                      height: image.width.toDouble(),
                                      child: CustomPaint(
                                        painter: ObjectPainter(
                                            objectList: objects,
                                            imageFile: image),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.transparent,
                                  width: 350,
                                  height: 350,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

class ObjectPainter extends CustomPainter {
  List<DetectedObject> objectList;
  dynamic imageFile;
  ObjectPainter({required this.objectList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 4;

    for (DetectedObject rectangle in objectList) {
      canvas.drawRect(rectangle.boundingBox, p);
      var list = rectangle.labels;
      for (Label label in list) {
        print("${label.text}   ${label.confidence.toStringAsFixed(2)}");
        TextSpan span = TextSpan(
            text: label.text,
            style: const TextStyle(fontSize: 25, color: Colors.blue));
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas,
            Offset(rectangle.boundingBox.left, rectangle.boundingBox.top));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
