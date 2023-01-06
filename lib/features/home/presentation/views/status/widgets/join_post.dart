import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reach_me/core/components/custom_textfield.dart';

class JoinPost extends StatefulWidget {
  const JoinPost({Key? key}) : super(key: key);

  @override
  State<JoinPost> createState() => _JoinPostState();
}

class _JoinPostState extends State<JoinPost> {
  String channelName = "24e8c379-b56e-4ee5-b844-e584879f6d2a";
  String token = "0065741afe670ba4684aec914fb19eeb82aIABdbpSiC3EEGiH3lGk4fvYims28oXuwqPhIY2BW61vvdgOI38BbXy4UIgAbwog9cAeiYwQAAQCwXqFjAgCwXqFjAwCwXqFjBACwXqFj";

  int uid = 0; // uid of the local user
  String? appId;

  bool loadState = false;

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool _isHost = true; // Indicates whether the user has joined as a host
  late RtcEngine agoraEngine; // Agora engine instance

  // late RtcEngine _engine;
  // AgoraRtmClient? _client;
  // AgoraRtmChannel? _channel;
  var users = [];
  int _decideIndex = 0;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    //initializeAgora();
  }

  @override
  void dispose() {
    users.clear();
    users.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body: Stack(
          children: [
            loadState == true ?
            Text("waiting to create") :
            loadState == true ?
            GestureDetector(
                onTap: (){
                },
                child: Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                    ),
                    child: Center(child: _videoPanel()),
                  ),
                )
            ) :
            Container(),
            const SizedBox(height: 40),
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                        },
                        icon: Transform.scale(
                          scale: 1.8,
                          child: SvgPicture.asset(
                            'assets/svgs/dc-cancel.svg',
                            height: 71,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Container(
                        height: 60,
                        width: 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user.png"),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              children: const [
                                Text("Rooney Brown",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),),

                                Text("Abuja, Nigeria",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.white, fontSize: 13),),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 80,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text("Reach",
                                  style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      height: 80,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 3
                                )
                            ),
                            child: const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user.png"),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 3
                                  )
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 140,
                            child:  Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                "9 Reachers are active now",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ]),
            ),
            Positioned(
              top: 420,
              left: 0,
              right: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user.png"),
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("Raffinha",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 12
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Text("Go for it bro... the loading",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
            const SizedBox(height: 20),
          ]),
      bottomSheet:  Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 210,
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
                child: CustomRoundTextField(
                  verticalHeight: 20,
                  borderRadius: 30,
                  enabledBorderSide: BorderSide(
                    color: Colors.white,
                    width: 2
                  ),
                  fillColor: Colors.black.withOpacity(0.4),
                  hintStyle: TextStyle(color: Colors.white),
                  textStyle: TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.none,
                  hintText: "Comment",
                ),
              ),
              SizedBox(width: 15,),
              SvgPicture.asset(
                'assets/svgs/like.svg',
                height: 35,
                color: Colors.white,
                width: 20,
                // fit: BoxFit.contain,
              ),
              SizedBox(width: 10,),
              Icon(
                Icons.favorite_border,
                size: 35,
                color: Colors.white,
              )
            ]),
      ),
    );
  }
  Widget _videoPanel() {
    if (_isHost) {
      // Local user joined as a host
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      // Local user joined as audience
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      } else {
        return const Text(
          'Waiting for a host to join',
          textAlign: TextAlign.center,
        );
      }
    }
  }

}
