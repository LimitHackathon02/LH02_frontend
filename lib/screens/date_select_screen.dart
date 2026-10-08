import 'package:flutter/material.dart';
import 'time_select_screen.dart';
class DateSelectScreen extends StatefulWidget {
  const DateSelectScreen({super.key});
  @override
  State<DateSelectScreen> createState() => _DateSelectScreenState();
}
class _DateSelectScreenState extends State<DateSelectScreen> {
  DateTime displayedMonth = DateTime(2026, 9);
  DateTime? startDate;
  DateTime? endDate;
  final Color yellow = const Color(0xFFFFE3A0);
  final Color dark = const Color(0xFF281313);
  void selectDate(DateTime date) {
    setState(() {
      if (startDate == null || endDate != null || date.isBefore(startDate!)) {
        startDate = date;
        endDate = null;
      } else {
        endDate = date;
      }
    });
  }
  bool sameDay(DateTime? a, DateTime b) {
    return a != null &&
        a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
  Widget buildCalendar() {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final offset = firstDay.weekday % 7;
    final gridStart = firstDay.subtract(Duration(days: offset));
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF9),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => setState(() {
                  displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
                }),
                icon: const Icon(Icons.arrow_left, color: Colors.grey),
              ),
              Text(
                '${displayedMonth.year}년 ${displayedMonth.month}월',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => setState(() {
                  displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
                }),
                icon: const Icon(Icons.arrow_right, color: Colors.grey),
              ),
            ],
          ),
          Container(
            height: 38,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Row(
              children: [
                for (final day in ['일', '월', '화', '수', '목', '금', '토'])
                  Expanded(
                    child: Center(child: Text(day, style: const TextStyle(fontSize: 11))),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final date = gridStart.add(Duration(days: index));
              final isCurrentMonth = date.month == displayedMonth.month;
              final selected = sameDay(startDate, date) || sameDay(endDate, date);
              final inRange = startDate != null &&
                  endDate != null &&
                  date.isAfter(startDate!) &&
                  date.isBefore(endDate!);
              return GestureDetector(
                onTap: isCurrentMonth ? () => selectDate(date) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: inRange ? yellow.withValues(alpha: 0.75) : null,
                  ),
                  child: Center(
                    child: Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        color: selected ? yellow : null,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 12,
                          color: !isCurrentMonth
                              ? Colors.grey
                              : date.weekday == DateTime.sunday
                                  ? Colors.redAccent
                                  : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
              ),
              const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(5),
                color: const Color(0xFFFFF5D2),
                child: const Text(
                  '모두가 만족하는 일정을 정해볼게요',
                  style: TextStyle(color: Color(0xFFAA801B), fontSize: 13),
                ),
              ),
              const SizedBox(height: 22),
              const Text('STEP.1', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: dark),
                  children: const [
                    TextSpan(text: '원하는 '),
                    TextSpan(text: '날짜', style: TextStyle(color: Color(0xFFE65E61))),
                    TextSpan(text: '를\n선택해주세요'),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              buildCalendar(),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF1B5),
                    foregroundColor: dark,
                    disabledBackgroundColor: Colors.grey.shade200,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: startDate == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TimeSelectScreen(
                                startDate: startDate!,
                                endDate: endDate ?? startDate!,
                              ),
                            ),
                          );
                        },
                  child: const Text('다음 →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
