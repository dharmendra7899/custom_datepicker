import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';

class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _dateController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 10, minute: 0);
  final DateTime _selectedDate = DateTime.now();
  String selectedTab = 'weekDay';

  TimeOfDay _calculateEndTime(TimeOfDay startTime) {
    int hour = startTime.hour + 2;
    int minute = startTime.minute;
    if (hour >= 24) {
      hour -= 24;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  timeSlotBottomSheet(BuildContext context, bool? isDate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              isDate == true ? SizedBox(height: 20) : SizedBox(),
              isDate == true
                  ? Text(
                    'Booking Date',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )
                  : SizedBox(),
              isDate == true ? SizedBox(height: 6) : SizedBox(),
              isDate == true
                  ? GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _dateController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);
                          pickedDate.toLocal().toString().split(' ')[0];
                          _startTime = TimeOfDay(hour: 8, minute: 0);
                          _endTime = _calculateEndTime(_startTime);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          readOnly: true,
                          controller: _dateController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                            border: InputBorder.none,
                            hintText: "DD/MM/YYYY",
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  : SizedBox(),
              SizedBox(height: 20),

              TimeRange(
                activeBorderColor: Colors.blueAccent,
                fromTitle: Text(
                  'Start Time',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                toTitle: Text(
                  'End Time',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                titlePadding: 0,
                textStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                activeTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                borderColor: Colors.black38,
                backgroundColor: Colors.transparent,
                activeBackgroundColor: Colors.blueAccent,
                firstTime: _startTime,
                lastTime: TimeOfDay(hour: 22, minute: 0),
                timeStep: 30,
                timeBlock: 90,
                onRangeCompleted:
                    (range) => setState(() {
                      String startFormatted = DateFormat.Hm().format(
                        DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          range?.start.hour ?? 0,
                          range?.start.minute ?? 0,
                        ),
                      );
                      String endFormatted = DateFormat.Hm().format(
                        DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          range?.end.hour ?? 0,
                          range?.end.minute ?? 0,
                        ),
                      );
                      debugPrint("RANGE::   $startFormatted to $endFormatted");
                    }),
              ),
              SizedBox(height: 30),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.blueAccent, width: 1),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text('Booking Slots')),
        backgroundColor: Colors.white,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(18.0),
          child: FloatingActionButton(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            isExtended: true,
            onPressed: () {
              timeSlotBottomSheet(
                context,
                selectedTab == 'weekDay' ? false : true,
              );
            },
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                //strokeAlign: 0.1,
                color: Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(Icons.add, size: 40, color: Colors.blueAccent),
          ),
        ),
        body: Column(
          children: [
            Material(
              elevation: 2.0,
              type: MaterialType.transparency,
              shadowColor: Colors.grey.shade50,
              child: TabBar(
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.black54,
                controller: _tabController,
                indicatorAnimation: TabIndicatorAnimation.linear,
                dividerColor: Colors.grey,
                tabAlignment: TabAlignment.fill,
                isScrollable: false,
                onTap: (value) {
                  setState(() {
                    selectedTab = value == 0 ? 'weekDay' : 'date';
                  });
                },
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.blueAccent,
                indicatorWeight: 2.0,
                tabs: const [Tab(text: 'WeekDay'), Tab(text: 'Date')],
              ),
            ),
            Expanded(
              child: TabBarView(
                dragStartBehavior: DragStartBehavior.start,
                controller: _tabController,
                children: [SizedBox(), SizedBox()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
