// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_cache.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eanMeta = const VerificationMeta('ean');
  @override
  late final GeneratedColumn<String> ean = GeneratedColumn<String>(
    'ean',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitValueMeta = const VerificationMeta(
    'unitValue',
  );
  @override
  late final GeneratedColumn<double> unitValue = GeneratedColumn<double>(
    'unit_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestPriceMinorMeta = const VerificationMeta(
    'bestPriceMinor',
  );
  @override
  late final GeneratedColumn<int> bestPriceMinor = GeneratedColumn<int>(
    'best_price_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestPriceChainMeta = const VerificationMeta(
    'bestPriceChain',
  );
  @override
  late final GeneratedColumn<String> bestPriceChain = GeneratedColumn<String>(
    'best_price_chain',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chainsCountMeta = const VerificationMeta(
    'chainsCount',
  );
  @override
  late final GeneratedColumn<int> chainsCount = GeneratedColumn<int>(
    'chains_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hasPromoMeta = const VerificationMeta(
    'hasPromo',
  );
  @override
  late final GeneratedColumn<bool> hasPromo = GeneratedColumn<bool>(
    'has_promo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_promo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _needsStoreSelectionMeta =
      const VerificationMeta('needsStoreSelection');
  @override
  late final GeneratedColumn<bool> needsStoreSelection = GeneratedColumn<bool>(
    'needs_store_selection',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_store_selection" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _observedAtMeta = const VerificationMeta(
    'observedAt',
  );
  @override
  late final GeneratedColumn<DateTime> observedAt = GeneratedColumn<DateTime>(
    'observed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    productId,
    name,
    brand,
    ean,
    unitValue,
    unitType,
    bestPriceMinor,
    bestPriceChain,
    chainsCount,
    hasPromo,
    needsStoreSelection,
    observedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('ean')) {
      context.handle(
        _eanMeta,
        ean.isAcceptableOrUnknown(data['ean']!, _eanMeta),
      );
    }
    if (data.containsKey('unit_value')) {
      context.handle(
        _unitValueMeta,
        unitValue.isAcceptableOrUnknown(data['unit_value']!, _unitValueMeta),
      );
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    }
    if (data.containsKey('best_price_minor')) {
      context.handle(
        _bestPriceMinorMeta,
        bestPriceMinor.isAcceptableOrUnknown(
          data['best_price_minor']!,
          _bestPriceMinorMeta,
        ),
      );
    }
    if (data.containsKey('best_price_chain')) {
      context.handle(
        _bestPriceChainMeta,
        bestPriceChain.isAcceptableOrUnknown(
          data['best_price_chain']!,
          _bestPriceChainMeta,
        ),
      );
    }
    if (data.containsKey('chains_count')) {
      context.handle(
        _chainsCountMeta,
        chainsCount.isAcceptableOrUnknown(
          data['chains_count']!,
          _chainsCountMeta,
        ),
      );
    }
    if (data.containsKey('has_promo')) {
      context.handle(
        _hasPromoMeta,
        hasPromo.isAcceptableOrUnknown(data['has_promo']!, _hasPromoMeta),
      );
    }
    if (data.containsKey('needs_store_selection')) {
      context.handle(
        _needsStoreSelectionMeta,
        needsStoreSelection.isAcceptableOrUnknown(
          data['needs_store_selection']!,
          _needsStoreSelectionMeta,
        ),
      );
    }
    if (data.containsKey('observed_at')) {
      context.handle(
        _observedAtMeta,
        observedAt.isAcceptableOrUnknown(data['observed_at']!, _observedAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productId};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      ean: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ean'],
      ),
      unitValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_value'],
      ),
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      ),
      bestPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_price_minor'],
      ),
      bestPriceChain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}best_price_chain'],
      ),
      chainsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chains_count'],
      )!,
      hasPromo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_promo'],
      )!,
      needsStoreSelection: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_store_selection'],
      )!,
      observedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}observed_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final int productId;
  final String name;
  final String? brand;
  final String? ean;
  final double? unitValue;
  final String? unitType;
  final int? bestPriceMinor;
  final String? bestPriceChain;
  final int chainsCount;
  final bool hasPromo;
  final bool needsStoreSelection;

  /// Время НАБЛЮДЕНИЯ цены, а не время записи в кеш. Показывать цену без него
  /// нельзя, поэтому и в кеше оно обязано лежать рядом.
  final DateTime? observedAt;

  /// Когда положили в кеш. По нему считается плашка «данные от 14:20».
  final DateTime cachedAt;
  const CachedProduct({
    required this.productId,
    required this.name,
    this.brand,
    this.ean,
    this.unitValue,
    this.unitType,
    this.bestPriceMinor,
    this.bestPriceChain,
    required this.chainsCount,
    required this.hasPromo,
    required this.needsStoreSelection,
    this.observedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['product_id'] = Variable<int>(productId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || ean != null) {
      map['ean'] = Variable<String>(ean);
    }
    if (!nullToAbsent || unitValue != null) {
      map['unit_value'] = Variable<double>(unitValue);
    }
    if (!nullToAbsent || unitType != null) {
      map['unit_type'] = Variable<String>(unitType);
    }
    if (!nullToAbsent || bestPriceMinor != null) {
      map['best_price_minor'] = Variable<int>(bestPriceMinor);
    }
    if (!nullToAbsent || bestPriceChain != null) {
      map['best_price_chain'] = Variable<String>(bestPriceChain);
    }
    map['chains_count'] = Variable<int>(chainsCount);
    map['has_promo'] = Variable<bool>(hasPromo);
    map['needs_store_selection'] = Variable<bool>(needsStoreSelection);
    if (!nullToAbsent || observedAt != null) {
      map['observed_at'] = Variable<DateTime>(observedAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      productId: Value(productId),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      ean: ean == null && nullToAbsent ? const Value.absent() : Value(ean),
      unitValue: unitValue == null && nullToAbsent
          ? const Value.absent()
          : Value(unitValue),
      unitType: unitType == null && nullToAbsent
          ? const Value.absent()
          : Value(unitType),
      bestPriceMinor: bestPriceMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(bestPriceMinor),
      bestPriceChain: bestPriceChain == null && nullToAbsent
          ? const Value.absent()
          : Value(bestPriceChain),
      chainsCount: Value(chainsCount),
      hasPromo: Value(hasPromo),
      needsStoreSelection: Value(needsStoreSelection),
      observedAt: observedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(observedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      productId: serializer.fromJson<int>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      ean: serializer.fromJson<String?>(json['ean']),
      unitValue: serializer.fromJson<double?>(json['unitValue']),
      unitType: serializer.fromJson<String?>(json['unitType']),
      bestPriceMinor: serializer.fromJson<int?>(json['bestPriceMinor']),
      bestPriceChain: serializer.fromJson<String?>(json['bestPriceChain']),
      chainsCount: serializer.fromJson<int>(json['chainsCount']),
      hasPromo: serializer.fromJson<bool>(json['hasPromo']),
      needsStoreSelection: serializer.fromJson<bool>(
        json['needsStoreSelection'],
      ),
      observedAt: serializer.fromJson<DateTime?>(json['observedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'productId': serializer.toJson<int>(productId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'ean': serializer.toJson<String?>(ean),
      'unitValue': serializer.toJson<double?>(unitValue),
      'unitType': serializer.toJson<String?>(unitType),
      'bestPriceMinor': serializer.toJson<int?>(bestPriceMinor),
      'bestPriceChain': serializer.toJson<String?>(bestPriceChain),
      'chainsCount': serializer.toJson<int>(chainsCount),
      'hasPromo': serializer.toJson<bool>(hasPromo),
      'needsStoreSelection': serializer.toJson<bool>(needsStoreSelection),
      'observedAt': serializer.toJson<DateTime?>(observedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedProduct copyWith({
    int? productId,
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> ean = const Value.absent(),
    Value<double?> unitValue = const Value.absent(),
    Value<String?> unitType = const Value.absent(),
    Value<int?> bestPriceMinor = const Value.absent(),
    Value<String?> bestPriceChain = const Value.absent(),
    int? chainsCount,
    bool? hasPromo,
    bool? needsStoreSelection,
    Value<DateTime?> observedAt = const Value.absent(),
    DateTime? cachedAt,
  }) => CachedProduct(
    productId: productId ?? this.productId,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    ean: ean.present ? ean.value : this.ean,
    unitValue: unitValue.present ? unitValue.value : this.unitValue,
    unitType: unitType.present ? unitType.value : this.unitType,
    bestPriceMinor: bestPriceMinor.present
        ? bestPriceMinor.value
        : this.bestPriceMinor,
    bestPriceChain: bestPriceChain.present
        ? bestPriceChain.value
        : this.bestPriceChain,
    chainsCount: chainsCount ?? this.chainsCount,
    hasPromo: hasPromo ?? this.hasPromo,
    needsStoreSelection: needsStoreSelection ?? this.needsStoreSelection,
    observedAt: observedAt.present ? observedAt.value : this.observedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      ean: data.ean.present ? data.ean.value : this.ean,
      unitValue: data.unitValue.present ? data.unitValue.value : this.unitValue,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      bestPriceMinor: data.bestPriceMinor.present
          ? data.bestPriceMinor.value
          : this.bestPriceMinor,
      bestPriceChain: data.bestPriceChain.present
          ? data.bestPriceChain.value
          : this.bestPriceChain,
      chainsCount: data.chainsCount.present
          ? data.chainsCount.value
          : this.chainsCount,
      hasPromo: data.hasPromo.present ? data.hasPromo.value : this.hasPromo,
      needsStoreSelection: data.needsStoreSelection.present
          ? data.needsStoreSelection.value
          : this.needsStoreSelection,
      observedAt: data.observedAt.present
          ? data.observedAt.value
          : this.observedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('ean: $ean, ')
          ..write('unitValue: $unitValue, ')
          ..write('unitType: $unitType, ')
          ..write('bestPriceMinor: $bestPriceMinor, ')
          ..write('bestPriceChain: $bestPriceChain, ')
          ..write('chainsCount: $chainsCount, ')
          ..write('hasPromo: $hasPromo, ')
          ..write('needsStoreSelection: $needsStoreSelection, ')
          ..write('observedAt: $observedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    productId,
    name,
    brand,
    ean,
    unitValue,
    unitType,
    bestPriceMinor,
    bestPriceChain,
    chainsCount,
    hasPromo,
    needsStoreSelection,
    observedAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.ean == this.ean &&
          other.unitValue == this.unitValue &&
          other.unitType == this.unitType &&
          other.bestPriceMinor == this.bestPriceMinor &&
          other.bestPriceChain == this.bestPriceChain &&
          other.chainsCount == this.chainsCount &&
          other.hasPromo == this.hasPromo &&
          other.needsStoreSelection == this.needsStoreSelection &&
          other.observedAt == this.observedAt &&
          other.cachedAt == this.cachedAt);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<int> productId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> ean;
  final Value<double?> unitValue;
  final Value<String?> unitType;
  final Value<int?> bestPriceMinor;
  final Value<String?> bestPriceChain;
  final Value<int> chainsCount;
  final Value<bool> hasPromo;
  final Value<bool> needsStoreSelection;
  final Value<DateTime?> observedAt;
  final Value<DateTime> cachedAt;
  const CachedProductsCompanion({
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.ean = const Value.absent(),
    this.unitValue = const Value.absent(),
    this.unitType = const Value.absent(),
    this.bestPriceMinor = const Value.absent(),
    this.bestPriceChain = const Value.absent(),
    this.chainsCount = const Value.absent(),
    this.hasPromo = const Value.absent(),
    this.needsStoreSelection = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    this.productId = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.ean = const Value.absent(),
    this.unitValue = const Value.absent(),
    this.unitType = const Value.absent(),
    this.bestPriceMinor = const Value.absent(),
    this.bestPriceChain = const Value.absent(),
    this.chainsCount = const Value.absent(),
    this.hasPromo = const Value.absent(),
    this.needsStoreSelection = const Value.absent(),
    this.observedAt = const Value.absent(),
    required DateTime cachedAt,
  }) : name = Value(name),
       cachedAt = Value(cachedAt);
  static Insertable<CachedProduct> custom({
    Expression<int>? productId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? ean,
    Expression<double>? unitValue,
    Expression<String>? unitType,
    Expression<int>? bestPriceMinor,
    Expression<String>? bestPriceChain,
    Expression<int>? chainsCount,
    Expression<bool>? hasPromo,
    Expression<bool>? needsStoreSelection,
    Expression<DateTime>? observedAt,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (ean != null) 'ean': ean,
      if (unitValue != null) 'unit_value': unitValue,
      if (unitType != null) 'unit_type': unitType,
      if (bestPriceMinor != null) 'best_price_minor': bestPriceMinor,
      if (bestPriceChain != null) 'best_price_chain': bestPriceChain,
      if (chainsCount != null) 'chains_count': chainsCount,
      if (hasPromo != null) 'has_promo': hasPromo,
      if (needsStoreSelection != null)
        'needs_store_selection': needsStoreSelection,
      if (observedAt != null) 'observed_at': observedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CachedProductsCompanion copyWith({
    Value<int>? productId,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? ean,
    Value<double?>? unitValue,
    Value<String?>? unitType,
    Value<int?>? bestPriceMinor,
    Value<String?>? bestPriceChain,
    Value<int>? chainsCount,
    Value<bool>? hasPromo,
    Value<bool>? needsStoreSelection,
    Value<DateTime?>? observedAt,
    Value<DateTime>? cachedAt,
  }) {
    return CachedProductsCompanion(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      ean: ean ?? this.ean,
      unitValue: unitValue ?? this.unitValue,
      unitType: unitType ?? this.unitType,
      bestPriceMinor: bestPriceMinor ?? this.bestPriceMinor,
      bestPriceChain: bestPriceChain ?? this.bestPriceChain,
      chainsCount: chainsCount ?? this.chainsCount,
      hasPromo: hasPromo ?? this.hasPromo,
      needsStoreSelection: needsStoreSelection ?? this.needsStoreSelection,
      observedAt: observedAt ?? this.observedAt,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (ean.present) {
      map['ean'] = Variable<String>(ean.value);
    }
    if (unitValue.present) {
      map['unit_value'] = Variable<double>(unitValue.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (bestPriceMinor.present) {
      map['best_price_minor'] = Variable<int>(bestPriceMinor.value);
    }
    if (bestPriceChain.present) {
      map['best_price_chain'] = Variable<String>(bestPriceChain.value);
    }
    if (chainsCount.present) {
      map['chains_count'] = Variable<int>(chainsCount.value);
    }
    if (hasPromo.present) {
      map['has_promo'] = Variable<bool>(hasPromo.value);
    }
    if (needsStoreSelection.present) {
      map['needs_store_selection'] = Variable<bool>(needsStoreSelection.value);
    }
    if (observedAt.present) {
      map['observed_at'] = Variable<DateTime>(observedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('ean: $ean, ')
          ..write('unitValue: $unitValue, ')
          ..write('unitType: $unitType, ')
          ..write('bestPriceMinor: $bestPriceMinor, ')
          ..write('bestPriceChain: $bestPriceChain, ')
          ..write('chainsCount: $chainsCount, ')
          ..write('hasPromo: $hasPromo, ')
          ..write('needsStoreSelection: $needsStoreSelection, ')
          ..write('observedAt: $observedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $CachedSearchesTable extends CachedSearches
    with TableInfo<$CachedSearchesTable, CachedSearche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSearchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryKeyMeta = const VerificationMeta(
    'queryKey',
  );
  @override
  late final GeneratedColumn<String> queryKey = GeneratedColumn<String>(
    'query_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdsMeta = const VerificationMeta(
    'productIds',
  );
  @override
  late final GeneratedColumn<String> productIds = GeneratedColumn<String>(
    'product_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [queryKey, productIds, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_searches';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedSearche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query_key')) {
      context.handle(
        _queryKeyMeta,
        queryKey.isAcceptableOrUnknown(data['query_key']!, _queryKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_queryKeyMeta);
    }
    if (data.containsKey('product_ids')) {
      context.handle(
        _productIdsMeta,
        productIds.isAcceptableOrUnknown(data['product_ids']!, _productIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdsMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queryKey};
  @override
  CachedSearche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSearche(
      queryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query_key'],
      )!,
      productIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_ids'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedSearchesTable createAlias(String alias) {
    return $CachedSearchesTable(attachedDatabase, alias);
  }
}

class CachedSearche extends DataClass implements Insertable<CachedSearche> {
  final String queryKey;
  final String productIds;
  final DateTime cachedAt;
  const CachedSearche({
    required this.queryKey,
    required this.productIds,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query_key'] = Variable<String>(queryKey);
    map['product_ids'] = Variable<String>(productIds);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedSearchesCompanion toCompanion(bool nullToAbsent) {
    return CachedSearchesCompanion(
      queryKey: Value(queryKey),
      productIds: Value(productIds),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedSearche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSearche(
      queryKey: serializer.fromJson<String>(json['queryKey']),
      productIds: serializer.fromJson<String>(json['productIds']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryKey': serializer.toJson<String>(queryKey),
      'productIds': serializer.toJson<String>(productIds),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedSearche copyWith({
    String? queryKey,
    String? productIds,
    DateTime? cachedAt,
  }) => CachedSearche(
    queryKey: queryKey ?? this.queryKey,
    productIds: productIds ?? this.productIds,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedSearche copyWithCompanion(CachedSearchesCompanion data) {
    return CachedSearche(
      queryKey: data.queryKey.present ? data.queryKey.value : this.queryKey,
      productIds: data.productIds.present
          ? data.productIds.value
          : this.productIds,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSearche(')
          ..write('queryKey: $queryKey, ')
          ..write('productIds: $productIds, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queryKey, productIds, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSearche &&
          other.queryKey == this.queryKey &&
          other.productIds == this.productIds &&
          other.cachedAt == this.cachedAt);
}

class CachedSearchesCompanion extends UpdateCompanion<CachedSearche> {
  final Value<String> queryKey;
  final Value<String> productIds;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedSearchesCompanion({
    this.queryKey = const Value.absent(),
    this.productIds = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSearchesCompanion.insert({
    required String queryKey,
    required String productIds,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : queryKey = Value(queryKey),
       productIds = Value(productIds),
       cachedAt = Value(cachedAt);
  static Insertable<CachedSearche> custom({
    Expression<String>? queryKey,
    Expression<String>? productIds,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (queryKey != null) 'query_key': queryKey,
      if (productIds != null) 'product_ids': productIds,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSearchesCompanion copyWith({
    Value<String>? queryKey,
    Value<String>? productIds,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedSearchesCompanion(
      queryKey: queryKey ?? this.queryKey,
      productIds: productIds ?? this.productIds,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queryKey.present) {
      map['query_key'] = Variable<String>(queryKey.value);
    }
    if (productIds.present) {
      map['product_ids'] = Variable<String>(productIds.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSearchesCompanion(')
          ..write('queryKey: $queryKey, ')
          ..write('productIds: $productIds, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedDealsTable extends CachedDeals
    with TableInfo<$CachedDealsTable, CachedDeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dealIdMeta = const VerificationMeta('dealId');
  @override
  late final GeneratedColumn<int> dealId = GeneratedColumn<int>(
    'deal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chainCodeMeta = const VerificationMeta(
    'chainCode',
  );
  @override
  late final GeneratedColumn<String> chainCode = GeneratedColumn<String>(
    'chain_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<int> storeId = GeneratedColumn<int>(
    'store_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeNameMeta = const VerificationMeta(
    'storeName',
  );
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
    'store_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMinorMeta = const VerificationMeta(
    'priceMinor',
  );
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldPriceMinorMeta = const VerificationMeta(
    'oldPriceMinor',
  );
  @override
  late final GeneratedColumn<int> oldPriceMinor = GeneratedColumn<int>(
    'old_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marketPriceMinorMeta = const VerificationMeta(
    'marketPriceMinor',
  );
  @override
  late final GeneratedColumn<int> marketPriceMinor = GeneratedColumn<int>(
    'market_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _claimedDiscountMeta = const VerificationMeta(
    'claimedDiscount',
  );
  @override
  late final GeneratedColumn<double> claimedDiscount = GeneratedColumn<double>(
    'claimed_discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _realDiscountMeta = const VerificationMeta(
    'realDiscount',
  );
  @override
  late final GeneratedColumn<double> realDiscount = GeneratedColumn<double>(
    'real_discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inflationMeta = const VerificationMeta(
    'inflation',
  );
  @override
  late final GeneratedColumn<double> inflation = GeneratedColumn<double>(
    'inflation',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inflatedMeta = const VerificationMeta(
    'inflated',
  );
  @override
  late final GeneratedColumn<bool> inflated = GeneratedColumn<bool>(
    'inflated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inflated" IN (0, 1))',
    ),
  );
  static const VerificationMeta _observedAtMeta = const VerificationMeta(
    'observedAt',
  );
  @override
  late final GeneratedColumn<DateTime> observedAt = GeneratedColumn<DateTime>(
    'observed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeStoreIdMeta = const VerificationMeta(
    'scopeStoreId',
  );
  @override
  late final GeneratedColumn<int> scopeStoreId = GeneratedColumn<int>(
    'scope_store_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dealId,
    productId,
    name,
    chainCode,
    storeId,
    storeName,
    priceMinor,
    oldPriceMinor,
    marketPriceMinor,
    claimedDiscount,
    realDiscount,
    inflation,
    inflated,
    observedAt,
    scopeStoreId,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_deals';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDeal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('deal_id')) {
      context.handle(
        _dealIdMeta,
        dealId.isAcceptableOrUnknown(data['deal_id']!, _dealIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('chain_code')) {
      context.handle(
        _chainCodeMeta,
        chainCode.isAcceptableOrUnknown(data['chain_code']!, _chainCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_chainCodeMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    }
    if (data.containsKey('store_name')) {
      context.handle(
        _storeNameMeta,
        storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta),
      );
    }
    if (data.containsKey('price_minor')) {
      context.handle(
        _priceMinorMeta,
        priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMinorMeta);
    }
    if (data.containsKey('old_price_minor')) {
      context.handle(
        _oldPriceMinorMeta,
        oldPriceMinor.isAcceptableOrUnknown(
          data['old_price_minor']!,
          _oldPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_oldPriceMinorMeta);
    }
    if (data.containsKey('market_price_minor')) {
      context.handle(
        _marketPriceMinorMeta,
        marketPriceMinor.isAcceptableOrUnknown(
          data['market_price_minor']!,
          _marketPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_marketPriceMinorMeta);
    }
    if (data.containsKey('claimed_discount')) {
      context.handle(
        _claimedDiscountMeta,
        claimedDiscount.isAcceptableOrUnknown(
          data['claimed_discount']!,
          _claimedDiscountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_claimedDiscountMeta);
    }
    if (data.containsKey('real_discount')) {
      context.handle(
        _realDiscountMeta,
        realDiscount.isAcceptableOrUnknown(
          data['real_discount']!,
          _realDiscountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_realDiscountMeta);
    }
    if (data.containsKey('inflation')) {
      context.handle(
        _inflationMeta,
        inflation.isAcceptableOrUnknown(data['inflation']!, _inflationMeta),
      );
    } else if (isInserting) {
      context.missing(_inflationMeta);
    }
    if (data.containsKey('inflated')) {
      context.handle(
        _inflatedMeta,
        inflated.isAcceptableOrUnknown(data['inflated']!, _inflatedMeta),
      );
    } else if (isInserting) {
      context.missing(_inflatedMeta);
    }
    if (data.containsKey('observed_at')) {
      context.handle(
        _observedAtMeta,
        observedAt.isAcceptableOrUnknown(data['observed_at']!, _observedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_observedAtMeta);
    }
    if (data.containsKey('scope_store_id')) {
      context.handle(
        _scopeStoreIdMeta,
        scopeStoreId.isAcceptableOrUnknown(
          data['scope_store_id']!,
          _scopeStoreIdMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dealId};
  @override
  CachedDeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDeal(
      dealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deal_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      chainCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chain_code'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}store_id'],
      ),
      storeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_name'],
      ),
      priceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_minor'],
      )!,
      oldPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}old_price_minor'],
      )!,
      marketPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}market_price_minor'],
      )!,
      claimedDiscount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}claimed_discount'],
      )!,
      realDiscount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}real_discount'],
      )!,
      inflation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}inflation'],
      )!,
      inflated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inflated'],
      )!,
      observedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}observed_at'],
      )!,
      scopeStoreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scope_store_id'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedDealsTable createAlias(String alias) {
    return $CachedDealsTable(attachedDatabase, alias);
  }
}

class CachedDeal extends DataClass implements Insertable<CachedDeal> {
  final int dealId;
  final int productId;
  final String name;
  final String chainCode;
  final int? storeId;
  final String? storeName;
  final int priceMinor;
  final int oldPriceMinor;
  final int marketPriceMinor;
  final double claimedDiscount;
  final double realDiscount;
  final double inflation;
  final bool inflated;
  final DateTime observedAt;

  /// null = лента без выбранного магазина.
  final int? scopeStoreId;
  final DateTime cachedAt;
  const CachedDeal({
    required this.dealId,
    required this.productId,
    required this.name,
    required this.chainCode,
    this.storeId,
    this.storeName,
    required this.priceMinor,
    required this.oldPriceMinor,
    required this.marketPriceMinor,
    required this.claimedDiscount,
    required this.realDiscount,
    required this.inflation,
    required this.inflated,
    required this.observedAt,
    this.scopeStoreId,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['deal_id'] = Variable<int>(dealId);
    map['product_id'] = Variable<int>(productId);
    map['name'] = Variable<String>(name);
    map['chain_code'] = Variable<String>(chainCode);
    if (!nullToAbsent || storeId != null) {
      map['store_id'] = Variable<int>(storeId);
    }
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    map['price_minor'] = Variable<int>(priceMinor);
    map['old_price_minor'] = Variable<int>(oldPriceMinor);
    map['market_price_minor'] = Variable<int>(marketPriceMinor);
    map['claimed_discount'] = Variable<double>(claimedDiscount);
    map['real_discount'] = Variable<double>(realDiscount);
    map['inflation'] = Variable<double>(inflation);
    map['inflated'] = Variable<bool>(inflated);
    map['observed_at'] = Variable<DateTime>(observedAt);
    if (!nullToAbsent || scopeStoreId != null) {
      map['scope_store_id'] = Variable<int>(scopeStoreId);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedDealsCompanion toCompanion(bool nullToAbsent) {
    return CachedDealsCompanion(
      dealId: Value(dealId),
      productId: Value(productId),
      name: Value(name),
      chainCode: Value(chainCode),
      storeId: storeId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeId),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      priceMinor: Value(priceMinor),
      oldPriceMinor: Value(oldPriceMinor),
      marketPriceMinor: Value(marketPriceMinor),
      claimedDiscount: Value(claimedDiscount),
      realDiscount: Value(realDiscount),
      inflation: Value(inflation),
      inflated: Value(inflated),
      observedAt: Value(observedAt),
      scopeStoreId: scopeStoreId == null && nullToAbsent
          ? const Value.absent()
          : Value(scopeStoreId),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedDeal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDeal(
      dealId: serializer.fromJson<int>(json['dealId']),
      productId: serializer.fromJson<int>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      chainCode: serializer.fromJson<String>(json['chainCode']),
      storeId: serializer.fromJson<int?>(json['storeId']),
      storeName: serializer.fromJson<String?>(json['storeName']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      oldPriceMinor: serializer.fromJson<int>(json['oldPriceMinor']),
      marketPriceMinor: serializer.fromJson<int>(json['marketPriceMinor']),
      claimedDiscount: serializer.fromJson<double>(json['claimedDiscount']),
      realDiscount: serializer.fromJson<double>(json['realDiscount']),
      inflation: serializer.fromJson<double>(json['inflation']),
      inflated: serializer.fromJson<bool>(json['inflated']),
      observedAt: serializer.fromJson<DateTime>(json['observedAt']),
      scopeStoreId: serializer.fromJson<int?>(json['scopeStoreId']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dealId': serializer.toJson<int>(dealId),
      'productId': serializer.toJson<int>(productId),
      'name': serializer.toJson<String>(name),
      'chainCode': serializer.toJson<String>(chainCode),
      'storeId': serializer.toJson<int?>(storeId),
      'storeName': serializer.toJson<String?>(storeName),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'oldPriceMinor': serializer.toJson<int>(oldPriceMinor),
      'marketPriceMinor': serializer.toJson<int>(marketPriceMinor),
      'claimedDiscount': serializer.toJson<double>(claimedDiscount),
      'realDiscount': serializer.toJson<double>(realDiscount),
      'inflation': serializer.toJson<double>(inflation),
      'inflated': serializer.toJson<bool>(inflated),
      'observedAt': serializer.toJson<DateTime>(observedAt),
      'scopeStoreId': serializer.toJson<int?>(scopeStoreId),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedDeal copyWith({
    int? dealId,
    int? productId,
    String? name,
    String? chainCode,
    Value<int?> storeId = const Value.absent(),
    Value<String?> storeName = const Value.absent(),
    int? priceMinor,
    int? oldPriceMinor,
    int? marketPriceMinor,
    double? claimedDiscount,
    double? realDiscount,
    double? inflation,
    bool? inflated,
    DateTime? observedAt,
    Value<int?> scopeStoreId = const Value.absent(),
    DateTime? cachedAt,
  }) => CachedDeal(
    dealId: dealId ?? this.dealId,
    productId: productId ?? this.productId,
    name: name ?? this.name,
    chainCode: chainCode ?? this.chainCode,
    storeId: storeId.present ? storeId.value : this.storeId,
    storeName: storeName.present ? storeName.value : this.storeName,
    priceMinor: priceMinor ?? this.priceMinor,
    oldPriceMinor: oldPriceMinor ?? this.oldPriceMinor,
    marketPriceMinor: marketPriceMinor ?? this.marketPriceMinor,
    claimedDiscount: claimedDiscount ?? this.claimedDiscount,
    realDiscount: realDiscount ?? this.realDiscount,
    inflation: inflation ?? this.inflation,
    inflated: inflated ?? this.inflated,
    observedAt: observedAt ?? this.observedAt,
    scopeStoreId: scopeStoreId.present ? scopeStoreId.value : this.scopeStoreId,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedDeal copyWithCompanion(CachedDealsCompanion data) {
    return CachedDeal(
      dealId: data.dealId.present ? data.dealId.value : this.dealId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      chainCode: data.chainCode.present ? data.chainCode.value : this.chainCode,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      priceMinor: data.priceMinor.present
          ? data.priceMinor.value
          : this.priceMinor,
      oldPriceMinor: data.oldPriceMinor.present
          ? data.oldPriceMinor.value
          : this.oldPriceMinor,
      marketPriceMinor: data.marketPriceMinor.present
          ? data.marketPriceMinor.value
          : this.marketPriceMinor,
      claimedDiscount: data.claimedDiscount.present
          ? data.claimedDiscount.value
          : this.claimedDiscount,
      realDiscount: data.realDiscount.present
          ? data.realDiscount.value
          : this.realDiscount,
      inflation: data.inflation.present ? data.inflation.value : this.inflation,
      inflated: data.inflated.present ? data.inflated.value : this.inflated,
      observedAt: data.observedAt.present
          ? data.observedAt.value
          : this.observedAt,
      scopeStoreId: data.scopeStoreId.present
          ? data.scopeStoreId.value
          : this.scopeStoreId,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDeal(')
          ..write('dealId: $dealId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('chainCode: $chainCode, ')
          ..write('storeId: $storeId, ')
          ..write('storeName: $storeName, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('oldPriceMinor: $oldPriceMinor, ')
          ..write('marketPriceMinor: $marketPriceMinor, ')
          ..write('claimedDiscount: $claimedDiscount, ')
          ..write('realDiscount: $realDiscount, ')
          ..write('inflation: $inflation, ')
          ..write('inflated: $inflated, ')
          ..write('observedAt: $observedAt, ')
          ..write('scopeStoreId: $scopeStoreId, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dealId,
    productId,
    name,
    chainCode,
    storeId,
    storeName,
    priceMinor,
    oldPriceMinor,
    marketPriceMinor,
    claimedDiscount,
    realDiscount,
    inflation,
    inflated,
    observedAt,
    scopeStoreId,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDeal &&
          other.dealId == this.dealId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.chainCode == this.chainCode &&
          other.storeId == this.storeId &&
          other.storeName == this.storeName &&
          other.priceMinor == this.priceMinor &&
          other.oldPriceMinor == this.oldPriceMinor &&
          other.marketPriceMinor == this.marketPriceMinor &&
          other.claimedDiscount == this.claimedDiscount &&
          other.realDiscount == this.realDiscount &&
          other.inflation == this.inflation &&
          other.inflated == this.inflated &&
          other.observedAt == this.observedAt &&
          other.scopeStoreId == this.scopeStoreId &&
          other.cachedAt == this.cachedAt);
}

class CachedDealsCompanion extends UpdateCompanion<CachedDeal> {
  final Value<int> dealId;
  final Value<int> productId;
  final Value<String> name;
  final Value<String> chainCode;
  final Value<int?> storeId;
  final Value<String?> storeName;
  final Value<int> priceMinor;
  final Value<int> oldPriceMinor;
  final Value<int> marketPriceMinor;
  final Value<double> claimedDiscount;
  final Value<double> realDiscount;
  final Value<double> inflation;
  final Value<bool> inflated;
  final Value<DateTime> observedAt;
  final Value<int?> scopeStoreId;
  final Value<DateTime> cachedAt;
  const CachedDealsCompanion({
    this.dealId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.chainCode = const Value.absent(),
    this.storeId = const Value.absent(),
    this.storeName = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.oldPriceMinor = const Value.absent(),
    this.marketPriceMinor = const Value.absent(),
    this.claimedDiscount = const Value.absent(),
    this.realDiscount = const Value.absent(),
    this.inflation = const Value.absent(),
    this.inflated = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.scopeStoreId = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CachedDealsCompanion.insert({
    this.dealId = const Value.absent(),
    required int productId,
    required String name,
    required String chainCode,
    this.storeId = const Value.absent(),
    this.storeName = const Value.absent(),
    required int priceMinor,
    required int oldPriceMinor,
    required int marketPriceMinor,
    required double claimedDiscount,
    required double realDiscount,
    required double inflation,
    required bool inflated,
    required DateTime observedAt,
    this.scopeStoreId = const Value.absent(),
    required DateTime cachedAt,
  }) : productId = Value(productId),
       name = Value(name),
       chainCode = Value(chainCode),
       priceMinor = Value(priceMinor),
       oldPriceMinor = Value(oldPriceMinor),
       marketPriceMinor = Value(marketPriceMinor),
       claimedDiscount = Value(claimedDiscount),
       realDiscount = Value(realDiscount),
       inflation = Value(inflation),
       inflated = Value(inflated),
       observedAt = Value(observedAt),
       cachedAt = Value(cachedAt);
  static Insertable<CachedDeal> custom({
    Expression<int>? dealId,
    Expression<int>? productId,
    Expression<String>? name,
    Expression<String>? chainCode,
    Expression<int>? storeId,
    Expression<String>? storeName,
    Expression<int>? priceMinor,
    Expression<int>? oldPriceMinor,
    Expression<int>? marketPriceMinor,
    Expression<double>? claimedDiscount,
    Expression<double>? realDiscount,
    Expression<double>? inflation,
    Expression<bool>? inflated,
    Expression<DateTime>? observedAt,
    Expression<int>? scopeStoreId,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (dealId != null) 'deal_id': dealId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (chainCode != null) 'chain_code': chainCode,
      if (storeId != null) 'store_id': storeId,
      if (storeName != null) 'store_name': storeName,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (oldPriceMinor != null) 'old_price_minor': oldPriceMinor,
      if (marketPriceMinor != null) 'market_price_minor': marketPriceMinor,
      if (claimedDiscount != null) 'claimed_discount': claimedDiscount,
      if (realDiscount != null) 'real_discount': realDiscount,
      if (inflation != null) 'inflation': inflation,
      if (inflated != null) 'inflated': inflated,
      if (observedAt != null) 'observed_at': observedAt,
      if (scopeStoreId != null) 'scope_store_id': scopeStoreId,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CachedDealsCompanion copyWith({
    Value<int>? dealId,
    Value<int>? productId,
    Value<String>? name,
    Value<String>? chainCode,
    Value<int?>? storeId,
    Value<String?>? storeName,
    Value<int>? priceMinor,
    Value<int>? oldPriceMinor,
    Value<int>? marketPriceMinor,
    Value<double>? claimedDiscount,
    Value<double>? realDiscount,
    Value<double>? inflation,
    Value<bool>? inflated,
    Value<DateTime>? observedAt,
    Value<int?>? scopeStoreId,
    Value<DateTime>? cachedAt,
  }) {
    return CachedDealsCompanion(
      dealId: dealId ?? this.dealId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      chainCode: chainCode ?? this.chainCode,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      priceMinor: priceMinor ?? this.priceMinor,
      oldPriceMinor: oldPriceMinor ?? this.oldPriceMinor,
      marketPriceMinor: marketPriceMinor ?? this.marketPriceMinor,
      claimedDiscount: claimedDiscount ?? this.claimedDiscount,
      realDiscount: realDiscount ?? this.realDiscount,
      inflation: inflation ?? this.inflation,
      inflated: inflated ?? this.inflated,
      observedAt: observedAt ?? this.observedAt,
      scopeStoreId: scopeStoreId ?? this.scopeStoreId,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dealId.present) {
      map['deal_id'] = Variable<int>(dealId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (chainCode.present) {
      map['chain_code'] = Variable<String>(chainCode.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<int>(storeId.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (oldPriceMinor.present) {
      map['old_price_minor'] = Variable<int>(oldPriceMinor.value);
    }
    if (marketPriceMinor.present) {
      map['market_price_minor'] = Variable<int>(marketPriceMinor.value);
    }
    if (claimedDiscount.present) {
      map['claimed_discount'] = Variable<double>(claimedDiscount.value);
    }
    if (realDiscount.present) {
      map['real_discount'] = Variable<double>(realDiscount.value);
    }
    if (inflation.present) {
      map['inflation'] = Variable<double>(inflation.value);
    }
    if (inflated.present) {
      map['inflated'] = Variable<bool>(inflated.value);
    }
    if (observedAt.present) {
      map['observed_at'] = Variable<DateTime>(observedAt.value);
    }
    if (scopeStoreId.present) {
      map['scope_store_id'] = Variable<int>(scopeStoreId.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDealsCompanion(')
          ..write('dealId: $dealId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('chainCode: $chainCode, ')
          ..write('storeId: $storeId, ')
          ..write('storeName: $storeName, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('oldPriceMinor: $oldPriceMinor, ')
          ..write('marketPriceMinor: $marketPriceMinor, ')
          ..write('claimedDiscount: $claimedDiscount, ')
          ..write('realDiscount: $realDiscount, ')
          ..write('inflation: $inflation, ')
          ..write('inflated: $inflated, ')
          ..write('observedAt: $observedAt, ')
          ..write('scopeStoreId: $scopeStoreId, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitValueMeta = const VerificationMeta(
    'unitValue',
  );
  @override
  late final GeneratedColumn<double> unitValue = GeneratedColumn<double>(
    'unit_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitTypeMeta = const VerificationMeta(
    'unitType',
  );
  @override
  late final GeneratedColumn<String> unitType = GeneratedColumn<String>(
    'unit_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricesJsonMeta = const VerificationMeta(
    'pricesJson',
  );
  @override
  late final GeneratedColumn<String> pricesJson = GeneratedColumn<String>(
    'prices_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pricesUpdatedAtMeta = const VerificationMeta(
    'pricesUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pricesUpdatedAt =
      GeneratedColumn<DateTime>(
        'prices_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    name,
    unitValue,
    unitType,
    done,
    addedAt,
    pricesJson,
    pricesUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit_value')) {
      context.handle(
        _unitValueMeta,
        unitValue.isAcceptableOrUnknown(data['unit_value']!, _unitValueMeta),
      );
    }
    if (data.containsKey('unit_type')) {
      context.handle(
        _unitTypeMeta,
        unitType.isAcceptableOrUnknown(data['unit_type']!, _unitTypeMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('prices_json')) {
      context.handle(
        _pricesJsonMeta,
        pricesJson.isAcceptableOrUnknown(data['prices_json']!, _pricesJsonMeta),
      );
    }
    if (data.containsKey('prices_updated_at')) {
      context.handle(
        _pricesUpdatedAtMeta,
        pricesUpdatedAt.isAcceptableOrUnknown(
          data['prices_updated_at']!,
          _pricesUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unitValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_value'],
      ),
      unitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_type'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      pricesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prices_json'],
      ),
      pricesUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}prices_updated_at'],
      ),
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final int id;
  final int? productId;
  final String name;
  final double? unitValue;
  final String? unitType;
  final bool done;
  final DateTime addedAt;

  /// Цены по сетям, как их отдал сервер. Хранятся здесь, а не считаются на
  /// лету: список открывают в магазине, где связи может не быть вовсе.
  final String? pricesJson;
  final DateTime? pricesUpdatedAt;
  const ShoppingItem({
    required this.id,
    this.productId,
    required this.name,
    this.unitValue,
    this.unitType,
    required this.done,
    required this.addedAt,
    this.pricesJson,
    this.pricesUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || unitValue != null) {
      map['unit_value'] = Variable<double>(unitValue);
    }
    if (!nullToAbsent || unitType != null) {
      map['unit_type'] = Variable<String>(unitType);
    }
    map['done'] = Variable<bool>(done);
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || pricesJson != null) {
      map['prices_json'] = Variable<String>(pricesJson);
    }
    if (!nullToAbsent || pricesUpdatedAt != null) {
      map['prices_updated_at'] = Variable<DateTime>(pricesUpdatedAt);
    }
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      name: Value(name),
      unitValue: unitValue == null && nullToAbsent
          ? const Value.absent()
          : Value(unitValue),
      unitType: unitType == null && nullToAbsent
          ? const Value.absent()
          : Value(unitType),
      done: Value(done),
      addedAt: Value(addedAt),
      pricesJson: pricesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pricesJson),
      pricesUpdatedAt: pricesUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pricesUpdatedAt),
    );
  }

  factory ShoppingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int?>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      unitValue: serializer.fromJson<double?>(json['unitValue']),
      unitType: serializer.fromJson<String?>(json['unitType']),
      done: serializer.fromJson<bool>(json['done']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      pricesJson: serializer.fromJson<String?>(json['pricesJson']),
      pricesUpdatedAt: serializer.fromJson<DateTime?>(json['pricesUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int?>(productId),
      'name': serializer.toJson<String>(name),
      'unitValue': serializer.toJson<double?>(unitValue),
      'unitType': serializer.toJson<String?>(unitType),
      'done': serializer.toJson<bool>(done),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'pricesJson': serializer.toJson<String?>(pricesJson),
      'pricesUpdatedAt': serializer.toJson<DateTime?>(pricesUpdatedAt),
    };
  }

  ShoppingItem copyWith({
    int? id,
    Value<int?> productId = const Value.absent(),
    String? name,
    Value<double?> unitValue = const Value.absent(),
    Value<String?> unitType = const Value.absent(),
    bool? done,
    DateTime? addedAt,
    Value<String?> pricesJson = const Value.absent(),
    Value<DateTime?> pricesUpdatedAt = const Value.absent(),
  }) => ShoppingItem(
    id: id ?? this.id,
    productId: productId.present ? productId.value : this.productId,
    name: name ?? this.name,
    unitValue: unitValue.present ? unitValue.value : this.unitValue,
    unitType: unitType.present ? unitType.value : this.unitType,
    done: done ?? this.done,
    addedAt: addedAt ?? this.addedAt,
    pricesJson: pricesJson.present ? pricesJson.value : this.pricesJson,
    pricesUpdatedAt: pricesUpdatedAt.present
        ? pricesUpdatedAt.value
        : this.pricesUpdatedAt,
  );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      unitValue: data.unitValue.present ? data.unitValue.value : this.unitValue,
      unitType: data.unitType.present ? data.unitType.value : this.unitType,
      done: data.done.present ? data.done.value : this.done,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      pricesJson: data.pricesJson.present
          ? data.pricesJson.value
          : this.pricesJson,
      pricesUpdatedAt: data.pricesUpdatedAt.present
          ? data.pricesUpdatedAt.value
          : this.pricesUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('unitValue: $unitValue, ')
          ..write('unitType: $unitType, ')
          ..write('done: $done, ')
          ..write('addedAt: $addedAt, ')
          ..write('pricesJson: $pricesJson, ')
          ..write('pricesUpdatedAt: $pricesUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    name,
    unitValue,
    unitType,
    done,
    addedAt,
    pricesJson,
    pricesUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.unitValue == this.unitValue &&
          other.unitType == this.unitType &&
          other.done == this.done &&
          other.addedAt == this.addedAt &&
          other.pricesJson == this.pricesJson &&
          other.pricesUpdatedAt == this.pricesUpdatedAt);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<int> id;
  final Value<int?> productId;
  final Value<String> name;
  final Value<double?> unitValue;
  final Value<String?> unitType;
  final Value<bool> done;
  final Value<DateTime> addedAt;
  final Value<String?> pricesJson;
  final Value<DateTime?> pricesUpdatedAt;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.unitValue = const Value.absent(),
    this.unitType = const Value.absent(),
    this.done = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.pricesJson = const Value.absent(),
    this.pricesUpdatedAt = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    required String name,
    this.unitValue = const Value.absent(),
    this.unitType = const Value.absent(),
    this.done = const Value.absent(),
    required DateTime addedAt,
    this.pricesJson = const Value.absent(),
    this.pricesUpdatedAt = const Value.absent(),
  }) : name = Value(name),
       addedAt = Value(addedAt);
  static Insertable<ShoppingItem> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? name,
    Expression<double>? unitValue,
    Expression<String>? unitType,
    Expression<bool>? done,
    Expression<DateTime>? addedAt,
    Expression<String>? pricesJson,
    Expression<DateTime>? pricesUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (unitValue != null) 'unit_value': unitValue,
      if (unitType != null) 'unit_type': unitType,
      if (done != null) 'done': done,
      if (addedAt != null) 'added_at': addedAt,
      if (pricesJson != null) 'prices_json': pricesJson,
      if (pricesUpdatedAt != null) 'prices_updated_at': pricesUpdatedAt,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<int>? id,
    Value<int?>? productId,
    Value<String>? name,
    Value<double?>? unitValue,
    Value<String?>? unitType,
    Value<bool>? done,
    Value<DateTime>? addedAt,
    Value<String?>? pricesJson,
    Value<DateTime?>? pricesUpdatedAt,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      unitValue: unitValue ?? this.unitValue,
      unitType: unitType ?? this.unitType,
      done: done ?? this.done,
      addedAt: addedAt ?? this.addedAt,
      pricesJson: pricesJson ?? this.pricesJson,
      pricesUpdatedAt: pricesUpdatedAt ?? this.pricesUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unitValue.present) {
      map['unit_value'] = Variable<double>(unitValue.value);
    }
    if (unitType.present) {
      map['unit_type'] = Variable<String>(unitType.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (pricesJson.present) {
      map['prices_json'] = Variable<String>(pricesJson.value);
    }
    if (pricesUpdatedAt.present) {
      map['prices_updated_at'] = Variable<DateTime>(pricesUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('unitValue: $unitValue, ')
          ..write('unitType: $unitType, ')
          ..write('done: $done, ')
          ..write('addedAt: $addedAt, ')
          ..write('pricesJson: $pricesJson, ')
          ..write('pricesUpdatedAt: $pricesUpdatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$CatalogCache extends GeneratedDatabase {
  _$CatalogCache(QueryExecutor e) : super(e);
  $CatalogCacheManager get managers => $CatalogCacheManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $CachedSearchesTable cachedSearches = $CachedSearchesTable(this);
  late final $CachedDealsTable cachedDeals = $CachedDealsTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedProducts,
    cachedSearches,
    cachedDeals,
    shoppingItems,
  ];
}

typedef $$CachedProductsTableCreateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<int> productId,
      required String name,
      Value<String?> brand,
      Value<String?> ean,
      Value<double?> unitValue,
      Value<String?> unitType,
      Value<int?> bestPriceMinor,
      Value<String?> bestPriceChain,
      Value<int> chainsCount,
      Value<bool> hasPromo,
      Value<bool> needsStoreSelection,
      Value<DateTime?> observedAt,
      required DateTime cachedAt,
    });
typedef $$CachedProductsTableUpdateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<int> productId,
      Value<String> name,
      Value<String?> brand,
      Value<String?> ean,
      Value<double?> unitValue,
      Value<String?> unitType,
      Value<int?> bestPriceMinor,
      Value<String?> bestPriceChain,
      Value<int> chainsCount,
      Value<bool> hasPromo,
      Value<bool> needsStoreSelection,
      Value<DateTime?> observedAt,
      Value<DateTime> cachedAt,
    });

class $$CachedProductsTableFilterComposer
    extends Composer<_$CatalogCache, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ean => $composableBuilder(
    column: $table.ean,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitValue => $composableBuilder(
    column: $table.unitValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestPriceMinor => $composableBuilder(
    column: $table.bestPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bestPriceChain => $composableBuilder(
    column: $table.bestPriceChain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chainsCount => $composableBuilder(
    column: $table.chainsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPromo => $composableBuilder(
    column: $table.hasPromo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsStoreSelection => $composableBuilder(
    column: $table.needsStoreSelection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$CatalogCache, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ean => $composableBuilder(
    column: $table.ean,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitValue => $composableBuilder(
    column: $table.unitValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestPriceMinor => $composableBuilder(
    column: $table.bestPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bestPriceChain => $composableBuilder(
    column: $table.bestPriceChain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chainsCount => $composableBuilder(
    column: $table.chainsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPromo => $composableBuilder(
    column: $table.hasPromo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsStoreSelection => $composableBuilder(
    column: $table.needsStoreSelection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$CatalogCache, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get ean =>
      $composableBuilder(column: $table.ean, builder: (column) => column);

  GeneratedColumn<double> get unitValue =>
      $composableBuilder(column: $table.unitValue, builder: (column) => column);

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<int> get bestPriceMinor => $composableBuilder(
    column: $table.bestPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bestPriceChain => $composableBuilder(
    column: $table.bestPriceChain,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chainsCount => $composableBuilder(
    column: $table.chainsCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasPromo =>
      $composableBuilder(column: $table.hasPromo, builder: (column) => column);

  GeneratedColumn<bool> get needsStoreSelection => $composableBuilder(
    column: $table.needsStoreSelection,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedProductsTableTableManager
    extends
        RootTableManager<
          _$CatalogCache,
          $CachedProductsTable,
          CachedProduct,
          $$CachedProductsTableFilterComposer,
          $$CachedProductsTableOrderingComposer,
          $$CachedProductsTableAnnotationComposer,
          $$CachedProductsTableCreateCompanionBuilder,
          $$CachedProductsTableUpdateCompanionBuilder,
          (
            CachedProduct,
            BaseReferences<_$CatalogCache, $CachedProductsTable, CachedProduct>,
          ),
          CachedProduct,
          PrefetchHooks Function()
        > {
  $$CachedProductsTableTableManager(
    _$CatalogCache db,
    $CachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> ean = const Value.absent(),
                Value<double?> unitValue = const Value.absent(),
                Value<String?> unitType = const Value.absent(),
                Value<int?> bestPriceMinor = const Value.absent(),
                Value<String?> bestPriceChain = const Value.absent(),
                Value<int> chainsCount = const Value.absent(),
                Value<bool> hasPromo = const Value.absent(),
                Value<bool> needsStoreSelection = const Value.absent(),
                Value<DateTime?> observedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CachedProductsCompanion(
                productId: productId,
                name: name,
                brand: brand,
                ean: ean,
                unitValue: unitValue,
                unitType: unitType,
                bestPriceMinor: bestPriceMinor,
                bestPriceChain: bestPriceChain,
                chainsCount: chainsCount,
                hasPromo: hasPromo,
                needsStoreSelection: needsStoreSelection,
                observedAt: observedAt,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> productId = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> ean = const Value.absent(),
                Value<double?> unitValue = const Value.absent(),
                Value<String?> unitType = const Value.absent(),
                Value<int?> bestPriceMinor = const Value.absent(),
                Value<String?> bestPriceChain = const Value.absent(),
                Value<int> chainsCount = const Value.absent(),
                Value<bool> hasPromo = const Value.absent(),
                Value<bool> needsStoreSelection = const Value.absent(),
                Value<DateTime?> observedAt = const Value.absent(),
                required DateTime cachedAt,
              }) => CachedProductsCompanion.insert(
                productId: productId,
                name: name,
                brand: brand,
                ean: ean,
                unitValue: unitValue,
                unitType: unitType,
                bestPriceMinor: bestPriceMinor,
                bestPriceChain: bestPriceChain,
                chainsCount: chainsCount,
                hasPromo: hasPromo,
                needsStoreSelection: needsStoreSelection,
                observedAt: observedAt,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogCache,
      $CachedProductsTable,
      CachedProduct,
      $$CachedProductsTableFilterComposer,
      $$CachedProductsTableOrderingComposer,
      $$CachedProductsTableAnnotationComposer,
      $$CachedProductsTableCreateCompanionBuilder,
      $$CachedProductsTableUpdateCompanionBuilder,
      (
        CachedProduct,
        BaseReferences<_$CatalogCache, $CachedProductsTable, CachedProduct>,
      ),
      CachedProduct,
      PrefetchHooks Function()
    >;
typedef $$CachedSearchesTableCreateCompanionBuilder =
    CachedSearchesCompanion Function({
      required String queryKey,
      required String productIds,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedSearchesTableUpdateCompanionBuilder =
    CachedSearchesCompanion Function({
      Value<String> queryKey,
      Value<String> productIds,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedSearchesTableFilterComposer
    extends Composer<_$CatalogCache, $CachedSearchesTable> {
  $$CachedSearchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get queryKey => $composableBuilder(
    column: $table.queryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productIds => $composableBuilder(
    column: $table.productIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedSearchesTableOrderingComposer
    extends Composer<_$CatalogCache, $CachedSearchesTable> {
  $$CachedSearchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get queryKey => $composableBuilder(
    column: $table.queryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productIds => $composableBuilder(
    column: $table.productIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedSearchesTableAnnotationComposer
    extends Composer<_$CatalogCache, $CachedSearchesTable> {
  $$CachedSearchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get queryKey =>
      $composableBuilder(column: $table.queryKey, builder: (column) => column);

  GeneratedColumn<String> get productIds => $composableBuilder(
    column: $table.productIds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedSearchesTableTableManager
    extends
        RootTableManager<
          _$CatalogCache,
          $CachedSearchesTable,
          CachedSearche,
          $$CachedSearchesTableFilterComposer,
          $$CachedSearchesTableOrderingComposer,
          $$CachedSearchesTableAnnotationComposer,
          $$CachedSearchesTableCreateCompanionBuilder,
          $$CachedSearchesTableUpdateCompanionBuilder,
          (
            CachedSearche,
            BaseReferences<_$CatalogCache, $CachedSearchesTable, CachedSearche>,
          ),
          CachedSearche,
          PrefetchHooks Function()
        > {
  $$CachedSearchesTableTableManager(
    _$CatalogCache db,
    $CachedSearchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSearchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSearchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSearchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> queryKey = const Value.absent(),
                Value<String> productIds = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedSearchesCompanion(
                queryKey: queryKey,
                productIds: productIds,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String queryKey,
                required String productIds,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedSearchesCompanion.insert(
                queryKey: queryKey,
                productIds: productIds,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedSearchesTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogCache,
      $CachedSearchesTable,
      CachedSearche,
      $$CachedSearchesTableFilterComposer,
      $$CachedSearchesTableOrderingComposer,
      $$CachedSearchesTableAnnotationComposer,
      $$CachedSearchesTableCreateCompanionBuilder,
      $$CachedSearchesTableUpdateCompanionBuilder,
      (
        CachedSearche,
        BaseReferences<_$CatalogCache, $CachedSearchesTable, CachedSearche>,
      ),
      CachedSearche,
      PrefetchHooks Function()
    >;
typedef $$CachedDealsTableCreateCompanionBuilder =
    CachedDealsCompanion Function({
      Value<int> dealId,
      required int productId,
      required String name,
      required String chainCode,
      Value<int?> storeId,
      Value<String?> storeName,
      required int priceMinor,
      required int oldPriceMinor,
      required int marketPriceMinor,
      required double claimedDiscount,
      required double realDiscount,
      required double inflation,
      required bool inflated,
      required DateTime observedAt,
      Value<int?> scopeStoreId,
      required DateTime cachedAt,
    });
typedef $$CachedDealsTableUpdateCompanionBuilder =
    CachedDealsCompanion Function({
      Value<int> dealId,
      Value<int> productId,
      Value<String> name,
      Value<String> chainCode,
      Value<int?> storeId,
      Value<String?> storeName,
      Value<int> priceMinor,
      Value<int> oldPriceMinor,
      Value<int> marketPriceMinor,
      Value<double> claimedDiscount,
      Value<double> realDiscount,
      Value<double> inflation,
      Value<bool> inflated,
      Value<DateTime> observedAt,
      Value<int?> scopeStoreId,
      Value<DateTime> cachedAt,
    });

class $$CachedDealsTableFilterComposer
    extends Composer<_$CatalogCache, $CachedDealsTable> {
  $$CachedDealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chainCode => $composableBuilder(
    column: $table.chainCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get oldPriceMinor => $composableBuilder(
    column: $table.oldPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get marketPriceMinor => $composableBuilder(
    column: $table.marketPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get claimedDiscount => $composableBuilder(
    column: $table.claimedDiscount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get realDiscount => $composableBuilder(
    column: $table.realDiscount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get inflation => $composableBuilder(
    column: $table.inflation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inflated => $composableBuilder(
    column: $table.inflated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scopeStoreId => $composableBuilder(
    column: $table.scopeStoreId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDealsTableOrderingComposer
    extends Composer<_$CatalogCache, $CachedDealsTable> {
  $$CachedDealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dealId => $composableBuilder(
    column: $table.dealId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chainCode => $composableBuilder(
    column: $table.chainCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeName => $composableBuilder(
    column: $table.storeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get oldPriceMinor => $composableBuilder(
    column: $table.oldPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get marketPriceMinor => $composableBuilder(
    column: $table.marketPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get claimedDiscount => $composableBuilder(
    column: $table.claimedDiscount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get realDiscount => $composableBuilder(
    column: $table.realDiscount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get inflation => $composableBuilder(
    column: $table.inflation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inflated => $composableBuilder(
    column: $table.inflated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scopeStoreId => $composableBuilder(
    column: $table.scopeStoreId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDealsTableAnnotationComposer
    extends Composer<_$CatalogCache, $CachedDealsTable> {
  $$CachedDealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dealId =>
      $composableBuilder(column: $table.dealId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get chainCode =>
      $composableBuilder(column: $table.chainCode, builder: (column) => column);

  GeneratedColumn<int> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get oldPriceMinor => $composableBuilder(
    column: $table.oldPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get marketPriceMinor => $composableBuilder(
    column: $table.marketPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<double> get claimedDiscount => $composableBuilder(
    column: $table.claimedDiscount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get realDiscount => $composableBuilder(
    column: $table.realDiscount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get inflation =>
      $composableBuilder(column: $table.inflation, builder: (column) => column);

  GeneratedColumn<bool> get inflated =>
      $composableBuilder(column: $table.inflated, builder: (column) => column);

  GeneratedColumn<DateTime> get observedAt => $composableBuilder(
    column: $table.observedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scopeStoreId => $composableBuilder(
    column: $table.scopeStoreId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedDealsTableTableManager
    extends
        RootTableManager<
          _$CatalogCache,
          $CachedDealsTable,
          CachedDeal,
          $$CachedDealsTableFilterComposer,
          $$CachedDealsTableOrderingComposer,
          $$CachedDealsTableAnnotationComposer,
          $$CachedDealsTableCreateCompanionBuilder,
          $$CachedDealsTableUpdateCompanionBuilder,
          (
            CachedDeal,
            BaseReferences<_$CatalogCache, $CachedDealsTable, CachedDeal>,
          ),
          CachedDeal,
          PrefetchHooks Function()
        > {
  $$CachedDealsTableTableManager(_$CatalogCache db, $CachedDealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> dealId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> chainCode = const Value.absent(),
                Value<int?> storeId = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<int> oldPriceMinor = const Value.absent(),
                Value<int> marketPriceMinor = const Value.absent(),
                Value<double> claimedDiscount = const Value.absent(),
                Value<double> realDiscount = const Value.absent(),
                Value<double> inflation = const Value.absent(),
                Value<bool> inflated = const Value.absent(),
                Value<DateTime> observedAt = const Value.absent(),
                Value<int?> scopeStoreId = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CachedDealsCompanion(
                dealId: dealId,
                productId: productId,
                name: name,
                chainCode: chainCode,
                storeId: storeId,
                storeName: storeName,
                priceMinor: priceMinor,
                oldPriceMinor: oldPriceMinor,
                marketPriceMinor: marketPriceMinor,
                claimedDiscount: claimedDiscount,
                realDiscount: realDiscount,
                inflation: inflation,
                inflated: inflated,
                observedAt: observedAt,
                scopeStoreId: scopeStoreId,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> dealId = const Value.absent(),
                required int productId,
                required String name,
                required String chainCode,
                Value<int?> storeId = const Value.absent(),
                Value<String?> storeName = const Value.absent(),
                required int priceMinor,
                required int oldPriceMinor,
                required int marketPriceMinor,
                required double claimedDiscount,
                required double realDiscount,
                required double inflation,
                required bool inflated,
                required DateTime observedAt,
                Value<int?> scopeStoreId = const Value.absent(),
                required DateTime cachedAt,
              }) => CachedDealsCompanion.insert(
                dealId: dealId,
                productId: productId,
                name: name,
                chainCode: chainCode,
                storeId: storeId,
                storeName: storeName,
                priceMinor: priceMinor,
                oldPriceMinor: oldPriceMinor,
                marketPriceMinor: marketPriceMinor,
                claimedDiscount: claimedDiscount,
                realDiscount: realDiscount,
                inflation: inflation,
                inflated: inflated,
                observedAt: observedAt,
                scopeStoreId: scopeStoreId,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDealsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogCache,
      $CachedDealsTable,
      CachedDeal,
      $$CachedDealsTableFilterComposer,
      $$CachedDealsTableOrderingComposer,
      $$CachedDealsTableAnnotationComposer,
      $$CachedDealsTableCreateCompanionBuilder,
      $$CachedDealsTableUpdateCompanionBuilder,
      (
        CachedDeal,
        BaseReferences<_$CatalogCache, $CachedDealsTable, CachedDeal>,
      ),
      CachedDeal,
      PrefetchHooks Function()
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      Value<int?> productId,
      required String name,
      Value<double?> unitValue,
      Value<String?> unitType,
      Value<bool> done,
      required DateTime addedAt,
      Value<String?> pricesJson,
      Value<DateTime?> pricesUpdatedAt,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      Value<int?> productId,
      Value<String> name,
      Value<double?> unitValue,
      Value<String?> unitType,
      Value<bool> done,
      Value<DateTime> addedAt,
      Value<String?> pricesJson,
      Value<DateTime?> pricesUpdatedAt,
    });

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$CatalogCache, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitValue => $composableBuilder(
    column: $table.unitValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pricesJson => $composableBuilder(
    column: $table.pricesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pricesUpdatedAt => $composableBuilder(
    column: $table.pricesUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$CatalogCache, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitValue => $composableBuilder(
    column: $table.unitValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitType => $composableBuilder(
    column: $table.unitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pricesJson => $composableBuilder(
    column: $table.pricesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pricesUpdatedAt => $composableBuilder(
    column: $table.pricesUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$CatalogCache, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get unitValue =>
      $composableBuilder(column: $table.unitValue, builder: (column) => column);

  GeneratedColumn<String> get unitType =>
      $composableBuilder(column: $table.unitType, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<String> get pricesJson => $composableBuilder(
    column: $table.pricesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pricesUpdatedAt => $composableBuilder(
    column: $table.pricesUpdatedAt,
    builder: (column) => column,
  );
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$CatalogCache,
          $ShoppingItemsTable,
          ShoppingItem,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (
            ShoppingItem,
            BaseReferences<_$CatalogCache, $ShoppingItemsTable, ShoppingItem>,
          ),
          ShoppingItem,
          PrefetchHooks Function()
        > {
  $$ShoppingItemsTableTableManager(_$CatalogCache db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> unitValue = const Value.absent(),
                Value<String?> unitType = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<String?> pricesJson = const Value.absent(),
                Value<DateTime?> pricesUpdatedAt = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                productId: productId,
                name: name,
                unitValue: unitValue,
                unitType: unitType,
                done: done,
                addedAt: addedAt,
                pricesJson: pricesJson,
                pricesUpdatedAt: pricesUpdatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                required String name,
                Value<double?> unitValue = const Value.absent(),
                Value<String?> unitType = const Value.absent(),
                Value<bool> done = const Value.absent(),
                required DateTime addedAt,
                Value<String?> pricesJson = const Value.absent(),
                Value<DateTime?> pricesUpdatedAt = const Value.absent(),
              }) => ShoppingItemsCompanion.insert(
                id: id,
                productId: productId,
                name: name,
                unitValue: unitValue,
                unitType: unitType,
                done: done,
                addedAt: addedAt,
                pricesJson: pricesJson,
                pricesUpdatedAt: pricesUpdatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$CatalogCache,
      $ShoppingItemsTable,
      ShoppingItem,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (
        ShoppingItem,
        BaseReferences<_$CatalogCache, $ShoppingItemsTable, ShoppingItem>,
      ),
      ShoppingItem,
      PrefetchHooks Function()
    >;

class $CatalogCacheManager {
  final _$CatalogCache _db;
  $CatalogCacheManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$CachedSearchesTableTableManager get cachedSearches =>
      $$CachedSearchesTableTableManager(_db, _db.cachedSearches);
  $$CachedDealsTableTableManager get cachedDeals =>
      $$CachedDealsTableTableManager(_db, _db.cachedDeals);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
}
