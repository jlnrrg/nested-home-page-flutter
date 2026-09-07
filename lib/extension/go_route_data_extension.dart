import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouteDataExtension on GoRouteData {
  String get locationWithoutQuery => Uri.parse(location).path;
  String toKey(Key? widgetKey) {
    if (widgetKey == null) return locationWithoutQuery;
    return '$locationWithoutQuery, key: $widgetKey';
  }
}
