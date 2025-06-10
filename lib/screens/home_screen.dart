import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:onnoon_app/screens/guide_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int score = 87;

  String getStatusMessage(int score) {
    if (score >= 80) return "눈 상태가 양호해요!";
    if (score >= 60) return "눈이 조금 피로해요.";
    return "눈이 많이 피로해요!";
  }

  String getEmoji(int score) {
    if (score >= 80) return "😊";
    if (score >= 60) return "😐";
    return "😫";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {
                  // TODO: 알림 설정 이동
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Onnoon 메뉴', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('홈'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.healing),
              title: Text('회복 가이드'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuideScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('기록'),
              onTap: () {
                // TODO: 기록 화면 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('설정'),
              onTap: () {
                // TODO: 설정 화면 이동
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Image.asset('assets/images/logo.png', height: 50),
            SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: score.toDouble(),
                          radius: 30,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          color: Colors.grey[200],
                          value: 100 - score.toDouble(),
                          radius: 30,
                          showTitle: false,
                        )
                      ],
                      startDegreeOffset: 180,
                      sectionsSpace: 0,
                      centerSpaceRadius: 70,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        getEmoji(score),
                        style: TextStyle(fontSize: 52),
                      ),
                      Text(
                        "$score점",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        getStatusMessage(score),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: 진단 화면으로 이동
              },
              child: Text("다시 진단하기"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "OOO 님의 피로도 수치가 감소하고 있습니다.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_box_outlined, color: Colors.blue),
                  onPressed: () {
                    // TODO: 진단 기록 화면으로 이동
                  },
                )
              ],
            ),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1000),
                        FlSpot(1, 1800),
                        FlSpot(2, 900),
                        FlSpot(3, 1500),
                        FlSpot(4, 400),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      dotData: FlDotData(show: false),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
