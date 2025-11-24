import 'package:flutter/material.dart';
import '../data/expense_repository.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ExpenseRepository();

    return ValueListenableBuilder<List<Transaction>>(
      valueListenable: repository,
      builder: (context, transactions, _) {
        final balance = repository.totalBalance;
        final income = repository.totalIncome;
        final expense = repository.totalExpense;

        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade800, Colors.blue.shade500],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSummaryItem('Income', income, Colors.greenAccent, Icons.arrow_upward),
                            Container(height: 30, width: 1, color: Colors.white24),
                            _buildSummaryItem('Expense', expense, Colors.redAccent, Icons.arrow_downward),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {}, // Could navigate to a full history page
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),
              transactions.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No transactions yet',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final transaction = transactions[index];
                          return TransactionItem(
                            transaction: transaction,
                            onDelete: () => repository.deleteTransaction(transaction.id),
                          );
                        },
                        childCount: transactions.length,
                      ),
                    ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
