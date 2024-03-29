
import 'package:dego_admin/business_logic/http_api.dart';
import 'package:dego_admin/business_logic/view_models/mainScreen_vm/mainScreen_vm.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HttpApi());

  // locator.registerLazySingleton(() => AuthenticationService());
}

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<MainScreenViewModel>(create: (_) => MainScreenViewModel()),
];
