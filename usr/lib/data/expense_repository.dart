import 'package:flutter/material.dart';
import '../models/transaction.dart';

class ExpenseRepository extends ValueNotifier<List<Transaction>> {
  // Singleton pattern
  static final ExpenseRepository _instance = ExpenseRepository._internal();
  
  factory ExpenseRepository() {
    return _instance;
  }

  ExpenseRepository._internal() : super(_initialData());

  static List<Transaction> _initialData() {
    return [
      Transaction(
        id: '1',
        title: 'Grocery Shopping',
        amount: 150.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.expense,
        category: 'Food',
      ),
      Transaction(
        id: '2',
        title: 'Monthly Salary',
        amount: 3000.0,
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.income,
        category: 'Salary',
      ),
      Transaction(
        id: '3',
        title: 'Netflix Subscription',
        amount: 15.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.expense,
        category: 'Entertainment',
      ),
      Transaction(
        id: '4',
        title: 'Gym Membership',
        amount: 50.0,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.expense,
        category: 'Health',
      ),
    ];
  }

  void addTransaction(Transaction transaction) {
    // Create a new list to trigger listeners
    value = [...value, transaction];
    // Sort by date descending
    value.sort((a, b) => b.date.compareTo(a.date));
  }

  void deleteTransaction(String id) {
    value = value.where((tx) => tx.id != id).toList();
  }

  double get totalBalance {
    return value.fold(0.0, (sum, item) {
      return sum + (item.type == TransactionType.income ? item.amount : -item.amount);
    });
  }

  double get totalIncome {
    return value.where((item) => item.type == TransactionType.income).fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return value.where((item) => item.type == TransactionType.expense).fold(0.0, (sum, item) => sum + item.amount);
  }
}
