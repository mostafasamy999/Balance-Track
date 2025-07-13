import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final int? id;
  final String name;
  final int categoryId;

  const Client({
    this.id,
    required this.name,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, name, categoryId];
}