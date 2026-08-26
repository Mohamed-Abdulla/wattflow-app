import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const sm = Radius.circular(8);
  static const md = Radius.circular(12);
  static const lg = Radius.circular(16);
  static const card = BorderRadius.all(md);
  static const button = BorderRadius.all(md);
}
