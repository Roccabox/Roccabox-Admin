import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:roccabox_admin/screens/addUser.dart';
import 'package:roccabox_admin/screens/editUser.dart';

import 'package:roccabox_admin/theme/constant.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_switch/flutter_switch.dart';

class TotalUserList extends StatefulWidget {
  @override
  _TotalState createState() => _TotalState();
}

class _TotalState extends State<TotalUserList> {
ScrollController _controller = new ScrollController();
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Users List",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser()));
            },
            child: Container(
              margin: EdgeInsets.only(top: .5.h, right: 1.h, bottom: .5.h),
              height: 5.h,
              width: 20.w,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(2.w)),
              child: Center(
                child: Text("Add User",
                    style: TextStyle(fontSize: 9.sp, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
      body: SizerUtil.deviceType == DeviceType.mobile
          ? ListView(
            shrinkWrap: true,
            controller: _controller,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 7.h,
                      child: TextFormField(
                        validator: (val) {},
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              size: 8.w,
                            ),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.w),
                                borderSide: BorderSide(color: Colors.grey)),
                            labelStyle: TextStyle(
                                fontSize: 15, color: Color(0xff000000))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "Total User: 2244",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),



                  ListView.builder(
                    shrinkWrap: true,
                     controller: _controller,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            ListTile(
                    leading: CircleAvatar(
                              maxRadius: 9.w,
                              child: Image.asset("assets/Avatar.png")),
                    title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Testing User",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "test@gmail.com",
                                style:
                                    TextStyle(fontSize: 8.sp, color: Colors.grey),
                              ),
                              Text(
                                "9876543210",
                                style:
                                    TextStyle(fontSize: 8.sp, color: Colors.grey),
                              ),
                            ],
                    ),
                    trailing: Column(
                            children: [
                              
                              Row(
                               mainAxisSize: MainAxisSize.min,
                               
                               
                                children: [
                                   InkWell(
                                     onTap: () {},

                                    child: Image.asset("assets/comment.png",
                                    width: 6.w,
                                    
                                    ),
                                  ),
                                   
                                   SizedBox(width: 1.w,),
                                  InkWell(
                                     onTap: () {},

                                    child: Image.asset("assets/callicon.png",
                                    width: 6.w,
                                    
                                    ),
                                  ),
                                   
                                   SizedBox(width: 1.w,),
                                 InkWell(
                                     onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser()));
                                     },

                                    child: Image.asset("assets/edit.png",
                                    width: 6.w,
                                    
                                    ),
                                  ),
                                   
                                   SizedBox(width: 1.w,),
                                  InkWell(
                                     onTap: () {
                                      
                                     },

                                    child: Image.asset("assets/delete.png",
                                    width: 6.w,
                                    
                                    ),
                                  ),
                                   
                                   SizedBox(width: 1.w,),
                                ],
                              ),
                             //customSwitch()
                            ],
                    ),
                  ),

                  SizedBox(height: 1.5.h,),

                  Container(
                    width: double.infinity,
                    height: 0.1.h,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 1.5.h,),


                          ],
                        ),
                      );
                    },
                  ),
                  
                ],
              ),
            ],
            
          )
          : Container(
              // Widget for Tablet
              width: 100.w,
              height: 12.5.h,
            ),
    );
  }

  customSwitch() {
    return Container(
      
          child: FlutterSwitch(
            width: 125.0,
            height: 50.0,
            valueFontSize: 25.0,
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
            toggleSize: 35.0,
            value: status,
            borderRadius: 20.0,
            
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                status = val;
              });
            },
          ),
        );
  }
}
