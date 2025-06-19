import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:tacgportal/data/models/tacg_event.dart';
import 'package:tacgportal/ui/widgets/Statistics/functions.dart';

class AggregateAttendance extends StatefulWidget {
  const AggregateAttendance({super.key});

  @override
  State<AggregateAttendance> createState() => _AggregateAttendanceState();
}

class _AggregateAttendanceState extends State<AggregateAttendance> {
  late Future<List<(TacgEvent, int)>> _attendanceFuture;
  final ScrollController _scrollController = ScrollController();

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDateController.text =
        "${_startDate.month}/${_startDate.day}/${_startDate.year}";
    _endDateController.text =
        "${_endDate.month}/${_endDate.day}/${_endDate.year}";
    _attendanceFuture = aggregateAttendance(context, _startDate, _endDate);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2029),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Format the date for display
        _startDateController.text =
            "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate, // Ensure end date is after start date
      lastDate: DateTime(2029),
    );
    if (picked != null && picked != _endDate) {
      setState(() { 
        _endDate = picked;
        // Format the date for display
        _endDateController.text =
            "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<(TacgEvent, int)>>(
      future: _attendanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("5. Still loading..."); // This will show first!
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        print("6. Data loaded!"); // This shows later when Future completes
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 1 / 3,
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: "Event Date",
                        hintText: "Select date",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true, // Prevents keyboard from appearing
                      onTap: () => _selectStartDate(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 1 / 3,
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: "End Date",
                        hintText: "Select date",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true, // Prevents keyboard from appearing
                      onTap: () => _selectEndDate(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _attendanceFuture = aggregateAttendance(
                          context,
                          _startDate,
                          _endDate,
                        );
                      });
                    },
                    child: const Text("GO"),
                  ),
                ],
              ),
            ),
            Container(
              child: Scrollbar(
                controller: _scrollController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 1 / 2,
                    width: snapshot.data!.length * 70,
                    child: BarChart(
                      BarChartData(
                        maxY: _calculateMaxY(snapshot.data!),
                        minY: 0,
                        barGroups: snapshot.data!.asMap().entries.map(
                          (entry) {
                            final index = entry.key; // 0, 1, 2, 3...
                            final event_to_attendance_record = entry.value;
                            final attendanceCount =
                                event_to_attendance_record.$2;

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: attendanceCount.toDouble(),
                                  color: attendanceCount < 10
                                      ? Colors.green[200]
                                      : (attendanceCount <= 20
                                          ? Colors.green[600]
                                          : Colors.green[900]),
                                  width: 20,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ],
                              showingTooltipIndicators: [0],
                            );
                          },
                        ).toList(),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                // Convert the x value back to event title
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < snapshot.data!.length) {
                                  final event = snapshot.data![index].$1;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      width: 70,
                                      child: Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize:
                                  40, // Adjust based on your title length
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          // touchTooltipData: BarTouchTooltipData(
                          //   getTooltipItem: (group, groupIndex, rod, rodIndex) {

                          //     return null;
                          //     // // Get the event data for this bar
                          //     // final event = snapshot.data![groupIndex].$1;
                          //     // final attendanceCount = snapshot.data![groupIndex].$2;

                          //     // return BarTooltipItem(
                          //     //   '${event.title}\n'
                          //     //   'Date: ${event.date.toString().split(' ')[0]}\n'
                          //     //   'Time: ${event.time}\n'
                          //     //   'Attendance: $attendanceCount\n'
                          //     //   'Mandatory: ${event.isMandatory ? "Yes" : "No"}\n'
                          //     //   '${event.description}',
                          //     //   const TextStyle(
                          //     //     color: Colors.white,
                          //     //     fontWeight: FontWeight.bold,
                          //     //     fontSize: 12,
                          //     //   ),
                          //     // );
                          //   },
                          //   tooltipRoundedRadius: 8,
                          //   tooltipPadding: const EdgeInsets.all(8),
                          //   tooltipMargin: 8,
                          // ),
                          touchCallback:
                              (FlTouchEvent event, barTouchResponse) {
                            // Optional: Handle touch events for custom actions
                            if (event is FlTapUpEvent &&
                                barTouchResponse?.spot != null) {
                              final touchedIndex =
                                  barTouchResponse!.spot!.touchedBarGroupIndex;
                              final touchedEvent =
                                  snapshot.data![touchedIndex].$1;

                              // You could navigate to a detail page, show a dialog, etc.
                              print('Tapped on event: ${touchedEvent.title}');

                              // Example: Show a dialog with full event details
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(touchedEvent.title),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Date: ${touchedEvent.date.toString().split(' ')[0]}'),
                                      Text('Time: ${touchedEvent.time}'),
                                      Text(
                                          'Mandatory: ${touchedEvent.isMandatory ? "Yes" : "No"}'),
                                      const SizedBox(height: 8),
                                      Text('Description:'),
                                      Text(touchedEvent.description),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Total Attendance: ${snapshot.data![touchedIndex].$2}'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

double _calculateMaxY(List<(TacgEvent, int)> data) {
  if (data.isEmpty) return 10; // Default fallback

  final maxAttendance =
      data.map((item) => item.$2).reduce((a, b) => a > b ? a : b);

  // Add some padding (10-20% extra space at the top)
  return (maxAttendance * 1.2).ceilToDouble();
}
