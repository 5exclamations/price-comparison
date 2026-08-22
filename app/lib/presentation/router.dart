import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/store_providers.dart';
import 'screens/deals/deals_screen.dart';
import 'screens/list/list_screen.dart';
import 'screens/onboarding/store_picker_screen.dart';
import 'screens/product/product_screen.dart';
import 'screens/receipts/my_receipts_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'shell/home_shell.dart';

/// Пути приложения. Строк с адресами в виджетах быть не должно —
/// только константы отсюда.
abstract final class Routes {
  static const onboarding = '/onboarding';
  static const search = '/search';
  static const deals = '/deals';
  static const list = '/list';
  static const settings = '/settings';

  /// Правка выбора магазинов из настроек.
  static const settingsStores = '/settings/stores';

  /// Мои чеки: список, баллы, отзыв согласия.
  static const receipts = '/settings/receipts';

  /// Карточка товара. Открывается поверх нижней навигации.
  static const product = '/product';
  static String productOf(int id) => '$product/$id';
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Роутер. Требует ref, чтобы сторожить обязательный выбор магазина.
GoRouter buildRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.search,

    // Пока выбор не сделан, приложением пользоваться нельзя. Это не
    // придирчивость: без выбранного магазина цена сети с несколькими прайсами
    // — выдумка, а показывать выдумку вместо цены нельзя.
    redirect: (context, state) {
      final complete = ref.read(selectionCompleteProvider);
      final atPicker = state.matchedLocation == Routes.onboarding;

      if (!complete && !atPicker) return Routes.onboarding;

      // Обратного правила «выбор полон — уводим с онбординга» здесь НЕТ, и это
      // осознанно. Оно срабатывало в момент, когда человек отмечал магазин
      // Bravo: выбор становился полным, redirect уносил на поиск, и вторую
      // сеть отметить было уже нельзя, а кнопка «Продолжить» не нажималась
      // никогда. Уходит с экрана только тот, кто нажал кнопку сам —
      // StorePickerScreen делает это через context.go.
      return null;
    },

    // Роутер должен пересчитать redirect, когда выбор изменился.
    refreshListenable: _SelectionListenable(ref),

    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const StorePickerScreen(),
      ),
      GoRoute(
        path: Routes.settingsStores,
        builder: (context, state) =>
            const StorePickerScreen(isOnboarding: false),
      ),
      GoRoute(
        path: Routes.receipts,
        builder: (context, state) => const MyReceiptsScreen(),
      ),
      GoRoute(
        path: '${Routes.product}/:id',
        builder: (context, state) {
          final raw = state.pathParameters['id'];
          final id = int.tryParse(raw ?? '');
          if (id == null) return const ProductScreen.invalid();
          return ProductScreen(productId: id);
        },
      ),
      // Базовый конструктор, а не indexedStack: тот с go_router 16 сам
      // подставляет свой контейнер и чужой navigatorContainerBuilder больше
      // не принимает, а нам нужна своя оболочка с нижней навигацией.
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) =>
            HomeShell(navigationShell: navigationShell, children: children),
        builder: (context, state, navigationShell) => navigationShell,
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [
              GoRoute(
                path: Routes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.deals,
                builder: (context, state) => const DealsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.list,
                builder: (context, state) => const ListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Дёргает роутер, когда меняется полнота выбора.
///
/// Подписку закрывать вручную не нужно: ref.listen внутри провайдера живёт
/// ровно столько же, сколько сам провайдер, и закрывается вместе с ним.
class _SelectionListenable extends ChangeNotifier {
  _SelectionListenable(Ref ref) {
    ref.listen<bool>(selectionCompleteProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = buildRouter(ref);
  ref.onDispose(router.dispose);
  return router;
});
