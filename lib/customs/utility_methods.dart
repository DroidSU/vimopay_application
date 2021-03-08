import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilityMethods {
  String beautifyTime(String time) {
    DateFormat dateFormat = new DateFormat('HH:mm:ss');
    DateTime dateTime = dateFormat.parse(time);

    TimeOfDay timeOfDay = new TimeOfDay.fromDateTime(dateTime);
    TimeOfDay selectedTime = timeOfDay.replacing(hour: timeOfDay.hourOfPeriod);

    // very crude implementation
    String hour = "";
    String mins = "";

    if (timeOfDay.hour < 12) {
      if (timeOfDay.hour < 10) {
        if (timeOfDay.hour == 0)
          hour = '12';
        else
          hour = '0${timeOfDay.hour}';
      } else
        hour = timeOfDay.hour.toString();

      if (timeOfDay.minute < 10)
        mins = '0${timeOfDay.minute}';
      else
        mins = timeOfDay.minute.toString();

      return "$hour:$mins AM";
    } else {
      if (selectedTime.hour < 10) {
        if (selectedTime.hour == 0)
          hour = '12';
        else
          hour = '0${selectedTime.hour}';
      } else
        hour = selectedTime.hour.toString();

      if (selectedTime.minute < 10)
        mins = '0${selectedTime.minute}';
      else
        mins = selectedTime.minute.toString();

      return "$hour:$mins PM";
    }
  }

  String getDate(String createdDate) {}
}
