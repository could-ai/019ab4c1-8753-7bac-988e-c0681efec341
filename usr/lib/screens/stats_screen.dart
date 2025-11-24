import 'package:flutter/material.dart';
import '../data/expense_repository.dart';
import '../models/transaction.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ExpenseRepository();

    return ValueListenableBuilder<List<Transaction>>(
      valueListenable: repository,
      builder: (context, transactions, _) {
        // Calculate category totals
        final Map<String, double> categoryTotals = {};
        double totalExpense = 0;

        for (var tx in transactions) {
          if (tx.type == TransactionType.expense) {
            categoryTotals.update(
              tx.category,
              (value) => value + tx.amount,
              ifAbsent: () => tx.amount,
            );
            totalExpense += tx.amount;
          }
        }

        // Sort categories by amount
        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          body: totalExpense == 0
              ? const Center(child: Text('No expenses to show statistics'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedCategories.length,
                  itemBuilder: (context, index) {
                    final entry = sortedCategories[index];
                    final percentage = (entry.value / totalExpense);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$${entry.value.toStringAsFixed(2)} (${(percentage * 100).toStringAsFixed(1)}%)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 12,
                              backgroundColor: Colors.grey[200],
                              color: _getCategoryColor(index),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
