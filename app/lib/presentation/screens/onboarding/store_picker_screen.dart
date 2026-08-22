import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/districts.dart';
import '../../../core/geo.dart';
import '../../../design/tokens/colors.dart';
import '../../../design/tokens/spacing.dart';
import '../../../domain/models/store.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/store_providers.dart';
import '../../router.dart';

/// Выбор магазинов. Один экран, два применения: обязательный онбординг и
/// правка выбора из настроек.
///
/// Почему выбор обязателен. У сетей с привязкой цены к точке разброс между
/// собственными магазинами примерно такой же, как между разными сетями.
/// Показать «цену в Bravo» без магазина значит взять одну из четырёх разных
/// цен и выдать её за общую — то есть соврать.
///
/// Слово «зона» на экране не встречается ни разу. Пользователь выбирает свой
/// магазин; то, что внутри они сгруппированы по измеренным ценовым кластерам,
/// — наша кухня, и знать её ему незачем.
class StorePickerScreen extends ConsumerStatefulWidget {
  const StorePickerScreen({super.key, this.isOnboarding = true});

  /// В онбординге назад пути нет, из настроек — есть.
  final bool isOnboarding;

  @override
  ConsumerState<StorePickerScreen> createState() => _StorePickerScreenState();
}

class _StorePickerScreenState extends ConsumerState<StorePickerScreen> {
  String? _district;
  bool _locating = false;

  Future<void> _locate() async {
    final l10n = AppLocalizations.of(context);

    // Объясняем ДО системного диалога. Диалог, выскочивший сам по себе,
    // закрывают не читая — и отказывают навсегда, после чего вернуть доступ
    // можно только через настройки телефона.
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.locationWhyTitle),
        content: Text(l10n.locationWhyBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.locationAllow),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;

    setState(() => _locating = true);
    final outcome = await ref.read(geoLocatorProvider).current();
    if (!mounted) return;
    setState(() => _locating = false);
    ref.read(locationOutcomeProvider.notifier).state = outcome;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final point = ref.watch(userPointProvider);
    final stores = ref.watch(storesProvider(point));
    final selection = ref.watch(storeSelectionProvider);
    final requiring = ref.watch(chainsRequiringStoreProvider);
    final complete = selection.isCompleteFor(requiring);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isOnboarding ? l10n.storePickerTitle : l10n.settingsStores,
        ),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: stores.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            _ErrorState(onRetry: () => ref.invalidate(storesProvider(point))),
        data: (list) => _Body(
          stores: list,
          district: _district,
          locating: _locating,
          onLocate: _locate,
          onDistrict: (d) => setState(() => _district = d),
          missingStoreFor: selection.missingStoreFor(requiring),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!complete)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: Text(
                  selection.chainCodes.isEmpty
                      ? l10n.pickAtLeastOneChain
                      : l10n.pickStoreToContinue,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            FilledButton(
              // Пропустить нельзя: кнопка неактивна, пока выбор не полон.
              onPressed: complete
                  ? () {
                      if (widget.isOnboarding) {
                        context.go(Routes.search);
                      } else {
                        context.pop();
                      }
                    }
                  : null,
              child: Text(widget.isOnboarding ? l10n.continueLabel : l10n.save),
            ),
            if (widget.isOnboarding)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.sm),
                child: Text(
                  l10n.changeLaterInSettings,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.stores,
    required this.district,
    required this.locating,
    required this.onLocate,
    required this.onDistrict,
    required this.missingStoreFor,
  });

  final List<Store> stores;
  final String? district;
  final bool locating;
  final VoidCallback onLocate;
  final ValueChanged<String?> onDistrict;
  final Set<String> missingStoreFor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final outcome = ref.watch(locationOutcomeProvider);

    // Сети с единой ценой и сети, где надо выбрать точку.
    final wholeChain = stores.where((s) => !s.requiresStorePick).toList();
    final byChain = <String, List<Store>>{};
    for (final s in stores.where((s) => s.requiresStorePick)) {
      byChain.putIfAbsent(s.chainCode, () => []).add(s);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      children: [
        Text(
          l10n.storePickerWhy,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: Spacing.lg),

        _LocationBlock(
          outcome: outcome,
          locating: locating,
          onLocate: onLocate,
        ),

        // Районы показываем только когда они реально что-то фильтруют.
        // Ряд чипов, ни один из которых ничего не меняет, выглядит поломкой.
        _DistrictFilter(
          stores: stores,
          selected: district,
          onChanged: onDistrict,
          visible: outcome != null && outcome is! LocationFound,
        ),

        const SizedBox(height: Spacing.lg),
        for (final store in wholeChain) _WholeChainTile(store: store),

        for (final entry in byChain.entries) ...[
          const SizedBox(height: Spacing.sm),
          _ChainWithStores(
            chainCode: entry.key,
            chainName: entry.value.first.chainName,
            stores: _filtered(entry.value),
            highlight: missingStoreFor.contains(entry.key),
          ),
        ],
        const SizedBox(height: Spacing.xxl),
      ],
    );
  }

  List<Store> _filtered(List<Store> list) {
    if (district == null) return list;
    final matching = list
        .where(
          (s) => storeInDistrict(
            district: district!,
            address: s.address,
            name: s.name,
          ),
        )
        .toList();
    // Ни один магазин не попал в район — показываем все, а не пустоту.
    return matching.isEmpty ? list : matching;
  }
}

