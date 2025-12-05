import 'package:flutter/material.dart';
import 'package:rest_dashboard/presentation/widgets/buildStatCard.dart';

Widget buildStreamStatCard<T>({
  required Stream<T> stream,
  required String title,
  required IconData icon,
  required Color iconColor,
  required Color iconBgColor,
  required Color trendColor,

  // Optional formatter to format numbers like 1.2K, $200, etc
  String Function(T data)? formatter,
}) {
  return StreamBuilder<T>(
    stream: stream,
    builder: (context, snapshot) {
      // Still loading
      if (snapshot.connectionState == ConnectionState.waiting) {
        return buildStatCard(
          title: title,
          value: "...",
          trendColor: trendColor,
          icon: icon,
          iconColor: iconColor,
          iconBgColor: iconBgColor,
        );
      }

      // Error
      if (snapshot.hasError) {
        print("STREAM ERROR in $title: ${snapshot.error}");

        return buildStatCard(
          title: title,
          value: "Error",
          trendColor: trendColor,
          icon: icon,
          iconColor: iconColor,
          iconBgColor: iconBgColor,
        );
      }

      // No data
      if (!snapshot.hasData) {
        return buildStatCard(
          title: title,
          value: 0,
          trendColor: trendColor,
          icon: icon,
          iconColor: iconColor,
          iconBgColor: iconBgColor,
        );
      }

      // Valid data
      final formattedValue = formatter != null
          ? formatter(snapshot.data as T)
          : snapshot.data.toString();

      return buildStatCard(
        title: title,
        value: formattedValue,
        trendColor: trendColor,
        icon: icon,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      );
    },
  );
}
