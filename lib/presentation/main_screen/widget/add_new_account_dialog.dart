// add_new_account_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/add_client/add_client_cubit.dart';

import '../../moc_models.dart';

class AddNewAccountDialog extends StatefulWidget {
  Function(ClientUi) onTap;
  int selectedCategoryId;
  AddNewAccountDialog({super.key, required this.onTap, required this.selectedCategoryId});

  @override
  State<AddNewAccountDialog> createState() => _AddNewAccountDialogState();
}

class _AddNewAccountDialogState extends State<AddNewAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  String _accountName = '';
  double _initialAmount = 0.0;
  String _currency = 'Local'; // Default or from settings
  DateTime _selectedDate = DateTime.now();
  String _details = '';
  String _phoneNumber = '';
  bool _isInitialBalanceAddition = true; // true for Credit, false for Debit
  bool _isSubmitting = false;
  DateTime? _lastTapTime;
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
    return BlocListener<AddClientCubit, AddClientState>(
      listener: (context, state) {
        if (state is AddClientSuccess) {
          print('🟢 [Dialog] Client added successfully: ${state.client.name}');

          // Convert the entity to UI model
          final clientUi = ClientUi(
            id: state.client.id,
            name: state.client.name,
            categoryId: state.client.categoryId,
            transactionCount: 1, // Because initial balance = 1 transaction
            finalBalance: _isInitialBalanceAddition ? _initialAmount : -_initialAmount,
          );

          widget.onTap(clientUi); // Send client back to caller
          Navigator.of(context).pop();
        } else if (state is AddClientFailure) {
          print('🔴 [Dialog] Failed to add client: ${state.message}');
          _isSubmitting = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is AddClientLoading) {
          print('🟡 [Dialog] Adding client...');
          _isSubmitting = true;
        }
      },
      child: AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.person_add_alt_1_outlined, color: Colors.blue),
            SizedBox(width: 10),
            Text("Add New Account"),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Account Name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter account name' : null,
                  onSaved: (value) => _accountName = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Initial Amount",
                    prefixIcon: Icon(Icons.calculate_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter amount';
                    if (double.tryParse(value) == null) return 'Invalid amount';
                    return null;
                  },
                  onSaved: (value) => _initialAmount = double.parse(value!),
                ),
                TextFormField(
                  initialValue: _currency,
                  decoration: const InputDecoration(
                    labelText: "Currency",
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  onSaved: (value) => _currency = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Details",
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                  onSaved: (value) => _details = value ?? '',
                  maxLines: null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _phoneNumber = value ?? '',
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          BlocBuilder<AddClientCubit, AddClientState>(
            builder: (context, state) {
              return ElevatedButton(
                child: state is AddClientLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text("Save"),

                  onPressed: state is AddClientLoading
                  ? null
                  : () {
                final now = DateTime.now();
                if (_lastTapTime != null &&
                    now.difference(_lastTapTime!) < Duration(milliseconds: 500)) {
                  return; // Ignore rapid taps
                }
                _lastTapTime = now;

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  context.read<AddClientCubit>().addNewClient(
                    name: _accountName,
                    categoryId: widget.selectedCategoryId,
                  );
                }
              },
              );
            },
          ),
        ],
      ),
    );
  }
}