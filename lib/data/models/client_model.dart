import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    super.id,
    required super.name,
    required super.categoryId,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
    };
  }

  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      name: client.name,
      categoryId: client.categoryId,
    );
  }
}