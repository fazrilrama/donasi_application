// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:ui';
import 'package:flutter/material.dart';

class Campaign {
  final String id;
  final String user_id;
  final String title;
  final String description;
  final String target_amount;
  final String collected_amount;
  final String deadline;
  final String status;
  final double percentage;
  final int length_transaction;
  final String created_at;

  Campaign({
    required this.id,
    required this.user_id,
    required this.title,
    required this.description,
    required this.target_amount,
    required this.collected_amount,
    required this.deadline,
    required this.status,
    required this.percentage,
    required this.length_transaction,
    required this.created_at,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      user_id: json['user_id'],
      title: json['title'],
      description: json['description'],
      target_amount: json['target_amount'],
      collected_amount: json['collected_amount'],
      deadline: json['deadline'],
      status: json['status'],
      percentage: (json['percentage'] as num).toDouble(),
      length_transaction: json['length_transaction'],
      created_at: json['created_at'],
    );
  }

  @override
  String toString() {
    return 'Campaign{id: $id, user_id: $user_id, title: $title, description: $description, target_amount: $target_amount, collected_amount: $collected_amount, deadline: $deadline, status: $status, percentage: $percentage, length_transaction: $length_transaction, created_at: $created_at}';
  }
}