import 'package:dego_admin/business_logic/view_models/mainScreen_vm/mainScreen_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
   const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final mainScreenVm = Provider.of<MainScreenViewModel>(context);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title:  Text('Dego Admin',style: TextStyle(color: Colors.white,fontSize: 20.sp,
        fontWeight: FontWeight.w600,fontFamily: 'BreeSerif'),),
        actions: [
          Image(image: const AssetImage('assets/images/dego-logo.png',),color: Colors.white,
          height: 35.r,),
          SizedBox(width: 20.w,)
        ],
      ),
      body: mainScreenVm.widgetOptions[mainScreenVm.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 1,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Profile',
            activeIcon: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r),
                color:Colors.pink,
              ),
              child: const Icon(Icons.home)
            ),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_active),
            label: 'Profile',
            activeIcon: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Colors.pink,
                ),
                child: const Icon(Icons.notifications_active)
            ),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_active),
            label: 'Profile',
            activeIcon: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  color: Colors.pink,
                ),
                child: const Icon(Icons.notifications_active)
            ),
          ),
        ],
        currentIndex: mainScreenVm.selectedIndex,
        onTap: mainScreenVm.onItemTapped,
      ),
    );
  }
}