class _LocationBlock extends StatelessWidget {
  const _LocationBlock({
    required this.outcome,
    required this.locating,
    required this.onLocate,
  });

  final LocationOutcome? outcome;
  final bool locating;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final message = switch (outcome) {
      LocationDenied() => l10n.locationDenied,
      LocationDeniedForever() => l10n.locationDeniedForever,
      LocationServiceOff() => l10n.locationServiceOff,
      LocationFailed() => l10n.locationFailed,
      LocationFound() => l10n.locationFound,
      null => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: locating ? null : onLocate,
          icon: locating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
          label: Text(l10n.useMyLocation),
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.sm),
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.priceColors.staleData,
              ),
            ),
          ),
        if (outcome is LocationDeniedForever)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => const GeoLocator().openSettings(),
              child: Text(l10n.openSettings),
            ),
          ),
      ],
    );
  }
}

class _DistrictFilter extends StatelessWidget {
  const _DistrictFilter({
    required this.stores,
    required this.selected,
    required this.onChanged,
    required this.visible,
  });

  final List<Store> stores;
  final String? selected;
  final ValueChanged<String?> onChanged;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final available = districtsWithStores(
      stores.map((s) => (name: s.name, address: s.address)),
    );
    // Данных об адресах нет — фильтровать нечем, и обещать фильтр не станем.
    if (available.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final sorted = available.toList()..sort();

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.district, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            children: [
              ChoiceChip(
                label: Text(l10n.allDistricts),
                selected: selected == null,
                onSelected: (_) => onChanged(null),
              ),
              for (final d in sorted)
                ChoiceChip(
                  label: Text(d),
                  selected: selected == d,
                  onSelected: (_) => onChanged(d),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Сеть с единой ценой: обычный чекбокс на всю сеть.
class _WholeChainTile extends ConsumerWidget {
  const _WholeChainTile({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref
        .watch(storeSelectionProvider)
        .contains(store.chainCode);

    return CheckboxListTile(
      value: selected,
      onChanged: (_) => ref
          .read(storeSelectionProvider.notifier)
          .toggleChain(store.chainCode),
      title: Text(store.chainName),
      subtitle: Text(
        l10n.samePriceEverywhere,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

/// Сеть, где цена зависит от магазина: чекбокс сети плюс выбор точки.
class _ChainWithStores extends ConsumerWidget {
  const _ChainWithStores({
    required this.chainCode,
    required this.chainName,
    required this.stores,
    required this.highlight,
  });

  final String chainCode;
  final String chainName;
  final List<Store> stores;
  final bool highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selection = ref.watch(storeSelectionProvider);
    final controller = ref.read(storeSelectionProvider.notifier);
    final chainSelected = selection.contains(chainCode);

    final sorted = [...stores]
      ..sort((a, b) {
        final da = a.distanceM, db = b.distanceM;
        if (da != null && db != null) return da.compareTo(db);
        if (da != null) return -1;
        if (db != null) return 1;
        return a.name.compareTo(b.name);
      });

    return Card(
      color: highlight
          ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.35)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
        child: Column(
          children: [
            CheckboxListTile(
              value: chainSelected,
              onChanged: (_) => controller.toggleChain(chainCode),
              title: Text(chainName),
              subtitle: Text(
                // Никакого слова «зона»: человеку важно, что цены в разных
                // магазинах разные, а не как мы их у себя группируем.
                highlight
                    ? l10n.pickYourStoreRequired
                    : l10n.pricesDifferBetweenStores,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: highlight ? Theme.of(context).colorScheme.error : null,
                ),
              ),
              isThreeLine: false,
            ),
            if (chainSelected)
              for (final store in sorted)
                RadioListTile<int?>(
                  value: store.storeId,
                  groupValue: selection.pickedStoreChainCode == chainCode
                      ? selection.pickedStoreId
                      : null,
                  onChanged: (_) => controller.pickStore(store),
                  title: Text(store.name),
                  subtitle: _StoreSubtitle(store: store),
                  contentPadding: const EdgeInsets.only(
                    left: Spacing.xxl,
                    right: Spacing.lg,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _StoreSubtitle extends StatelessWidget {
  const _StoreSubtitle({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final parts = [
      if (store.address != null && store.address!.isNotEmpty) store.address!,
      if (store.distanceM != null) _distance(store.distanceM!),
    ];
    if (parts.isEmpty) return const SizedBox.shrink();

    return Text(
      parts.join(' · '),
      style: Theme.of(context).textTheme.labelSmall,
    );
  }

  /// До километра — метрами, дальше километрами с одним знаком.
  String _distance(int meters) =>
      meters < 1000 ? '$meters m' : '${(meters / 1000).toStringAsFixed(1)} km';
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.errorGeneric, textAlign: TextAlign.center),
            const SizedBox(height: Spacing.lg),
            FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
