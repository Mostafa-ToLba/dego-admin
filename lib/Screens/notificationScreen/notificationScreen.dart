import 'package:dego_admin/business_logic/view_models/mainScreen_vm/mainScreen_vm.dart';
import 'package:dego_admin/widgets/textFeild/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    final mainScreenVm = Provider.of<MainScreenViewModel>(context,listen: false);
    // Add listener to arabicTitleController
    mainScreenVm.arabicTitleController.addListener(() {
      setState(() {}); // Trigger a rebuild when text changes
    });

    // Add listener to arabicNotificationController
    mainScreenVm.arabicNotificationController.addListener(() {
      setState(() {}); // Trigger a rebuild when text changes
    });

    // Add listener to englishTitleController
    mainScreenVm.englishTitleController.addListener(() {
      setState(() {}); // Trigger a rebuild when text changes
    });

    // Add listener to englishNotificationController
    mainScreenVm.englishNotificationController.addListener(() {
      setState(() {}); // Trigger a rebuild when text changes
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mainScreenVm = Provider.of<MainScreenViewModel>(context);
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(20.sp),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
             CustomTextField(text: 'Arabic Title',hintText: 'اكتب عنوان الاشعار بالعربي',hintColor: Colors.grey,
            controller: mainScreenVm.arabicTitleController),
            SizedBox(height: 18.h),
             CustomTextField(text: 'Arabic Notification',hintText: 'اكتب الاشعار بالعربي',hintColor: Colors.grey,
                controller: mainScreenVm.arabicNotificationController),
            SizedBox(height: 18.h),
             CustomTextField(text: 'English Title',hintText: 'اكتب عنوان الاشعار بالانجليزي',hintColor: Colors.grey,
                 controller: mainScreenVm.englishTitleController),
            SizedBox(height: 18.h),
             CustomTextField(text: 'English Notification',hintText: 'اكتب الاشعار بالانجليزي',hintColor: Colors.grey,
                 controller: mainScreenVm.englishNotificationController),
            SizedBox(height: 40.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: ()
                      {
                        mainScreenVm.pickNotificationImage();
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.pink,borderRadius: BorderRadius.circular(10.r)),
                            height: 70.h,
                            width: 70.w,
                            child:mainScreenVm.notificationImageFile!=null?
                            Image.file(mainScreenVm.notificationImageFile!,fit: BoxFit.cover,):
                            Icon(Icons.add_a_photo,color: Colors.white,size: 30.sp),
                          ),
                          if(mainScreenVm.notificationImageFile!=null)
                          Positioned(
                              top: 1.sp,
                              right: 1.sp,
                              child: InkWell(
                                  onTap: ()
                                  {
                                    mainScreenVm.notificationImageFile = null;
                                    setState(() {
                                    });
                                  },
                                  child: Icon(Icons.close,size: 30.sp,color: Colors.white)))
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text('Add Icon',style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.w600),)
                  ],
                ),
                 SizedBox(width: 20.w,),
                 Expanded(
                   child: Container(
                     width: 1.sw,
                     height: 70.h,
                     padding: EdgeInsets.symmetric(vertical: 8),
                     child: ElevatedButton(
                       onPressed: mainScreenVm.notificationImageFile!=null&&
    mainScreenVm.arabicTitleController.text.isNotEmpty&&
    mainScreenVm.arabicNotificationController.text.isNotEmpty&&
    mainScreenVm.englishTitleController.text.isNotEmpty&&
    mainScreenVm.englishNotificationController.text.isNotEmpty?()
                       {
                         mainScreenVm.sendNotification(context);
                       }:null,
                       child: Text('Send'),
                     ),
                   ),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
