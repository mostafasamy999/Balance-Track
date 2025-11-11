
import '../../data/local/database.dart';

class ClientWithTotal {
  final ClientTableData client;
  final double totalAmount;

  ClientWithTotal({required this.client, required this.totalAmount});

  ClientWithTotal copyWithAddedAmount(double amt) =>
      ClientWithTotal(client: client, totalAmount: totalAmount + amt);
}
