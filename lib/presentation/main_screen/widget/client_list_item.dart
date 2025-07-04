import 'package:flutter/material.dart';

import '../../clint_detail_screen/client_details_screen.dart';
import '../../moc_models.dart';


class ClientListItem extends StatelessWidget {
  final ClientUi client;

  const ClientListItem({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientDetailsScreen(client: client),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              // const Spacer(), // Use Expanded on Text or Spacer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue, // Theme.of(context).primaryColor
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  client.transactionCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                client.finalBalance.toStringAsFixed(2),
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_drop_down_circle, color: Colors.red[400]), // Placeholder icon
            ],
          ),
        ),
      ),
    );
  }
}

