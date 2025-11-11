import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/local/daos/client_dao.dart';
import '../../../data/local/database.dart';
import '../../ui_models/client_with_total.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  final ClientDao clientDao;

  MainScreenCubit(this.clientDao) : super(InitialState());

  void getClientsList() async {
    emit(LoadingState());
    final clients = await clientDao.getClientsWithTotal();
    emit(GetDataSuccessState(clients));
  }
  void addClient({required String name,required  String category}) async {
    emit(LoadingState());
    await clientDao.insertClient(name:name,category:category);
    getClientsList();
  }
}
