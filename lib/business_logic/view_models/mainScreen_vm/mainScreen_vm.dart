
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dego_admin/Screens/homeScreen/homeScreen.dart';
import 'package:dego_admin/Screens/notificationScreen/notificationScreen.dart';
import 'package:dego_admin/Screens/test/testFile.dart';
import 'package:dego_admin/business_logic/setup/base_notifier.dart';
import 'package:dego_admin/business_logic/web_services/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http_parser/http_parser.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_watermark/video_watermark.dart';


class MainScreenViewModel extends BaseNotifier {
  int selectedIndex = 0;
  final List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    const NotificationScreen(),
    const TestWaterScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  VideoPlayerController? controller;
  File? videoFile;
  File? imageFile;

  bool isPlaying = false;
  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
        videoFile = File(result.files.single.path!);
        controller = VideoPlayerController.file(videoFile!)
          ..initialize().then((_) {
            notifyListeners();
          })
        ..addListener(() {
    final bool Playing = controller!.value.isPlaying;
    if (Playing != isPlaying) {
    isPlaying = Playing;
    notifyListeners();
    }
    });
    }
  }
  FormData formDataa = FormData();
  Future<void> pickImage(context) async {
    await getProductImages(context);
    for(int i = 0; i<productImages1.length; i++){
      formDataa.files.add(MapEntry("files",MultipartFile.fromBytes(productImages1[i].bytes?.toList()??[],
           filename:  productImages1[i].name),));
    }
    imageFile = File('');
  }

  FormData formData = FormData();
  double progress = 0.0;
  sendVideoToFirebase(context)
  async {
    progress = 0.1 ;
     setBusy();
    try
    {
      Response<dynamic> res = await api.postVideoAndPic(body: formData);
      print(res.data.toString());
      // await FirebaseFirestore.instance.collection('test').add(
      //      {
      //        'Ph':imageFile!.path,
      //        'Time':Timestamp.now(),
      //        'Tx':'Test Video',
      //        'Vi':videoFile!.path,
      //        'vi':0,
      //      }).then((value)
      // {
      //   videoFile =null;
      //   controller!.dispose();
      //   controller=null;
      //   imageFile = null;
      //   progress = 1.0;
      //   notifyListeners();
      // }).then((value)
      // {
      //   Future.delayed(const Duration(seconds: 1)).then((value)
      //   {
      //     showToast('!!تم الرفع بنجاح',
      //       context: context,
      //       position: StyledToastPosition.top,
      //       animDuration: const Duration(seconds: 1),
      //       duration: const Duration(seconds: 4),
      //       animationBuilder: (
      //           BuildContext context,
      //           AnimationController controller,
      //           Duration duration,
      //           Widget child,
      //           ) {
      //         return SlideTransition(
      //           position: getAnimation<Offset>(
      //               const Offset(0.0, 3.0), const Offset(0, 0), controller,
      //               curve: Curves.fastOutSlowIn),
      //           child: child,
      //         );
      //       },
      //       reverseAnimBuilder: (
      //           BuildContext context,
      //           AnimationController controller,
      //           Duration duration,
      //           Widget child,
      //           ) {
      //         return SlideTransition(
      //           position: getAnimation<Offset>(
      //               const Offset(0.0, 0.0), const Offset(-3.0, 0), controller,
      //               curve: Curves.bounceInOut),
      //           child: child,
      //         );
      //       },
      //     );
      //     progress = 0.0;
      //     notifyListeners();
      //   });
      // });
    }catch(error)
    {
      formData.files.clear();
      print(error.toString());
      setError();
    }
    setIdle();
  }


  File? notificationImageFile;
  Future<void> pickNotificationImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      notificationImageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  final  TextEditingController arabicTitleController = TextEditingController();
  final  TextEditingController arabicNotificationController = TextEditingController();
  final TextEditingController englishTitleController = TextEditingController();
  final TextEditingController englishNotificationController = TextEditingController();
  final TextEditingController videoTextController = TextEditingController();
  sendNotification(context)
  async {
    var a =showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text('Uploading Notification....',style: TextStyle(fontSize: 17.sp),),
          content: const LinearProgressIndicator(),
        );
      },
    );
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST', Uri.parse("http://195.35.52.186:5000/upload"),

    );
    Map<String,String> headers={
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
        'files',
        notificationImageFile!.readAsBytes().asStream(),
        notificationImageFile!.lengthSync(),
        filename: notificationImageFile!.path.split('/').last,
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.headers.addAll(headers);

    /// optional if require to add other fields then image

    print("request: "+request.toString());

    var res = await request.send();


    print("This is response:"+res.toString());
    var responseData = await res.stream.bytesToString();
    print('Response: $responseData');

    String response = responseData;

    // Parse the response
    Map<String, dynamic> jsonResponse = json.decode(response);

    // Extract the uploaded paths list
    List<String> uploadedPaths = List<String>.from(jsonResponse['uploadedPaths']);

    // Variables to store image and video paths
    String imagePaths = '';
    String videoPaths = '';

    // Categorize paths based on extension
    uploadedPaths.forEach((path) {
      if (path.endsWith('.mp4')) {
        videoPaths=path;
      } else {
        imagePaths=path;
      }
    });

    // Print image and video paths
    print('Image paths: $imagePaths');
    print('Video paths: $videoPaths');




    await  FirebaseFirestore.instance.collection('Notifications').add(
        {
          'Ar':arabicTitleController.text,
          'Ar 2':arabicNotificationController.text,
          'En':englishTitleController.text,
          'En 2':englishNotificationController.text,
          'Time':Timestamp.now(),
          'Ph':'${EndPoints.baseURL}/$imagePaths',
        }).then((value)
  {
    Navigator.pop(context);
    arabicTitleController.clear();
    arabicNotificationController.clear();
    englishTitleController.clear();
    englishNotificationController.clear();
    notificationImageFile = null;
    notifyListeners();
    showToast('تم رفع الاشعار بنجاح',context: context);
  });
  }



  //formmmmm

  // uploadFile() async {
  //   var postUri = Uri.parse("<APIUrl>");
  //   var request = http.MultipartRequest("POST", postUri);
  //   request.fields['user'] = 'blah';
  //   request.files.add(new http.MultipartFile.fromBytes('file', await File.fromUri("<path/to/file>").readAsBytes(), contentType: new MediaType('image', 'jpeg')))
  //
  //   request.send().then((response) {
  //     if (response.statusCode == 200) print("Uploaded!");
  //   });
  // }

  uploadFile() async {
    var postUri = Uri.parse("http://195.35.52.186:5000/upload");
    var request = http.MultipartRequest("POST", postUri);

    request.fields['user'] = 'files';
    request.files.add(http.MultipartFile.fromBytes('files', await File.fromUri(Uri.parse(imageFile!.path)).readAsBytes(), ));

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");

    });
  }

  Future<void> uploadFiles() async {
    var postUri = Uri.parse("http://195.35.52.186:5000/upload");
    var request = http.MultipartRequest("POST", postUri);
  //  request.fields['user'] = 'files';
  //   request.files.add(http.MultipartFile.fromBytes(
  //     'files',
  //     await File.fromUri(imageFile!.uri,).readAsBytes(),
  //   ));
    request.headers.addAll({
      "Accept": "*/*",
      "Content-Type": "multipart/form-data",
      // 'authorization': 'Bearer $token',
    });

    request.files.add(http.MultipartFile.fromBytes(
      'files',
      imageFile!.readAsBytesSync(),
    ));
    request.files.add(http.MultipartFile.fromBytes(
      'files',
      videoFile!.readAsBytesSync(),
    ));
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Uploaded!");
        // Read and print the response data
        var responseData = await response.stream.bytesToString();
        print('Response: $responseData');
      } else {
        print('Failed to upload. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> uploadFormDataToServer(FormData formData) async {
    // Initialize Dio client
    Dio dio = Dio();

    try {
      // Send POST request

      Response<dynamic> response = await dio.post(
        'http://195.35.52.186:5000/upload',
        data: formDataa,
        options: Options(
          headers: {
            // 'Content-Type': 'application/x-www-form-urlencoded',
            'Cookie':
            'OpenIdConnect.nonce.S88qwWwOQp%2F3TqKJ0Nepxv5bu7H7Z440Zlf6jGWl4xA%3D=QVFBQUFOQ01uZDhCRmRFUmpIb0F3RV9DbC1zQkFBQUF2X05OTDdlbElVT21fbEpEWVdfR2hBQUFBQUFDQUFBQUFBQVFaZ0FBQUFFQUFDQUFBQUNqQTNCcnVPSGI2akc5cmtTeUd2VHJBMVFqdUlzNVRYQ1VJLURvSi03MEt3QUFBQUFPZ0FBQUFBSUFBQ0FBQUFBUGxqaWxxb1dSQlhJLWN4eWxpZTdFSHl2ZThTZGYyM1h6b1JmcXljMW5ZSUFBQUFEREtDdFhRcGIzdm9NdmlKT2VSMG1kSXg0T282dlJMSThjZ2ZCZzFhNTh0T19oRTU1STV5M00yaFdjcjFHaVRGVEplTVp5X1FuU3lTSWF0eTJncXh5ZUdac2czQ2YxNVh2bzRORTRXMWVOWHlycU1OOVktcDJjSTh3c0YyNEc4bTN6Tmc1eGg5Vi00RTNGdnpIb0FZbFVjM3lkRmo2MWREajlMcU1QQmw4b3MwQUFBQUJMQk82NVMtQzBEdGJ0NjA1ME4zTGNZS2RoTTlUdUdwSUpEcVBwRWkwVmliMHpnMG9DcXc2bUp3bGZoYjdOb2VHVW9TT0c4NDRkMUNtUXFpY2ptMHR2; OpenIdConnect.nonce.TNmcQjU6a8IK156dgG3SdSV%2Fzg7P7oK3MseSgclbaYw%3D=QVFBQUFOQ01uZDhCRmRFUmpIb0F3RV9DbC1zQkFBQUF2X05OTDdlbElVT21fbEpEWVdfR2hBQUFBQUFDQUFBQUFBQVFaZ0FBQUFFQUFDQUFBQUQ1ak9hWWN4Skd3d1hqZFA1YzZGSHRkX05nYTNmQ29mZUQ5ZF9TZWU4eEN3QUFBQUFPZ0FBQUFBSUFBQ0FBQUFBWm10OW5EdWd1UGkxc0pjNlVtZFZ5djZNel9sTy1rMlRuYzF3UTJqMlJINEFBQUFEeXV0MDk5OGc5RWdLMnJ0dlBSMENESEF5YnBVb09hcFpMZmxfelRCSEloSXNxY2tGakQ5OXFLbzVuTXRLbjM2Z3VEcnFXbnJiZ0pPZy1nVVdJeDVfbm5aWXJtcEhGb2Q5ZndXbTU1UnNpY2NFVDFzV0ZVRFlrWlUxVllIV3ZsR25HVGdSOFFHQUFmOWVJeFNrUS1zczNUZ2Q3c2xtUFBWamozNnpFdHhvVWEwQUFBQUJPdjAtTnR5WEZBTTZsQTlJVHQxbGk4bGU2cnp5MVB2cUdZUVUzbjV4QTdZMldXSnNpWjQ3Um5HT0pUMG02VUgwc2FCeHZmYTY5ZDBmLUVTOGpqeE1k',
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },contentType:'multipart/form-data' ,
          followRedirects: true,
          validateStatus: (status) => true,
        ),
      );

      // Handle response
      print('Response: ${response.statusCode} - ${response.data}');
      // Handle response data here if needed

    } catch (error) {
      print('Error uploading FormData: $error');
      // Handle error here
    }
  }


  static Future<List<PlatformFile>> getImages(BuildContext context, {bool multiple = true}) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: multiple,
      allowedExtensions: ['png','Png','PNG','JPEG','Jpeg','jpeg','JPG','jpg','Jpg',],
    );
    return result?.files??[];
  }

  List<PlatformFile> productImages1 = [];
  int newImagesLength = 0;
  Future getProductImages(BuildContext context)async{
    productImages1 = await getImages(context);
    newImagesLength = productImages1.length;
    imageFile = File('path');
    notifyListeners();
  }


  Future<int> uploadFilee({File? VideoFile,File? ImageFile,context})async{
    progress = 0.0;
    notifyListeners();

    var a =showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text('Uploading Video....',style: TextStyle(fontSize: 17.sp),),
          content: const LinearProgressIndicator(),
        );
      },
    );
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST', Uri.parse("http://195.35.52.186:5000/upload"),

    );
    Map<String,String> headers={
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
        'files',
        File(fileWithWaterToTrns!).readAsBytes().asStream(),
          File(fileWithWaterToTrns!).lengthSync(),
   //     VideoFile!.readAsBytes().asStream(),
      //  VideoFile.lengthSync(),
        filename: File(fileWithWaterToTrns!).path.split('/').last,
        //VideoFile.path.split('/').last,
         contentType: MediaType('video','mp4'),
      ),
    );
    request.files.add(
      http.MultipartFile(
        'files',
        ImageFile!.readAsBytes().asStream(),
        ImageFile.lengthSync(),
        filename: ImageFile.path.split('/').last,
        contentType: MediaType('image','jpeg'),
      ),
    );
    request.headers.addAll(headers);

    /// optional if require to add other fields then image

    print("request: "+request.toString());

    var res = await request.send();


    print("This is response:"+res.toString());
    var responseData = await res.stream.bytesToString();
    print('Response: $responseData');

    String response = responseData;

    // Parse the response
    Map<String, dynamic> jsonResponse = json.decode(response);

    // Extract the uploaded paths list
    List<String> uploadedPaths = List<String>.from(jsonResponse['uploadedPaths']);

    // Variables to store image and video paths
    String imagePaths = '';
    String videoPaths = '';

    // Categorize paths based on extension
    uploadedPaths.forEach((path) {
      if (path.endsWith('.mp4')) {
        videoPaths=path;
      } else {
        imagePaths=path;
      }
    });

    // Print image and video paths
    print('Image paths: $imagePaths');
    print('Video paths: $videoPaths');

   // send to firebase ********************************************
    await FirebaseFirestore.instance.collection('Videos').add(
         {
           'Ph':'${EndPoints.baseURL}/$imagePaths',
           'Time':Timestamp.now(),
           'Tx':videoTextController.text,
           'views':0,
           'Vi':'${EndPoints.baseURL}/$videoPaths',
         }).then((value)
    {
      videoFile =null;
      controller!.dispose();
      controller=null;
      imageFile = null;
      progress = 1.0;
      notifyListeners();
    }).then((value)
    {
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 1)).then((value)
      {
        showToast('تم رفع الفيديو بنجاح',context: context,duration: const Duration(seconds: 5));
        progress = 0.0;
        videoTextController.clear();
        imageFile=null;
        fileName = null;
        videoFile=null;
        notifyListeners();
      });
    });
    return res.statusCode;
  }




  Future<void> pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );

    if (result != null) {
      fileName = result.files.single.path!;
      imageFile = File(result.files.single.path!);
      notifyListeners();
    }
  }

  String? fileName ;
  generatePic()
  async {
    fileName = await VideoThumbnail.thumbnailFile(
        video: videoFile!.path,
        timeMs:0,
        quality: 100,
        thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.WEBP,
    );
    print('********************$fileName*********');
    notifyListeners();
  }
  VideoWatermark? videoWatermark ;
  testWaterMrk({videoPath})
  async {
    videoWatermark= VideoWatermark(
      sourceVideoPath: videoPath!,
      savePath: videoPath,
      watermark: Watermark(
        watermarkAlignment:WatermarkAlignment.center,
        watermarkSize:WatermarkSize.symmertric(30.w,),

        image: WatermarkSource.asset('assets/images/dego-logo.png'),
      ),
      onSave: onSave,
    );
    await videoWatermark!.generateVideo();
    notifyListeners();
  }
  String? fileWithWaterToTrns ;
 VideoPlayerController? videoPlayerControllerWithWter;
  void onSave(String? file) {
    print('FILE: ${file}');
    if (file != null) {
      fileWithWaterToTrns = file;
      videoPlayerControllerWithWter = VideoPlayerController.file(File(file))
        ..initialize().then((value) {
          notifyListeners();
        });
    } else {
      notifyListeners();
    }
  }
  
  sendDataToFirebase({personID,name,age,nationalityID,birthDate})
  {
    FirebaseFirestore.instance.collection('setData').
        add({'personID ':personID,'name':name,'age':age,'nationalityID':nationalityID,
          'birthDate ':birthDate});
  }


}
