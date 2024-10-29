import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectBottomSheetCustomer extends StatelessWidget {
  final Map<String, String> options; // Map để lưu trữ nhãn và giá trị
  final String? selectedValue; // Giá trị đã chọn
  final ValueChanged<MapEntry<String, String>> onChanged; // Hàm gọi lại khi chọn một giá trị
  final String label; // Nhãn hiển thị trên ô input

  SelectBottomSheetCustomer({
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
      child: GestureDetector(
        onTap: () => _showBottomSheet(context),
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 20.h, vertical: 40.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: selectedValue != null ? label : '',
            floatingLabelStyle: TextStyle(
              fontSize: 22,
              color: Colors.green[800],
            ),
          ),
          child: Text(
            options.keys.firstWhere(
                    (key) => options[key] == selectedValue,
                orElse: () => label),
            style: TextStyle(fontSize: 45.sp),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 60.h, fontWeight: FontWeight.bold),
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 50.h),
                height: 800.h,
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = options.keys.elementAt(index);
                    String value = options[key]!;
                    return ListTile(
                      selected: value == selectedValue,
                      selectedColor: Colors.green[800],
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          key,
                          style: TextStyle(fontSize: 50.sp),
                        ),
                      ),
                      onTap: () {
                        onChanged(MapEntry(key, value)); // Truyền cả key và value
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
