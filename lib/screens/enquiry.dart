import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:roccabox_admin/screens/enquiryDetail.dart';

import 'package:roccabox_admin/services/apiClient.dart';
import 'package:roccabox_admin/theme/constant.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Enquiry extends StatefulWidget {
  const Enquiry({Key? key}) : super(key: key);

  @override
  _EnquiryState createState() => _EnquiryState();
}

class _EnquiryState extends State<Enquiry> {
  bool remember = false;
  String selected = "first";
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Center(
            child: Text(
              "Enquiry",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  CustomBottomSheet();
                },
                icon: SvgPicture.asset(
                  "assets/filter1.svg",
                  width: 3.h,
                ))
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          controller: _controller,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                selected == "first"
                    ? AllEnquiryList()
                    : selected == "second"
                        ? AssignEnquiry()
                        : PendingRequest()
              ],
            ),
          ],
        ));
  }

  CustomBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                //Alll
                leading: Checkbox(
                    activeColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.w),
                          topRight: Radius.circular(1.w),
                          bottomLeft: Radius.circular(1.w),
                          bottomRight: Radius.circular(1.w)),
                    ),
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return kPrimaryColor;
                      }
                      return kPrimaryColor;
                    }),
                    value: selected == "first" ? true : false,
                    onChanged: (val) {
                      setState(() {
                        selected = "first";
                      }
                      );
                      Navigator.pop(context);
                    }),
                title: Text(
                  "All",
                  style: TextStyle(color: Colors.black),
                ),
                // onTap: () {
                //   Navigator.pop(context);
                // },
              ),
              ListTile(
                //Assigned
                leading: Checkbox(
                    activeColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.w),
                          topRight: Radius.circular(1.w),
                          bottomLeft: Radius.circular(1.w),
                          bottomRight: Radius.circular(1.w)),
                    ),
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return kPrimaryColor;
                      }
                      return kPrimaryColor;
                    }),
                    value: selected == "second" ? true : false,
                    onChanged: (val) {
                      setState(() {
                        selected = "second";
                      });
                      Navigator.pop(context);
                    }),
                title: Text(
                  "Assigned",
                  style: TextStyle(color: Colors.black),
                ),
                // onTap: () {
                //   Navigator.pop(context);
                // },
              ),
              ListTile(
                //Un Assigned
                leading: Checkbox(
                    activeColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.w),
                          topRight: Radius.circular(1.w),
                          bottomLeft: Radius.circular(1.w),
                          bottomRight: Radius.circular(1.w)),
                    ),
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return kPrimaryColor;
                      }
                      return kPrimaryColor;
                    }),
                    value: selected == "third" ? true : false,
                    onChanged: (val) {
                      setState(() {
                        selected = "third";
                      });
                      Navigator.pop(context);
                    }),
                title: Text(
                  "Un Assigned",
                  style: TextStyle(color: Colors.black),
                ),
                // onTap: () {
                //   Navigator.pop(context);
                // },
              ),
            ],
          );
        });
  }
}

class AssignEnquiry extends StatefulWidget {
  const AssignEnquiry({Key? key}) : super(key: key);

  @override
  _AssignEnquiryState createState() => _AssignEnquiryState();
}

class _AssignEnquiryState extends State<AssignEnquiry> {
  var name = "";
  var email = "";
  var phone = "";
  var image = "";
  var country_code = "";
  var user_image = "";
  var property_Rid = "";
  var message = "";

  bool isloading = false;

  @override
  void initState() {
    super.initState();

    getEnquiryApi();
  }

  List<GetEnquiry> apiList = [];

