import 'package:ecommerce/core/services/firebase_service.dart';
import 'package:ecommerce/features/auth/presentation/view/screens/login_screen.dart';
import 'package:ecommerce/presentation/screens/items/layout.dart';
import 'package:ecommerce/presentation/screens/auth/profile_screen.dart';
import 'package:ecommerce/features/auth/presentation/view/screens/create_user_screen.dart';
import 'package:ecommerce/features/auth/presentation/view/screens/forgot_password.dart';
import 'package:ecommerce/presentation/screens/place_order/check_out.dart';
import 'package:ecommerce/presentation/screens/place_order/cart_screen.dart';
import 'package:ecommerce/features/auth/presentation/view/screens/user_registration_screen.dart';
import 'package:ecommerce/features/auth/presentation/view/screens/user_location.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final _firebaseService = FirebaseService();
  static const kLoginScreen = "/login";
  static const kLayoutScreen = "/layout";
  static const kProfileScreen = "/profile";
  static const kCreateUserScreen = "/create_user_screen";
  static const kForgotPasswordScreen = "/forgot";
  static const kCheckoutScreen = "/checkout";
  static const kCartScreen = "/cart";
  static const kUserSetupScreen = "/user_setup";
  static const kUserLocationScreen = "/user_location";

  static String get _initialRoute {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser != null) {
      return kLayoutScreen;
    } else {
      return kLoginScreen;
    }
  }

  static final GoRouter router = GoRouter(
    initialLocation: _initialRoute,
    routes: [
      GoRoute(
        path: kLoginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: kLayoutScreen,
        builder: (context, state) => const LayOut(),
      ),
      GoRoute(
        path: kProfileScreen,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: kCreateUserScreen,
        builder: (context, state) => const CreateUser(),
      ),
      GoRoute(
        path: kForgotPasswordScreen,
        builder: (context, state) => const ForgotPassword(),
      ),
      GoRoute(
        path: kCheckoutScreen,
        builder: (context, state) => const CheckOutScreen(),
      ),
      GoRoute(
        path: kCartScreen,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: kUserSetupScreen,
        builder: (context, state) => const UserRegistrationScreen(),
      ),
      GoRoute(
        path: kUserLocationScreen,
        builder: (context, state) => const UserLocation(),
      ),
    ],
  );
}
