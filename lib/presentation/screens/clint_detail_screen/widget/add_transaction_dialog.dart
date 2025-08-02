import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../bloc/detail_cubit/detail_cubit.dart';
import '../../../moc_models.dart';

class AddTransactionDialog extends StatefulWidget {
  final ClientUi client;
  final Function() onTap;

  const AddTransactionDialog({
    super.key,
    required this.client,
    required this.onTap,
  });

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();

  String _currency = 'USD';
  DateTime _selectedDate = DateTime.now();
  bool _isTransactionAddition = true;
  bool _isLoading = false;

  // Store the cubit reference to avoid context issues
  late DetailCubit _detailCubit;

  @override
  void initState() {
    super.initState();
    // Get the cubit reference once in initState
    _detailCubit = context.read<DetailCubit>();
    print('🔵 [AddTransactionDialog] Dialog initialized for client: ${widget.client.name} (ID: ${widget.client.id})');
    print('🟡 [AddTransactionDialog] DetailCubit reference obtained: $_detailCubit');
  }

  @override
  void dispose() {
    print('🔵 [AddTransactionDialog] Disposing controllers');
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    print('🔵 [AddTransactionDialog] Opening date picker, current date: $_selectedDate');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      print('🟡 [AddTransactionDialog] Date changed from $_selectedDate to $picked');
      setState(() {
        _selectedDate = picked;
      });
    } else {
      print('🟡 [AddTransactionDialog] Date picker cancelled or same date selected');
    }
  }

  Future<void> _addTransaction({bool saveAndNew = false}) async {
    print('🔵 [AddTransactionDialog] _addTransaction called - saveAndNew: $saveAndNew');

    if (!_formKey.currentState!.validate()) {
      print('🔴 [AddTransactionDialog] Form validation failed');
      return;
    }

    // Validate client ID
    if (widget.client.id == null) {
      print('🔴 [AddTransactionDialog] Client ID is null, cannot add transaction');
      _showErrorSnackBar('Invalid client. Please try again.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final details = _detailsController.text.trim();

      print('🟡 [AddTransactionDialog] Creating transaction with:');
      print('  - Client ID: ${widget.client.id}');
      print('  - Amount: $amount');
      print('  - Is Addition: $_isTransactionAddition');
      print('  - Date: $_selectedDate');
      print('  - Details: "$details"');

      // Create transaction entity
      final transaction = Transaction(
        id: null,
        clientId: widget.client.id!,
        amount: amount,
        isAddition: _isTransactionAddition,
        dateTime: _selectedDate,
        details: details.isEmpty ? 'No details provided' : details,
      );

      print('🔵 [AddTransactionDialog] Transaction object created: $transaction');
      print('🔵 [AddTransactionDialog] Using DetailCubit: $_detailCubit');

      // Use the stored cubit reference instead of context.read
      await _detailCubit.addTransaction(transaction);

      // Show success message
      if (mounted) {
        print('🟢 [AddTransactionDialog] Transaction added successfully, showing success message');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction ${_isTransactionAddition ? 'credit' : 'debit'} added successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (saveAndNew) {
        print('🟡 [AddTransactionDialog] Save & New selected, resetting form');
        _resetForm();
      } else {
        print('🟡 [AddTransactionDialog] Save & Exit selected, closing dialog');
        widget.onTap();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print('🔴 [AddTransactionDialog] Error adding transaction: $e');
      if (mounted) {
        _showErrorSnackBar('Error adding transaction: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _resetForm() {
    print('🔵 [AddTransactionDialog] Resetting form');
    _amountController.clear();
    _detailsController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _isTransactionAddition = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.account_balance_wallet, color: Colors.blue),
          SizedBox(width: 10),
          Text("Add Transaction"),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Client Name (Read-only)
                TextFormField(
                  initialValue: widget.client.name,
                  decoration: const InputDecoration(
                    labelText: "Client Name",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                // Transaction Type Toggle
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horiz, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Text("Type: "),
                        Expanded(
                          child: SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment<bool>(
                                value: true,
                                label: Text("Credit (+)"),
                                icon: Icon(Icons.add, color: Colors.green),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                label: Text("Debit (-)"),
                                icon: Icon(Icons.remove, color: Colors.red),
                              ),
                            ],
                            selected: {_isTransactionAddition},
                            onSelectionChanged: (Set<bool> selected) {
                              print('🟡 [AddTransactionDialog] Transaction type changed to: ${selected.first ? "Credit" : "Debit"}');
                              setState(() {
                                _isTransactionAddition = selected.first;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount Input
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: _isTransactionAddition ? Colors.green : Colors.red,
                    ),
                    border: const OutlineInputBorder(),
                    prefixText: _isTransactionAddition ? "+" : "-",
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Invalid amount';
                    }
                    if (amount <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    print('🟡 [AddTransactionDialog] Amount changed to: $value');
                  },
                ),
                const SizedBox(height: 16),

                // Currency Dropdown
                DropdownButtonFormField<String>(
                  value: _currency,
                  decoration: const InputDecoration(
                    labelText: "Currency",
                    prefixIcon: Icon(Icons.currency_exchange),
                    border: OutlineInputBorder(),
                  ),
                  items: ['USD', 'EUR', 'EGP', 'Local'].map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      print('🟡 [AddTransactionDialog] Currency changed to: $newValue');
                      setState(() {
                        _currency = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "${_selectedDate.toLocal().toString().split(' ')[0]}",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),

                // Details/Notes
                TextFormField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    labelText: "Details/Notes",
                    hintText: "Optional transaction description",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 200,
                  onChanged: (value) {
                    print('🟡 [AddTransactionDialog] Details changed to: "$value"');
                  },
                ),
                const SizedBox(height: 16),

                // Transaction Preview Card
                Card(
                  color: _isTransactionAddition ? Colors.green.shade50 : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          _isTransactionAddition ? Icons.trending_up : Icons.trending_down,
                          color: _isTransactionAddition ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_isTransactionAddition ? 'Credit' : 'Debit'}: ${_amountController.text.isEmpty ? '0.00' : _amountController.text} $_currency",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _isTransactionAddition ? Colors.green.shade700 : Colors.red.shade700,
                                ),
                              ),
                              Text(
                                "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
          onPressed: _isLoading ? null : () {
            print('🟡 [AddTransactionDialog] Cancel button pressed');
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        Wrap(
          children: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
              ),
              onPressed: _isLoading ? null : () {
                print('🟡 [AddTransactionDialog] Save & New button pressed');
                _addTransaction(saveAndNew: true);
              },
              child: const Text("Save & New"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isTransactionAddition ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: _isLoading ? null : () {
                print('🟡 [AddTransactionDialog] Save & Exit button pressed');
                _addTransaction(saveAndNew: false);
              },
              child: const Text("Save & Exit"),
            ),
          ],
        ),
      ],
    );
  }
}