
 import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dego_admin/business_logic/view_models/mainScreen_vm/mainScreen_vm.dart';
import 'package:dego_admin/widgets/textFeild/custom_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final mainScreenVm = Provider.of<MainScreenViewModel>(context,listen: false);
    mainScreenVm.videoTextController.addListener(() {
      setState(() {}); // Trigger a rebuild when text changes
    });
    super.initState();
  }
  @override
  void dispose() {
    final mainScreenVm = Provider.of<MainScreenViewModel>(context,listen: false);
    mainScreenVm.controller!.dispose();
    super.dispose();
  }
   @override
   Widget build(BuildContext context) {
     final mainScreenVm = Provider.of<MainScreenViewModel>(context);
     return  SingleChildScrollView(
       child: Padding(
         padding:  EdgeInsets.all(20.sp),
         child: Column(
           children: [
             Row(
               children: [
                 Expanded(
                   child: Container(
                     child: mainScreenVm.controller != null && mainScreenVm.controller!.value.isInitialized
                         ? Stack(
                       alignment: Alignment.center,
                       children: [
                         mainScreenVm.controller != null && mainScreenVm.controller!.value.isInitialized
                             ? SizedBox(
                               height: 220.h,
                               width: double.infinity,
                               child: AspectRatio(
                                 aspectRatio: mainScreenVm.controller!.value.aspectRatio,
                                 child: VideoPlayer(mainScreenVm.controller!),
                               ),
                             )
                             :const SizedBox(height: 0,),
                         mainScreenVm.controller != null && mainScreenVm.controller!.value.isInitialized
                             ?InkWell(
                             onTap: ()
                             {
                               mainScreenVm.isPlaying
                                   ? mainScreenVm.controller!.pause()
                                   : mainScreenVm.controller!.play();
                             },
                             child: Icon(mainScreenVm.isPlaying ? Icons.pause : Icons.play_circle,size: 50.sp,color: Colors.pink)):const SizedBox(height: 0),
                         Positioned(
                             top: 5.h,
                             right: 5.w,
                             child: InkWell(
                                 onTap: ()
                                 {

                                   mainScreenVm.controller!.dispose();
                                   mainScreenVm.controller=null;
                                   mainScreenVm.videoFile = null;
                                   mainScreenVm.progress = 0.0;
                                   setState(() {

                                   });
                                 },
                                 child: Icon(Icons.close,size: 30.sp,color: Colors.white)))
                       ],
                     ):const SizedBox(height: 0),
                   ),
                 ),
                 SizedBox(width: 10.w),
                 //image
                 Expanded(
                   child: mainScreenVm.fileName!=null?Stack(
                     children: [
                       Container(
                           height: 220.h,
                           width: 1.sw,
                           child: Image.file(fit: BoxFit.cover,
                             File(mainScreenVm.fileName!,),
                           ),),
                       Positioned(
                           top: 5.h,
                           right: 5.w,
                           child: InkWell(
                               onTap: ()
                               {
                                 mainScreenVm.fileName = null;
                                 mainScreenVm.progress = 0.0;
                                 setState(() {
                                 });
                               },
                               child: Icon(Icons.close,size: 30.sp,color: Colors.white)))
                     ],
                   ):
                   const SizedBox(width: 0,),
                 )
               ],
             ),
             SizedBox(height: (mainScreenVm.controller != null && mainScreenVm.controller!.value.isInitialized)||mainScreenVm.fileName!=null
                 ?80.h:240.h),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children:
               [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     InkWell(
                       onTap: ()
                       async {
                        await mainScreenVm.pickVideo();
                         mainScreenVm.generatePic();
                       },
                       child: Container(
                         height: 100.h,
                         width: 100.w,
                         decoration: BoxDecoration(color: Colors.pink,borderRadius: BorderRadius.circular(10.r)),
                         child: Icon(Icons.video_camera_back,color: Colors.white,size: 40.sp),
                       ),
                     ),
                     SizedBox(height: 5.h),
                     Text('Add Video',style: TextStyle(color: Colors.black,fontSize: 13.sp,fontWeight: FontWeight.w600),)
                   ],
                 ),
                 SizedBox(width: 25.w),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     InkWell(
                       onTap: ()
                       {
                          mainScreenVm.pickPhoto();
                       },
                       child: Container(
                         decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10.r)),
                         height: 100.h,
                         width: 100.w,

                         child: Icon(Icons.photo,color: Colors.white,size: 40.sp),
                       ),
                     ),
                     SizedBox(height: 5.h),
                     Text('Add Photo',style: TextStyle(color: Colors.black,fontSize: 13.sp,fontWeight: FontWeight.w600),)
                   ],
                 ),
               ],
             ),
             CustomTextField(text: '',hintText: '',hintColor: Colors.grey,
                 controller: mainScreenVm.videoTextController,),
             SizedBox(height: 10.h,),
             Container(
               width: 220.w,
               height: 60.h,
               padding: const EdgeInsets.symmetric(vertical: 8),
               child: ElevatedButton(
                 onPressed:
                 mainScreenVm.videoFile != null && mainScreenVm.fileName != null &&
                     mainScreenVm.videoTextController.text.isNotEmpty?
                     ()
                 async {
                  mainScreenVm.uploadFilee(VideoFile:  mainScreenVm.videoFile!,ImageFile:
                  File(mainScreenVm.fileName!),context: context);
                 }
                 :null,
                 child: const Text('Send'),
               ),
             ),
             SizedBox(height: 10.h,),
             if(mainScreenVm.progress!= 0.0)
             LinearProgressIndicator(value: mainScreenVm.progress,color: Colors.black),
             /////////test/////
             Container(
               width: 220.w,
               height: 60.h,
               padding: const EdgeInsets.symmetric(vertical: 8),
               child: ElevatedButton(
                 onPressed:
                     ()
                 async {
                   mainScreenVm.testWaterMrk(videoPath:mainScreenVm.videoFile!.path);
                 }
                 ,
                 child: const Text('make waterMark'),
               ),
             ),
             SizedBox(height: 20.h),
             mainScreenVm.videoPlayerControllerWithWter != null && mainScreenVm.videoPlayerControllerWithWter!.value.isInitialized
                 ?
             SizedBox(
               height: 220.h,
               width: double.infinity,
               child: AspectRatio(
                 aspectRatio: mainScreenVm.videoPlayerControllerWithWter!.value.aspectRatio,
                 child: VideoPlayer(mainScreenVm.videoPlayerControllerWithWter!),
               ),
             ):const SizedBox(height: 0,),
           ],
         ),
       ),
     );
   }
}
