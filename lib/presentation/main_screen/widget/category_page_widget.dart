import 'package:flutter/material.dart';

import '../../moc_models.dart';
import 'category_summary_footer.dart';
import 'client_list_item.dart';



class CategoryPageView extends StatelessWidget {
  final CategoryUi category;
  final List<ClientUi> clients;
  final CategorySummary summary;

  const CategoryPageView({
    super.key,
    required this.category,
    required this.clients,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const Icon(Icons.group_outlined),
              const SizedBox(width: 8),
              Text("Clients (${clients.length})"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (BuildContext context, int index) {
              return ClientListItem(client: clients[index]);
            },
          ),
        ),
        CategorySummaryFooter(summary: summary),
      ],
    );
  }
}
