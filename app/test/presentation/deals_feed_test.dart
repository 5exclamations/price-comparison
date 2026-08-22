import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qiymet/domain/models/deal.dart';
import 'package:qiymet/domain/models/deal_filters.dart';
import 'package:qiymet/domain/models/deals_page.dart';
import 'package:qiymet/domain/models/freshness.dart';
import 'package:qiymet/presentation/providers/deals_providers.dart';

import '../fakes/fake_catalog_repository.dart';

Deal deal(int id) => Deal(
  dealId: id,
  productId: id,
  name: 'Товар $id',
  chainCode: 'araz',
  priceMinor: 100,
  oldPriceMinor: 200,
  marketPriceMinor: 180,
  referenceChains: 2,
  claimedDiscount: 0.5,
  realDiscount: 0.44,
  inflation: 0.06,
  inflated: false,
  observedAt: DateTime.utc(2026, 8, 17),
);

DealsFeed feedFor(FakeCatalogRepository repo, {DealFilters? filters}) =>
    DealsFeed(repo, null, filters ?? DealFilters.none);

/// Дождаться, пока конструктор доедет до данных.
Future<DealsFeedState> settled(DealsFeed feed) async {
  while (feed.state.valueOrNull == null && !feed.state.hasError) {
    await Future<void>.delayed(Duration.zero);
  }
  return feed.state.value!;
}

void main() {
  group('курсорная пагинация', () {
    test('вторая страница дописывается к первой', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(
            value: DealsPage(
              items: [deal(1), deal(2)],
              nextCursor: 'c1',
              hasMore: true,
            ),
          ),
          Fresh(value: DealsPage(items: [deal(3), deal(4)])),
        ],
      );
      final feed = feedFor(repo);
      await settled(feed);

      await feed.loadMore();
      final state = feed.state.value!;

      expect(state.items.map((d) => d.dealId), [1, 2, 3, 4]);
      expect(state.hasMore, isFalse);
      expect(state.cursor, isNull, reason: 'курсор обязан обнулиться');
    });

    test('в конце ленты запросов больше не идёт', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(value: DealsPage(items: [deal(1)])),
        ],
      );
      final feed = feedFor(repo);
      await settled(feed);

      await feed.loadMore();
      await feed.loadMore();

      expect(repo.calls, 1, reason: 'после конца ленты дёргать API незачем');
    });

    test('во время догрузки повторный вызов не удваивает запрос', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(
            value: DealsPage(items: [deal(1)], nextCursor: 'c1', hasMore: true),
          ),
          Fresh(value: DealsPage(items: [deal(2)])),
        ],
        delay: const Duration(milliseconds: 30),
      );
      final feed = feedFor(repo);
      await settled(feed);

      final first = feed.loadMore();
      await feed.loadMore(); // прилетел, пока первый ещё в полёте
      await first;

      expect(repo.calls, 2);
      expect(feed.state.value!.items.length, 2);
    });
  });

  group('ошибка догрузки не стирает список', () {
    test('уже прочитанное остаётся на экране', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(
            value: DealsPage(
              items: [deal(1), deal(2)],
              nextCursor: 'c1',
              hasMore: true,
            ),
          ),
        ],
        failAfterFirst: true,
      );
      final feed = feedFor(repo);
      await settled(feed);

      await feed.loadMore();
      final state = feed.state.value!;

      // Человек прокрутил до конца — он не должен потерять то, что уже прочитал.
      expect(state.items.length, 2);
      expect(state.error, isNotNull);
      expect(state.loadingMore, isFalse);
      expect(state.cursor, 'c1', reason: 'повтор должен быть возможен');
    });

    test('повтор после ошибки срабатывает', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(
            value: DealsPage(items: [deal(1)], nextCursor: 'c1', hasMore: true),
          ),
          Fresh(value: DealsPage(items: [deal(2)])),
        ],
        failOnCall: 2,
      );
      final feed = feedFor(repo);
      await settled(feed);

      await feed.loadMore();
      expect(feed.state.value!.error, isNotNull);

      await feed.loadMore();
      expect(feed.state.value!.items.length, 2);
      expect(feed.state.value!.error, isNull);
    });

    test('ошибка ПЕРВОЙ страницы кладёт весь экран в ошибку', () async {
      final repo = FakeCatalogRepository(pages: const [], failOnCall: 1);
      final feed = feedFor(repo);

      while (!feed.state.hasError) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(feed.state.hasError, isTrue);
    });
  });

  group('оффлайн', () {
    test('кеш показывается с временем и без догрузки', () async {
      final cachedAt = DateTime.utc(2026, 8, 17, 14, 20);
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(
            value: DealsPage(items: [deal(1), deal(2)]),
            fromCache: true,
            cachedAt: cachedAt,
          ),
        ],
      );
      final feed = feedFor(repo);
      final state = await settled(feed);

      expect(state.fromCache, isTrue);
      expect(state.needsStaleWarning, isTrue);
      expect(state.cachedAt, cachedAt);

      await feed.loadMore();
      expect(repo.calls, 1, reason: 'догружать из кеша нечего');
    });
  });

  group('фильтры уходят на сервер', () {
    test('все три передаются в репозиторий', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(value: DealsPage(items: [deal(1)])),
        ],
      );
      const filters = DealFilters(
        category: 'süd',
        minDiscount: 0.4,
        chains: {'araz', 'spar'},
      );
      await settled(feedFor(repo, filters: filters));

      expect(repo.lastCategory, 'süd');
      expect(repo.lastMinDiscount, 0.4);
      expect(repo.lastChains, 'araz,spar');
    });

    test('без фильтров ничего лишнего не отправляется', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(value: DealsPage(items: [deal(1)])),
        ],
      );
      await settled(feedFor(repo));

      expect(repo.lastCategory, isNull);
      expect(repo.lastMinDiscount, isNull);
      expect(repo.lastChains, isNull);
    });

    test('фильтры сохраняются при догрузке', () async {
      final repo = FakeCatalogRepository(
        pages: [
          Fresh(
            value: DealsPage(items: [deal(1)], nextCursor: 'c1', hasMore: true),
          ),
          Fresh(value: DealsPage(items: [deal(2)])),
        ],
      );
      final feed = feedFor(repo, filters: const DealFilters(chains: {'araz'}));
      await settled(feed);
      await feed.loadMore();

      expect(
        repo.lastChains,
        'araz',
        reason: 'вторая страница обязана прийти с тем же фильтром',
      );
      expect(repo.lastCursor, 'c1');
    });
  });

  test('refresh начинает ленту заново', () async {
    final repo = FakeCatalogRepository(
      pages: [
        Fresh(
          value: DealsPage(items: [deal(1)], nextCursor: 'c1', hasMore: true),
        ),
        Fresh(value: DealsPage(items: [deal(2)])),
        Fresh(value: DealsPage(items: [deal(9)])),
      ],
    );
    final feed = feedFor(repo);
    await settled(feed);
    await feed.loadMore();
    expect(feed.state.value!.items.length, 2);

    await feed.refresh();
    expect(feed.state.value!.items.map((d) => d.dealId), [9]);
    expect(feed.state.value!.error, isNull);
  });
}
