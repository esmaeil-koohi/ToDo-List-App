
import 'package:flutter/material.dart';
import 'package:todo/data.dart';
import 'package:todo/main.dart';

extension ColorExtension on TaskEntity{
  getColor(){
    switch(this.priority)
    {
      case Priority.high:
        return primaryColor;
      case Priority.normal:
        return const Color(0xffF09819);
      case Priority.low:
        return const Color(0xff3BE1F1);
    }
  }
}