  ScrollController _controller = new ScrollController();

  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return 
     Container(
       child: Column(
         children: [

            Text(
              "Assigned Enquiry: "+ apiList.length.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),



           isloading
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  itemCount: apiList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnquiryDetails(

                                         name: apiList[index].name.toString(),
                                      email: apiList[index].email.toString(),
                                      phone: apiList[index].phone.toString(),
                                      country_code: apiList[index].country_code.toString(),
                                      image: apiList[index].image.toString(),
                                      message: apiList[index].message.toString(),
                                      property_Rid: apiList[index].property_Rid.toString(),
                                      user_image: apiList[index].user_image.toString(),


                                    )));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                            child: Container(
                                height: 34.h,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        image == null
                                            ? Container(
                                                height: 19.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6.w),
                                                        topRight:
                                                            Radius.circular(6.w)),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/property.jpeg"),
                                                        fit: BoxFit.fill)),
                                              )
                                            : Container(
                                                height: 19.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6.w),
                                                        topRight:
                                                            Radius.circular(6.w)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            apiList[index].image),
                                                        fit: BoxFit.fill)),
                                              )
                                      ],
                                    ),
                                    Positioned(
                                      left: 5.w,
                                      bottom: 8.h,
                                      child: FittedBox(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        height: 10.h,
                                        width: 10.h,
                                        child: user_image != null
                                            ?
                                            //user image

                                            CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    apiList[index]
                                                        .user_image
                                                        .toString()))
                                            : CircleAvatar(
                                                backgroundImage:
                                                    AssetImage("assets/image.jpeg"),
                                              ),
                                      )),
                                    ),
                                    // Positioned(
                                    //     left: 30.w,
                                    //     bottom: 15.5.h,
                                    //     child: Text(
                                    //       "Urbn Pacific Real Estate...",
                                    //       style: TextStyle(
                                    //           color: Colors.white,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 9.sp),
                                    //     )),
                                    Positioned(
                                        left: 29.w,
                                        bottom: 6.5.h,
                                        child: Container(
                                          width: 60.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // "Client Name",
                                                apiList[index].name.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp),
                                              ),
                                              Text(
                                                //email

                                                apiList[index].email.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11.sp),
                                              ),

                                              // SizedBox(width: 10.w,),

                                              Text(
                                                //phone no
                                                apiList[index].country_code.toString()+apiList[index].phone.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.sp),
                                              ),
                                            ],
                                          ),
                                        )),
                                    // Positioned(
                                    //     right: 2.w,
                                    //     bottom: 8.5.h,
                                    //     child: Text(

                                    //       //phone no
                                    //      apiList[index].phone.toString(),
                                    //       style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 11.sp),
                                    //     )),
                                    Positioned(
                                        left: 6.w,
                                        bottom: 1.h,
                                        child: Text(
//                                 """Lorem ipsum is simply dummy text of the
// printing and typecasting industry.""",
                                          apiList[index].message.toString(),

                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                        )),
                                    Positioned(
                                        top: 1.h,
                                        left: 3.5.w,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 4.h,
                                                width: 34.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.w),
                                                    color:
                                                        Colors.black.withOpacity(0.4),
                                                    border: Border.all(
                                                        color: kPrimaryColor)),
                                                child: Center(
                                                  child: Text(
                                                    "Ref. " +
                                                        apiList[index]
                                                            .property_Rid
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                //customDialog();
                                              },
                                              child: Container(
                                                height: 4.h,
                                                width: 34.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.w),
                                                    color: kGreenColor),
                                                child: Center(
                                                  child: Text(
                                                    "Assigned",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                ),
         ],
       ),
     );
  }

  Future<dynamic> getEnquiryApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print(id.toString());
    setState(() {
      isloading = true;
    });
    // print(email);
    // print(password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var jsonArray;
    var request = http.get(
      Uri.parse(RestDatasource.GETENQUIRYLIST_URL +
          "admin_id=" +
          id.toString() +
          "&status=Assign"),
    );

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        // apiAgentList.clear();

        for (var i = 0; i < jsonArray.length; i++) {
          GetEnquiry modelAgentSearch = new GetEnquiry();
          modelAgentSearch.name = jsonArray[i]["name"];
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.email = jsonArray[i]["email"].toString();
          modelAgentSearch.phone = jsonArray[i]["phone"].toString();
          modelAgentSearch.image = jsonArray[i]["image"].toString();
          modelAgentSearch.country_code =
              jsonArray[i]["country_code"].toString();
          modelAgentSearch.user_image = jsonArray[i]["user_image"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.property_Rid =
              jsonArray[i]["property_Rid"].toString();

          print("id: " + modelAgentSearch.id.toString());

          apiList.add(modelAgentSearch);
        }

        setState(() {
          isloading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }
}

class PendingRequest extends StatefulWidget {
  const PendingRequest({Key? key}) : super(key: key);

  @override
  _PendingRequestState createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest> {
  var name = "";
  var email = "";
  var phone = "";
  var image = "";
  var country_code = "";
  var user_image = "";
  var property_Rid = "";
  var message = "";
  String? _chosenValue;
  String selecteEmail = "";
  String selectedPhone = "";
  String selectedEnquiryId = "";
  String selectedAgent = "";
  bool isloading = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  List<TotalAgentListApi> apiList = [];

  List<String> all = [];

  void allData() {
    for (var i = 0; i < apiList.length; i++) {
      all.add(apiList[i].name.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    pendingEnquiryApi();
    agentListApi();
  }

  List<PendingEnquiry> pendingApiList = [];

  bool remember = false;

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return 
    
    
    
    Container(
      child: Column(
        children: [

          Text(
              "Total Pending Request: "+ pendingApiList.length.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),
          isloading
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  itemCount: pendingApiList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnquiryDetails(
                                      name: pendingApiList[index].name.toString(),
                                      email: pendingApiList[index].email.toString(),
                                      phone: pendingApiList[index].phone.toString(),
                                      country_code: pendingApiList[index].country_code.toString(),
                                      image: pendingApiList[index].image.toString(),
                                      message: pendingApiList[index].message.toString(),
                                      property_Rid: pendingApiList[index].property_Rid.toString(),
                                      user_image: pendingApiList[index].user_image.toString(),
                                    )));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                            child: Container(
                                height: 34.h,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        image == null
                                            ? Container(
                                                height: 19.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6.w),
                                                        topRight:
                                                            Radius.circular(6.w)),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/property.jpeg"),
                                                        fit: BoxFit.fill)),
                                              )
                                            : Container(
                                                height: 19.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6.w),
                                                        topRight:
                                                            Radius.circular(6.w)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            pendingApiList[index]
                                                                .image),
                                                        fit: BoxFit.fill)),
                                              )
                                      ],
                                    ),
                                    Positioned(
                                      left: 5.w,
                                      bottom: 8.h,
                                      child: FittedBox(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        height: 10.h,
                                        width: 10.h,
                                        child: user_image != null
                                            ?
                                            //user image

                                            CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    pendingApiList[index]
                                                        .user_image
                                                        .toString()))
                                            : CircleAvatar(
                                                backgroundImage:
                                                    AssetImage("assets/image.jpeg"),
                                              ),
                                      )),
                                    ),
                                    // Positioned(
                                    //     left: 30.w,
                                    //     bottom: 15.5.h,
                                    //     child: Text(
                                    //       "Urbn Pacific Real Estate...",
                                    //       style: TextStyle(
                                    //           color: Colors.white,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 9.sp),
                                    //     )),
                                    Positioned(
                                        left: 29.w,
                                        bottom: 6.5.h,
                                        child: Container(
                                          width: 60.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // "Client Name",
                                                pendingApiList[index].name.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp),
                                              ),
                                              Text(
                                                //email

                                                pendingApiList[index]
                                                    .email
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11.sp),
                                              ),

                                              // SizedBox(width: 10.w,),

                                              Text(
                                                //phone no
                                                pendingApiList[index].country_code.toString()+pendingApiList[index]
                                                    .phone
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.sp),
                                              ),
                                            ],
                                          ),
                                        )),
                                    // Positioned(
                                    //     right: 2.w,
                                    //     bottom: 8.5.h,
                                    //     child: Text(

                                    //       //phone no
                                    //      apiList[index].phone.toString(),
                                    //       style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 11.sp),
                                    //     )),
                                    Positioned(
                                        left: 6.w,
                                        bottom: 1.h,
                                        child: Text(
//                                 """Lorem ipsum is simply dummy text of the
// printing and typecasting industry.""",
                                          pendingApiList[index].message.toString(),

                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                        )),
                                    Positioned(
                                        top: 1.h,
                                        left: 3.5.w,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 4.h,
                                                width: 34.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.w),
                                                    color:
                                                        Colors.black.withOpacity(0.4),
                                                    border: Border.all(
                                                        color: kPrimaryColor)),
                                                child: Center(
                                                  child: Text(
                                                    "Ref. " +
                                                        pendingApiList[index]
                                                            .property_Rid
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                selectedEnquiryId = pendingApiList[index].id;
                                                customDialog(index);
                                              },
                                              child: Container(
                                                height: 4.h,
                                                width: 34.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.w),
                                                    color: kPrimaryColor),
                                                child: Center(
                                                  child: Text(
                                                    "Assign this Lead",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }

  customDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          title: SingleChildScrollView(
            child: Container(
              //width: MediaQuery.of(context).size.width*.60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assign Lead',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 7.w,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.1.h,
                    width: double.infinity,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Name',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)),
                  ),
                  InkWell(

                      onTap: () {
                        print("Hello World");
                        SelectDialog.showModal<TotalAgentListApi>(
                          context,
                          label: "Please select an agent",
                          items: apiList,
                          showSearchBox: false,
                          itemBuilder: (BuildContext context,
                              TotalAgentListApi item, bool isSelected) {
                            return Container(
                              decoration: !isSelected
                                  ? null
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                              child: InkWell(
                                onTap: () {
                                  selectedAgent = item.id;


                                  setState(() {
                                    nameController.text = item.name.toString();

                                    //   serviceController.text = "";
                                    emailController.text =
                                        item.email.toString();

                                    phoneController.text =
                                        item.phone.toString();

                                    // isLoading = true;
                                    //  personalInfoPresenter.getSubCat(catId.toString());
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: ListTile(
                                  leading: item.name == null
                                      ? null
                                      : Text(
                                          item.name.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),

                                
                                  selected: isSelected,
                                ),
                              ),
                            );
                          },
                         
                        );
                      },
                      child: Container(
                        height: 5.h,
                        child: TextField(
                          enabled: false,
                          controller: nameController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 8.w,
                              ),
                              hintText: "Agent's Name",
                              hintStyle: TextStyle(fontSize: 9.sp),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      )),





                  SizedBox(
                    height: 1.h,
                  ),

                  Text(
                    'Email Address',
                    style: TextStyle(
                      
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)),
                  ),
                  Container(
                    height: 5.h,
                    child: TextField(
                      controller: emailController,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "email@gmail.com",
                          hintStyle: TextStyle(fontSize: 9.sp),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'Mobile Number',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)),
                  ),
                  Container(
                    height: 5.h,
                    child: TextField(
                      controller: phoneController,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText:"987654321",
                          hintStyle: TextStyle(fontSize: 9.sp),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.w))),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      assignData();
                    },
                    child: Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Color(0xffFFBA00),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Center(
                        child: Text(
                          'Assign Agent',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


   Future<dynamic> assignData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");

    print("id Print: " + id.toString());
    print("agentId: " +selectedAgent.toString());
    print("enquiryId: "+ selectedEnquiryId.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.ENQUIRYASSIGN_URL,
        ),
        body: {
          "agent_id": selectedAgent.toString(),
          "enquiry_id": selectedEnquiryId.toString(),
          "admin_id" : id.toString()
          //"enquiry_id": 
        });

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });
        Navigator.pop(this.context);
        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
            pendingEnquiryApi();
            
       // agentListApi();
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(this.context)
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }











  Future<dynamic> agentListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print(id.toString());
    setState(() {
      isloading = true;
    });
    // print(email);
    // print(password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var jsonArray;
    var request = http.get(
      Uri.parse(
          RestDatasource.TOTALAGENTLIST_URL + "admin_id=" + id.toString()),
    );

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        apiList.clear();

        for (var i = 0; i < jsonArray.length; i++) {
          TotalAgentListApi modelSearch = new TotalAgentListApi();
          modelSearch.name = jsonArray[i]["name"];
          modelSearch.id = jsonArray[i]["id"].toString();
          modelSearch.email = jsonArray[i]["email"].toString();
          modelSearch.phone = jsonArray[i]["phone"].toString();
          modelSearch.image = jsonArray[i]["image"].toString();
          modelSearch.country_code = jsonArray[i]["country_code"].toString();

         // print("name: " + modelSearch.id.toString());

          apiList.add(modelSearch);
        }
        allData();

        setState(() {
          isloading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }

  Future<dynamic> pendingEnquiryApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print(id.toString());
    setState(() {
      isloading = true;
    });
    // print(email);
    // print(password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var jsonArray;
    var request = http.get(
      Uri.parse(RestDatasource.GETENQUIRYLIST_URL +
          "admin_id=" +
          id.toString() +
          "&status=Pending"),
    );

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        pendingApiList.clear();

        for (var i = 0; i < jsonArray.length; i++) {
          PendingEnquiry modelAgentSearch = new PendingEnquiry();
          modelAgentSearch.name = jsonArray[i]["name"];
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.user_id = jsonArray[i]["user_id"].toString();
          modelAgentSearch.email = jsonArray[i]["email"].toString();
          modelAgentSearch.phone = jsonArray[i]["phone"].toString();
          modelAgentSearch.image = jsonArray[i]["image"].toString();
          modelAgentSearch.country_code =
              jsonArray[i]["country_code"].toString();
          modelAgentSearch.user_image = jsonArray[i]["user_image"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.property_Rid =
              jsonArray[i]["property_Rid"].toString();

          print("id: " + modelAgentSearch.id.toString());
          print("userId: "+modelAgentSearch.user_id.toString());

          pendingApiList.add(modelAgentSearch);
        }

        setState(() {
          isloading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }
}


























class AllEnquiryList extends StatefulWidget {
  const AllEnquiryList({Key? key}) : super(key: key);

  @override
  _AllEnquiryListState createState() => _AllEnquiryListState();
}

class _AllEnquiryListState extends State<AllEnquiryList> {
  var name = "";
  var email = "";
  var phone = "";
  var image = "";
  var country_code = "";
  var user_image = "";
  var property_Rid = "";
  var message = "";
  var q_status = "";

  String selecteEmail = "";
  String selectedPhone = "";
  String selectedEnquiryId = "";
  String selectedAgent = "";
  

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  bool isloading = false;
  List<TotalAgentListApi> apiList = [];

  @override
  void initState() {
    super.initState();
    allEnquiryApi();

    agentListApi();

    
  }

  List<AllEnquiry> allApiList = [];

    List<String> all = [];

  void allData() {
    for (var i = 0; i < allApiList.length; i++) {
      all.add(allApiList[i].name.toString());
    }
  }

  bool remember = false;

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      child: Column(
        children: [

           Text(
              "All Enquiry: "+ allApiList.length.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp),
            ),

          


          isloading
              ? Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  itemCount: allApiList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnquiryDetails(

                                         name: allApiList[index].name.toString(),
                                      email: allApiList[index].email.toString(),
                                      phone: allApiList[index].phone.toString(),
                                      country_code: allApiList[index].country_code.toString(),
                                      image: allApiList[index].image.toString(),
                                      message: allApiList[index].message.toString(),
                                      property_Rid: allApiList[index].property_Rid.toString(),
                                      user_image: allApiList[index].user_image.toString(),





                                    )));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                            child: Container(
                                height: 34.h,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        image == null
                                            ? Container(
                                                height: 19.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6.w),
                                                        topRight:
                                                            Radius.circular(6.w)),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/property.jpeg"),
                                                        fit: BoxFit.fill)),
                                              )
                                            : Container(
                                                height: 19.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(6.w),
                                                        topRight:
                                                            Radius.circular(6.w)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            allApiList[index].image),
                                                        fit: BoxFit.fill)),
                                              )
                                      ],
                                    ),
                                    Positioned(
                                      left: 5.w,
                                      bottom: 8.h,
                                      child: FittedBox(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        height: 10.h,
                                        width: 10.h,
                                        child: user_image != null
                                            ?
                                            //user image

                                            CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    allApiList[index]
                                                        .user_image
                                                        .toString()))
                                            : CircleAvatar(
                                                backgroundImage:
                                                    AssetImage("assets/image.jpeg"),
                                              ),
                                      )),
                                    ),
                                  
                                    Positioned(
                                        left: 29.w,
                                        bottom: 6.5.h,
                                        child: Container(
                                          width: 60.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                // "Client Name",
                                                allApiList[index].name.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.sp),
                                              ),
                                              Text(
                                                //email

                                                allApiList[index].email.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11.sp),
                                              ),

                                              // SizedBox(width: 10.w,),

                                              Text(
                                                //phone no
                                                allApiList[index].country_code.toString()+allApiList[index].phone.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.sp),
                                              ),
                                            ],
                                          ),
                                        )),
                                    // Positioned(
                                    //     right: 2.w,
                                    //     bottom: 8.5.h,
                                    //     child: Text(

                                    //       //phone no
                                    //      apiList[index].phone.toString(),
                                    //       style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.w500,
                                    //           fontSize: 11.sp),
                                    //     )),
                                    Positioned(
                                        left: 6.w,
                                        bottom: 1.h,
                                        child: Text(
//                                 """Lorem ipsum is simply dummy text of the
// printing and typecasting industry.""",
                                          allApiList[index].message.toString(),

                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                        )),
                                    Positioned(
                                        top: 1.h,
                                        left: 3.5.w,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 4.h,
                                                width: 34.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.w),
                                                    color:
                                                        Colors.black.withOpacity(0.4),
                                                    border: Border.all(
                                                        color: kPrimaryColor)),
                                                child: Center(
                                                  child: Text(
                                                    "Ref. " +
                                                        allApiList[index]
                                                            .property_Rid
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (allApiList[index].q_status ==
                                                    "Pending") {
                                                  customDialog(index);
                                                }

                                                //customDialog();
                                              },
                                              child: Container(
                                                height: 4.h,
                                                width: 34.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5.w),
                                                    color:
                                                        allApiList[index].q_status ==
                                                                "Pending"
                                                            ? kPrimaryColor
                                                            : kGreenColor),
                                                child: Center(
                                                  child: allApiList[index].q_status ==
                                                          "Pending"
                                                      ? Text(
                                                          "Assign this Lead",
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: Colors.white),
                                                        )
                                                      : Text(
                                                          "Assigned",
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color: Colors.white),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }

  customDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
          title: SingleChildScrollView(
            child: Container(
              //width: MediaQuery.of(context).size.width*.60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assign Lead',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 7.w,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.1.h,
                    width: double.infinity,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Name',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)),
                  ),
                  InkWell(

                      onTap: () {
                        print("Hello World");
                        SelectDialog.showModal<TotalAgentListApi>(
                          context,
                          label: "Please select an agent",
                          items: apiList,
                          showSearchBox: false,
                          itemBuilder: (BuildContext context,
                              TotalAgentListApi item, bool isSelected) {
                            return Container(
                              decoration: !isSelected
                                  ? null
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                              child: InkWell(
                                onTap: () {
                                  selectedAgent = item.id;


                                  setState(() {
                                    nameController.text = item.name.toString();

                                    //   serviceController.text = "";
                                    emailController.text =
                                        item.email.toString();

                                    phoneController.text =
                                        item.phone.toString();

                                    // isLoading = true;
                                    //  personalInfoPresenter.getSubCat(catId.toString());
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: ListTile(
                                  leading: item.name == null
                                      ? null
                                      : Text(
                                          item.name.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),

                                
                                  selected: isSelected,
                                ),
                              ),
                            );
                          },
                         
                        );
                      },
                      child: Container(
                        height: 5.h,
                        child: TextField(
                          enabled: false,
                          controller: nameController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                size: 8.w,
                              ),
                              hintText: "Agent's Name",
                              hintStyle: TextStyle(fontSize: 9.sp),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      )),





                  SizedBox(
                    height: 1.h,
                  ),

                  Text(
                    'Email Address',
                    style: TextStyle(
                      
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)),
                  ),
                  Container(
                    height: 5.h,
                    child: TextField(
                      controller: emailController,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "email@gmail.com",
                          hintStyle: TextStyle(fontSize: 9.sp),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'Mobile Number',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)),
                  ),
                  Container(
                    height: 5.h,
                    child: TextField(
                      controller: phoneController,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText:"987654321",
                          hintStyle: TextStyle(fontSize: 9.sp),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.w))),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      assignData();
                    },
                    child: Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Color(0xffFFBA00),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Center(
                        child: Text(
                          'Assign Agent',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

 











   Future<dynamic> assignData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");

    print("id Print: " + id.toString());
    print("agentId: " +selectedAgent.toString());
    print("enquiryId: "+ selectedEnquiryId.toString());
    setState(() {
      isloading = true;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.ENQUIRYASSIGN_URL,
        ),
        body: {
          "agent_id": selectedAgent.toString(),
          "enquiry_id": selectedEnquiryId.toString(),
          "admin_id" : id.toString()
          
        });

    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
    });

    if (res.statusCode == 200) {
      print(jsonRes["status"]);

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });
        Navigator.pop(this.context);
        ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
            allEnquiryApi();
            
       // agentListApi();
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(this.context)
            .showSnackBar(SnackBar(content: Text("Please try leter")));
      });
    }
  }








    Future<dynamic> allEnquiryApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print(id.toString());
    setState(() {
      isloading = true;
    });
    // print(email);
    // print(password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var jsonArray;
    var request = http.get(
      Uri.parse(RestDatasource.GETENQUIRYLIST_URL +
          "admin_id=" +
          id.toString() +
          "&status=all"),
    );

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
         allApiList.clear();

        for (var i = 0; i < jsonArray.length; i++) {
          AllEnquiry modelAgentSearch = new AllEnquiry();
          modelAgentSearch.name = jsonArray[i]["name"];
          modelAgentSearch.id = jsonArray[i]["id"].toString();
          modelAgentSearch.email = jsonArray[i]["email"].toString();
          modelAgentSearch.phone = jsonArray[i]["phone"].toString();
          modelAgentSearch.image = jsonArray[i]["image"].toString();
          modelAgentSearch.country_code =
              jsonArray[i]["country_code"].toString();
          modelAgentSearch.user_image = jsonArray[i]["user_image"].toString();
          modelAgentSearch.message = jsonArray[i]["message"].toString();
          modelAgentSearch.property_Rid =
              jsonArray[i]["property_Rid"].toString();
          modelAgentSearch.q_status = jsonArray[i]["q_status"].toString();

          print("status: " + modelAgentSearch.q_status.toString());

          allApiList.add(modelAgentSearch);
        }

        setState(() {
          isloading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }


















 Future<dynamic> agentListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print(id.toString());
    setState(() {
      isloading = true;
    });
    // print(email);
    // print(password);
    String msg = "";
    var jsonRes;
    http.Response? res;
    var jsonArray;
    var request = http.get(
      Uri.parse(
          RestDatasource.TOTALAGENTLIST_URL + "admin_id=" + id.toString()),
    );

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });
    if (res!.statusCode == 200) {
      if (jsonRes["status"] == true) {
        apiList.clear();

        for (var i = 0; i < jsonArray.length; i++) {
          TotalAgentListApi modelSearch = new TotalAgentListApi();
          modelSearch.name = jsonArray[i]["name"];
          modelSearch.id = jsonArray[i]["id"].toString();
          modelSearch.email = jsonArray[i]["email"].toString();
          modelSearch.phone = jsonArray[i]["phone"].toString();
          modelSearch.image = jsonArray[i]["image"].toString();
          modelSearch.country_code = jsonArray[i]["country_code"].toString();

         // print("name: " + modelSearch.id.toString());

          apiList.add(modelSearch);
        }
        allData();

        setState(() {
          isloading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text('Error while fetching data')));

      setState(() {
        isloading = false;
      });
    }
  }


















 
}

