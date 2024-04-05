import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProgress extends StatefulWidget {
  const MyProgress({Key? key}) : super(key: key);

  @override
  State<MyProgress> createState() => _MyProgressState();
}

class _MyProgressState extends State<MyProgress> {
  Map<String, double> dataMap = {
    'Assigned': 0,
    'Completed': 0,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> tasksSnapshot =
      await FirebaseFirestore.instance.collection('tasks').get();

      int totalTasks = tasksSnapshot.docs.length;
      int completedTasks = tasksSnapshot.docs
          .where((task) => task.data()['completed'] == true)
          .toList()
          .length;

      setState(() {
        dataMap['Assigned'] = totalTasks.toDouble();
        dataMap['Completed'] = completedTasks.toDouble();
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/pro.jpg', // Adjust the path as per your project structure
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Content
          Column(
            children: [
              SizedBox(height: 50), // Adjust height as needed
              Text(
                'PROGRESS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Center(
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    initialAngleInDegree: 0,
                    chartType: ChartType.disc,
                    ringStrokeWidth: 32,
                    centerText: "Project Progress",
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: true,
                      showChartValueBackground: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 0, // Remove decimal places for whole numbers
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
