import 'package:animal_adoption/views/auth/login_view.dart';
import 'package:animal_adoption/views/auth/register_view.dart';
import 'package:animal_adoption/views/home.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  AppRoutes._();

  static final routes = [
    GetPage(name: HomeView.id, page: () => const HomeView()),
    GetPage(name: RegisterView.id, page: () => const RegisterView()),
    GetPage(name: LoginView.id, page: () => const LoginView()),
  ];
}
