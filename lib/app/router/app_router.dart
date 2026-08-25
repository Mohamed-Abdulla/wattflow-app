import 'package:go_router/go_router.dart';
import '../../features/devices/presentation/pages/device_details_page.dart';
import '../../features/devices/presentation/pages/device_form_page.dart';
import '../../features/devices/presentation/pages/device_list_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/devices',
  routes: [
    GoRoute(
      path: '/devices',
      builder: (context, state) => const DeviceListPage(),
    ),
    GoRoute(
      path: '/devices/new',
      builder: (context, state) => const DeviceFormPage(),
    ),
    GoRoute(
      path: '/devices/:deviceId',
      builder: (context, state) =>
          DeviceDetailsPage(deviceId: state.pathParameters['deviceId']!),
    ),
    GoRoute(
      path: '/devices/:deviceId/edit',
      builder: (context, state) =>
          DeviceFormPage(deviceId: state.pathParameters['deviceId']),
    ),
  ],
);
