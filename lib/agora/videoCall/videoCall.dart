
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:roccabox_admin/agora/component/roundedButton.dart';
import 'package:roccabox_admin/screens/homenave.dart';

import '../callModel.dart';
import '../constants.dart';


class VideoCall extends StatefulWidget {
  var token, channel, senderId,name, image, myId, time;
  VideoCall({Key? key, this.token, this.channel, this.name,this.senderId, this.image, this.myId, this.time}):super(key:key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool visibility = false;
  bool isMute = false;
  bool isSpeakerOn = false;
  final firestoreInstance = FirebaseFirestore.instance;
  String? status ;
  String? cam = "front";
  var isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async{

      setState(() {
        isLoading = false;
      });

    });
    initAgora();
  }


  @override
  void dispose() {
    _engine.destroy();
    super.dispose();
  }


  Future<void> initAgora() async {
    Future.delayed(Duration(seconds: 15), () async{
      if(_localUserJoined==false){
        _engine.leaveChannel();
        _engine.destroy();
        Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomeNav()),(r)=> false);

      }

    });
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
            visibility = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          visibility = true;
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;

          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomeNav()),(r)=> false);
          _engine.destroy();
          setState(() {
            _remoteUid = null;
            visibility = false;
          });
        },
        leaveChannel: (RtcStats reason) {
          print("remote user left channel");
          Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomeNav()),(r)=> false);

          _engine.destroy();
          //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> HomeNav()));


        },
      ),
    );

    await _engine.joinChannel(widget.token, widget.channel, null, 0);
  }
  void updateChatHead(String senderID, String time, String status) async {
    Map<String, String> map = new Map();
    map["status"] = "end";
    FirebaseFirestore.instance
        .collection('call_master')
        .doc("call_head")
        .collection(widget.myId)
        .doc(time).update(map).then((value) {
      FirebaseFirestore.instance
          .collection("call_master")
          .doc("call_head")
          .collection(widget.senderId)
          .doc(widget.time)
          .update(map);
    });



  }
  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {


    print("ISMute "+isMute.toString());
    print("Id "+widget.myId.toString());
    print("time "+widget.time.toString());
    return Scaffold(
      body: isLoading== true?Center(child: CircularProgressIndicator(),): StreamBuilder<DocumentSnapshot>(

        stream: firestoreInstance
            .collection("call_master")
            .doc("call_head")
            .collection(widget.myId)
            .doc(widget.time)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasData){
            status = snapshot.data!.get("status").toString();
            if(status.toString()!="null"){
              if(status.toString()=="end"){
                _engine.leaveChannel();
                _engine.destroy();
                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomeNav()),(r)=> false);

              }
            }
          }
          return Stack(
            children: [
              Center(
                child: _remoteVideo(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? RtcLocalView.SurfaceView()
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
              Visibility(
                visible: visibility,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedButton(
                        press: () {
                          setState(() {

                            if(isMute==true){
                              _engine.muteLocalAudioStream(false);
                              isMute = false;
                            }else{
                              _engine.muteLocalAudioStream(true);
                              isMute = true;
                            }
                          });
                        },
                          iconSrc:"assets/mute.svg",
                          color:isMute?kRedColor:Colors.white,
                          iconColor: isMute?Colors.white:kRedColor

                      ),


                      RoundedButton(
                        press: () {
                          setState(() {
                            _engine.leaveChannel();
                            _engine.destroy();
                            updateChatHead(widget.senderId,widget.time, "end");
                            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context)=> HomeNav()),(r)=> false);

                          });
                        },
                        color: kRedColor,
                        iconColor: Colors.white,
                        iconSrc: "assets/call_end.svg",
                      ),
/*
                      RoundedButton(
                        press: () {
                          _engine.isSpeakerphoneEnabled().then((value){
                            print(value.toString());
                            setState(() {
                              if(value.toString()=="true"){
                                _engine.setEnableSpeakerphone(false);
                                isSpeakerOn =false;
                              }else{
                                _engine.setEnableSpeakerphone(true);
                                isSpeakerOn = true;
                              }
                            });

                          });
                        },
                        iconSrc: !isSpeakerOn? "assets/Icon Volume.svg":"assets/speaker_off.svg",
                      ),
*/


                      RoundedButton(
                        press: () {
                          setState(() {
                            if (cam.toString() == "front") {
                              _engine.switchCamera();
                              cam = "rear";
                            } else {
                              _engine.switchCamera();
                              cam = "front";
                            }
                          });
                        },
                        iconSrc:"assets/switch-camera.svg",
                          color: cam=="front"?kRedColor:Colors.white,
                          iconColor: cam=="front"?Colors.white:kRedColor
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!);
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }




}