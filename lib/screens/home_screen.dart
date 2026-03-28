import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Green gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe8f5e8), Color(0xFFf1f8e9), Color(0xFFf5f5f5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ✅ Glassmorphism AppBar
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(220, 41, 175, 50),
                      Color.fromARGB(220, 30, 130, 38),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: AppBar(
                  title: const Text(
                    'Expense Tracker',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    Consumer<ExpensesProvider>(
                      builder: (context, provider, child) => PopupMenuButton<String>(
                        icon: const Icon(Icons.currency_exchange, 
                                      color: Colors.white, size: 26),
                        tooltip: 'Change currency',
                        onSelected: provider.setCurrency,
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: '₱', child: Text('₱ PHP')),
                          PopupMenuItem(value: '\$', child: Text('\$ USD')),
                          PopupMenuItem(value: '€', child: Text('€ EUR')),
                          PopupMenuItem(value: '¥', child: Text('¥ JPY')),
                          PopupMenuItem(value: '₩', child: Text('₩ KRW')),
                        ],
                      ),
                    ),
                    Consumer<ExpensesProvider>(
                      builder: (context, provider, child) => IconButton(
                        icon: Icon(
                          provider.isLoading 
                            ? Icons.hourglass_empty 
                            : Icons.sync,
                          color: Colors.white,
                        ),
                        tooltip: 'Sync from API',
                        onPressed: provider.isLoading ? null : provider.syncFromApi,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),

              Expanded(
                child: Consumer<ExpensesProvider>(
                  builder: (context, provider, child) {
                    final total = provider.expenses.fold<double>(
                      0, (sum, expense) => sum + expense.amount
                    );
                    
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Error banner
                        if (provider.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange.shade700),
                                const SizedBox(width: 12),
                                Expanded(child: Text(provider.errorMessage!)),
                                TextButton(
                                  onPressed: provider.syncFromApi,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),

                        // Last sync
                        if (provider.lastSync != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Last synced: ${provider.lastSync}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        // Loading
                        if (provider.isLoading)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 4,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.green.shade100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green.shade500,
                              ),
                            ),
                          ),

                        // Total Expenses Card
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 41, 175, 50),
                                Color.fromARGB(255, 30, 130, 38),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Expenses',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${provider.currency}${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${provider.expenses.length} expense${provider.expenses.length == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Expense list
                        provider.expenses.isEmpty && !provider.isLoading
                          ? Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      'No expenses yet',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                    ),
                                    Text('Tap + to add your first one', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.expenses.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final expense = provider.expenses[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(20),
                                    leading: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(211, 41, 175, 50),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.attach_money, color: Colors.white),
                                    ),
                                    title: Text(
                                      expense.title,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      '${provider.currency}${expense.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AddExpenseScreen(expense: expense),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => provider.deleteExpense(expense.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 41, 175, 50),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 28),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExpenseScreen()),
          ),
        ),
      ),
    );
  }
}