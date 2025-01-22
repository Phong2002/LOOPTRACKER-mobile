import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Thư viện để định dạng ngày tháng

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final String label;
  final String hint;

  DatePickerField({
    required this.selectedDate,
    required this.onDateChanged,
    this.label = 'Ngày',
    this.hint = 'Chọn ngày',
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 40.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: selectedDate.isNull?"":label,
        hintText: label,
        floatingLabelStyle: TextStyle(
          fontSize: 22,
          color: Colors.green[800],
        ),
      ),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: Text(
            selectedDate != null ? DateFormat.yMMMd().format(selectedDate!) : label,
            style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black,fontSize: 45.sp),
          ),
        ),
      ),
    );
  }
}
