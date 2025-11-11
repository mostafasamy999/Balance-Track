part of 'main_screen_cubit.dart';

@immutable
sealed class MainScreenState {}

final class InitialState extends MainScreenState {}
final class LoadingState extends MainScreenState {}
final class ErrorState extends MainScreenState {
  final String message;
  ErrorState(this.message);
}
final class GetDataSuccessState extends MainScreenState {
  final List<ClientWithTotal> clients;

  GetDataSuccessState(this.clients);

  @override
  String toString() {
    return 'GetDataSuccessState(clients: ${clients.map((c) => "{id: ${c.client.id}, name: ${c.client.name}, total: ${c.totalAmount}}").toList()})';
  }
}
