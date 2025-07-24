import 'package:flutter/material.dart';

import '../../../moc_models.dart';

// add_transaction_dialog
class AddTransactionDialog extends StatefulWidget {
  final ClientUi client; // Client for whom the transaction is being added
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
  double _amount = 0.0;
  String _currency = 'Local'; // Default or from client/settings
  DateTime _selectedDate = DateTime.now();
  String _details = '';
  bool _isTransactionAddition = true; // true for Credit, false for Debit

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.post_add_outlined, color: Colors.blue),
          SizedBox(width: 10),
          Text("Add Transaction"),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: widget.client.name,
                decoration: const InputDecoration(
                    labelText: "Client Name",
                    prefixIcon: Icon(Icons.person_outline)),
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Amount",
                    prefixIcon: Icon(Icons.calculate_outlined)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Invalid amount';
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              TextFormField(
                initialValue: _currency, // Inherit from client or app settings
                decoration: const InputDecoration(
                    labelText: "Currency",
                    prefixIcon: Icon(Icons.edit_outlined)),
                readOnly: true, // Typically fixed for a transaction
                onSaved: (value) => _currency = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Details",
                    prefixIcon: Icon(Icons.notes_outlined)),
                onSaved: (value) => _details = value ?? '',
                maxLines: null,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300),
                child: const Text("Save & New"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // TODO: Implement save logic (e.g., call BLoC/Cubit event)
                    // print("New Transaction for ${widget.client.name}: Amount: $_amount, Credit: _isTransactionAddition, Date: $_selectedDate");
                    // Reset form for new entry if needed, or re-open dialog
                    _formKey.currentState!.reset();
                    setState(() {
                      _selectedDate = DateTime.now();
                      _isTransactionAddition = true;
                    });
                    // Potentially keep dialog open or show a quick success message
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: ElevatedButton(
                child: const Text("Save & Exit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // TODO: Implement save logic
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
