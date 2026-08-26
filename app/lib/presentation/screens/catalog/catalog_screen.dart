import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design/tokens/spacing.dart';
import '../../../domain/models/store.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/catalog_providers.dart';
import '../../providers/store_providers.dart';
import '../../widgets/product_row.dart';

/// Каталог: весь ассортимент одной сети или точки.
///
/// Отличается от поиска тем, что человек ничего не искал — он смотрит, что
/// вообще есть. Поэтому здесь нет поля ввода, зато есть разделы, а список
/// отсортирован по названию: обход каталога должен быть предсказуемым.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key, this.chainId, this.storeId, this.title});

  final int? chainId;
  final int? storeId;
  final String? title;

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _scroll = ScrollController();
  CatalogTarget? _target;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    // Раздел живёт в StateProvider на весь экран, и при входе его надо
    // сбросить: иначе каталог Bravo открывается в разделе, выбранном вчера
    // у Araz, и выглядит пустым.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(catalogCategoryProvider.notifier).state = null;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients || _target == null) return;
    final left = _scroll.position.maxScrollExtent - _scroll.position.pixels;
    if (left < 600) {
      ref.read(catalogProvider(_target!).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final target = _target = CatalogTarget(
      chainId: widget.chainId,
      storeId: widget.storeId,
      title: widget.title ?? '',
    );

    final catalog = ref.watch(catalogProvider(target));
    final categories = ref.watch(catalogCategoriesProvider(target));
    final selected = ref.watch(catalogCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? l10n.catalogTitle)),
      body: Column(
        children: [
          // Ряд разделов прячется целиком, если их нет: чипы, ни один из
          // которых ничего не отфильтрует, читаются как поломка.
          categories.maybeWhen(
            data: (list) => list.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg,
                        vertical: Spacing.sm,
                      ),
                      itemCount: list.length + 1,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: Spacing.sm),
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return ChoiceChip(
                            label: Text(l10n.catalogAllCategories),
                            selected: selected == null,
                            onSelected: (_) => ref
                                .read(catalogCategoryProvider.notifier)
                                .state = null,
                          );
                        }
                        final c = list[i - 1];
                        return ChoiceChip(
                          label: Text(c),
                          selected: selected == c,
                          onSelected: (_) => ref
                              .read(catalogCategoryProvider.notifier)
                              .state = c,
                        );
                      },
                    ),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          Expanded(
            child: catalog.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Text(l10n.errorGeneric, textAlign: TextAlign.center),
                ),
              ),
              data: (state) {
                if (state.items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.lg),
                      child: Text(l10n.catalogEmpty),
                    ),
                  );
                }
                return ListView.separated(
                  controller: _scroll,
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    if (i >= state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(Spacing.lg),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return ProductRow(item: state.items[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Выбор магазина, чей каталог смотреть.
class CatalogPickerScreen extends ConsumerWidget {
  const CatalogPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stores = ref.watch(storesProvider((lat: null, lon: null)));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.catalogPickStore)),
      body: stores.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGeneric)),
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final Store s = list[i];
            return ListTile(
              title: Text(s.name),
              subtitle: s.address == null ? null : Text(s.address!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CatalogScreen(
                    // У сети с единой ценой филиала нет — показываем всю сеть.
                    chainId: s.storeId == null ? s.chainId : null,
                    storeId: s.storeId,
                    title: s.name,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
