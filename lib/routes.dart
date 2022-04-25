import 'package:animal_adoption/views/admin/admin_panel.dart';
import 'package:animal_adoption/views/auth/login_view.dart';
import 'package:animal_adoption/views/auth/register_view.dart';
import 'package:animal_adoption/views/users/create_post.dart';
import 'package:animal_adoption/views/home.dart';
import 'package:animal_adoption/views/users/view_post.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  AppRoutes._();

  static final routes = [
    GetPage(name: HomeView.id, page: () => const HomeView()),
    GetPage(name: RegisterView.id, page: () => const RegisterView()),
    GetPage(name: LoginView.id, page: () => const LoginView()),
    GetPage(name: CreateAdoptionPostView.id, page: () => const CreateAdoptionPostView()),
    GetPage(name: ViewPostHistory.id, page: () => const ViewPostHistory()),
    GetPage(name: AdminPanelView.id, page: () => const AdminPanelView()),
  ];
}