class GetEnquiry {
  var user_id = "";
  var user_image = "";
  var id = "";
  var role_id = "";
  var name = "";
  var email = "";
  var country_code = "";
  var phone = "";
  var image = "";
  var email_verified_at = "";
  var password = "";
  var firebase_token = "";
  var status = "";
  var created_at = "";
  var updated_at = "";
  var property_Rid = "";
  var filter_id = "";
  var message = "";
  var q_status = "";
}

class PendingEnquiry {
  var user_id = "";
  var user_image = "";
  var id = "";
  var role_id = "";
  var name = "";
  var email = "";
  var country_code = "";
  var phone = "";
  var image = "";
  var email_verified_at = "";
  var password = "";
  var firebase_token = "";
  var status = "";
  var created_at = "";
  var updated_at = "";
  var property_Rid = "";
  var filter_id = "";
  var message = "";
  var q_status = "";
}

class AllEnquiry {
  var user_id = "";
  var user_image = "";
  var id = "";
  var role_id = "";
  var name = "";
  var email = "";
  var country_code = "";
  var phone = "";
  var image = "";
  var email_verified_at = "";
  var password = "";
  var firebase_token = "";
  var status = "";
  var created_at = "";
  var updated_at = "";
  var property_Rid = "";
  var filter_id = "";
  var message = "";
  var q_status = "";
}


class TotalAgentListApi {
  var id = "";
  var name = "";
  var email = "";
  var phone = "";
  var image = "";
  var country_code = "";
  
}