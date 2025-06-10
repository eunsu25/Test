import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Duration focusDuration = Duration(minutes: 25);
  Duration breakDuration = Duration(minutes: 5);
  Duration remainingTime = Duration(minutes: 25);
  Timer? timer;
  bool isRunning = false;
  bool isBreak = false;
  int sessionCount = 0;
  int totalSessions = 4;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        setState(() {
          isBreak = !isBreak;
          sessionCount += isBreak ? 0 : 1;
          remainingTime = isBreak ? breakDuration : focusDuration;
          isRunning = false;
        });
      }
    });
  }

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
    } else {
      startTimer();
    }
    setState(() {
      isRunning = !isRunning;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isBreak = false;
      sessionCount = 0;
      remainingTime = focusDuration;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('맞춤형 회복 가이드', style: TextStyle(color: Colors.black)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: '스트레칭'),
            Tab(text: '휴식 타이머'),
            Tab(text: '제품 추천'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildStretchingTab(),
          buildTimerTab(),
          buildProductTab(),
        ],
      ),
    );
  }

  Widget buildStretchingTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('눈 건강 스트레칭', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('OOO 님의 눈 건강을 위한 회복 스트레칭이에요.'),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildStretchCard(Icons.remove_red_eye, '눈 스트레칭', 'https://www.youtube.com/shorts/12rwPVGHxmw'),
                SizedBox(width: 16),
                buildStretchCard(Icons.spa, '눈 마사지', 'https://www.youtube.com/shorts/2oojWWfappA'),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text('눈 관련 영상', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('눈 건강을 위해 몇 가지 영상을 추천해드려요.'),
          SizedBox(height: 16),
          Column(
            children: [
              buildVideoCard(Icons.description, '눈 건강 테스트', '3분짜리 눈 건강 테스트로 시작해요.', 'https://www.6eye.co.kr/html/main.php?sc_etp_mmbr_seq=1'),
              buildVideoCard(Icons.local_dining, '눈 건강에 좋은 음식', '눈 건강에 좋은 음식에 대해 알아봐요.', 'https://newtreemall.co.kr/magazine/view?id=custom_bbs2&seq=144598'),
              buildVideoCard(Icons.medical_services, '눈 건강에 좋은 영양제', '영양제를 소개해드릴게요.', 'https://www.youtube.com/watch?app=desktop&v=cfelCf2U018&t=22s'),
            ],
          )
        ],
      ),
    );
  }

  Widget buildStretchCard(IconData icon, String title, String url) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _launchURL(url),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('시작'),
          )
        ],
      ),
    );
  }

  Widget buildVideoCard(IconData icon, String title, String description, String url) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _launchURL(url),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('시작'),
          )
        ],
      ),
    );
  }

  Widget buildTimerTab() {
    double percent = isBreak
        ? 1 - (remainingTime.inSeconds / breakDuration.inSeconds)
        : 1 - (remainingTime.inSeconds / focusDuration.inSeconds);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isBreak ? '휴식 중입니다' : '집중 시간입니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 12.0,
            percent: percent.clamp(0.0, 1.0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatDuration(remainingTime),
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text("${sessionCount} of $totalSessions sessions")
              ],
            ),
            progressColor: Colors.green,
            backgroundColor: Colors.grey.shade300,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                iconSize: 48,
                color: Colors.blue,
                onPressed: toggleTimer,
              ),
              SizedBox(width: 24),
              IconButton(
                icon: Icon(Icons.refresh),
                iconSize: 48,
                color: Colors.grey,
                onPressed: resetTimer,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildProductTab() {
    final products = [
      {
        'image': 'assets/images/eyedrop.jpg',
        'name': '인공눈물',
        'desc': '건조한 눈에 수분을 공급하는 필수템',
        'price': '₩5,500',
        'url': 'https://jw-pharma.co.kr/mobile/pharma/ko/product/m_brand_friends.jsp'
      },
      {
        'image': 'assets/images/hotpack.jpg',
        'name': '눈 찜질팩',
        'desc': '눈의 피로를 풀어주는 온열 찜질',
        'price': '₩13,330',
        'url': 'https://www.coupang.com/vp/products/7525139111?itemId=19745166137&vendorItemId=86767356126&q=%EB%88%88+%EC%98%A8+%EC%B0%9C%EC%A7%88%ED%8C%A9&searchId=92a20c514197992&sourceType=search&itemsCount=36&searchRank=1&rank=1'
      },
      {
        'image': 'assets/images/supplement.jpg',
        'name': '눈 영양제',
        'desc': '루테인과 오메가3 함유',
        'price': '₩11,800',
        'url': 'https://m.dailyone.co.kr/product/%EB%8D%B0%EC%9D%BC%EB%A6%AC%EC%9B%90-%EB%88%88%EC%97%90-%EC%A2%8B%EC%9D%80-%EB%A3%A8%ED%85%8C%EC%9D%B8-%EC%97%90%EC%9D%B4%EC%8A%A4-%EB%88%88-%EC%98%81%EC%96%91%EC%A0%9C-%EB%B2%A0%ED%83%80%EC%B9%B4%EB%A1%9C%ED%8B%B4-600mg-x-60%EC%BA%A1%EC%8A%90-1%ED%86%B5/116/'
      },
      {
        'image': 'assets/images/blueberry.jpg',
        'name': '블루베리즙',
        'desc': '항산화 효과로 눈 건강에 도움',
        'price': '₩85,000',
        'url': 'https://gwgoods.com/goods/view?no=29533'
      },
      {
        'image': 'assets/images/glasses.jpg',
        'name': '차단 안경',
        'desc': '블루라이트 차단 보호 안경',
        'price': '₩225,000',
        'url': 'https://prod.danawa.com/info/?pcode=13049570'
      }
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => _launchURL(product['url']!),
          child: Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(product['image']!, height: 120, fit: BoxFit.contain),
                  SizedBox(height: 8),
                  Text(product['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(product['desc']!),
                  SizedBox(height: 4),
                  Text(product['price']!, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
