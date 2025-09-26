// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientTableTable extends ClientTable
    with TableInfo<$ClientTableTable, ClientTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_table';
  @override
  VerificationContext validateIntegrity(Insertable<ClientTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
    );
  }

  @override
  $ClientTableTable createAlias(String alias) {
    return $ClientTableTable(attachedDatabase, alias);
  }
}

class ClientTableData extends DataClass implements Insertable<ClientTableData> {
  final int id;
  final String name;
  final String category;
  const ClientTableData(
      {required this.id, required this.name, required this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    return map;
  }

  ClientTableCompanion toCompanion(bool nullToAbsent) {
    return ClientTableCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
    );
  }

  factory ClientTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
    };
  }

  ClientTableData copyWith({int? id, String? name, String? category}) =>
      ClientTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
      );
  ClientTableData copyWithCompanion(ClientTableCompanion data) {
    return ClientTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category);
}

class ClientTableCompanion extends UpdateCompanion<ClientTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  const ClientTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
  });
  ClientTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
  })  : name = Value(name),
        category = Value(category);
  static Insertable<ClientTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
    });
  }

  ClientTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? category}) {
    return ClientTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $TransactionTableTable extends TransactionTable
    with TableInfo<$TransactionTableTable, TransactionTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
      'client_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES client_table (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _datetimeMeta =
      const VerificationMeta('datetime');
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, clientId, amount, status, datetime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime'])!,
    );
  }

  @override
  $TransactionTableTable createAlias(String alias) {
    return $TransactionTableTable(attachedDatabase, alias);
  }
}

class TransactionTableData extends DataClass
    implements Insertable<TransactionTableData> {
  final int id;
  final int clientId;
  final double amount;
  final String status;
  final DateTime datetime;
  const TransactionTableData(
      {required this.id,
      required this.clientId,
      required this.amount,
      required this.status,
      required this.datetime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['amount'] = Variable<double>(amount);
    map['status'] = Variable<String>(status);
    map['datetime'] = Variable<DateTime>(datetime);
    return map;
  }

  TransactionTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionTableCompanion(
      id: Value(id),
      clientId: Value(clientId),
      amount: Value(amount),
      status: Value(status),
      datetime: Value(datetime),
    );
  }

  factory TransactionTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTableData(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      amount: serializer.fromJson<double>(json['amount']),
      status: serializer.fromJson<String>(json['status']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'amount': serializer.toJson<double>(amount),
      'status': serializer.toJson<String>(status),
      'datetime': serializer.toJson<DateTime>(datetime),
    };
  }

  TransactionTableData copyWith(
          {int? id,
          int? clientId,
          double? amount,
          String? status,
          DateTime? datetime}) =>
      TransactionTableData(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        amount: amount ?? this.amount,
        status: status ?? this.status,
        datetime: datetime ?? this.datetime,
      );
  TransactionTableData copyWithCompanion(TransactionTableCompanion data) {
    return TransactionTableData(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      datetime: data.datetime.present ? data.datetime.value : this.datetime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableData(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('datetime: $datetime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientId, amount, status, datetime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTableData &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.datetime == this.datetime);
}

class TransactionTableCompanion extends UpdateCompanion<TransactionTableData> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<double> amount;
  final Value<String> status;
  final Value<DateTime> datetime;
  const TransactionTableCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.datetime = const Value.absent(),
  });
  TransactionTableCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required double amount,
    required String status,
    required DateTime datetime,
  })  : clientId = Value(clientId),
        amount = Value(amount),
        status = Value(status),
        datetime = Value(datetime);
  static Insertable<TransactionTableData> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<double>? amount,
    Expression<String>? status,
    Expression<DateTime>? datetime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (datetime != null) 'datetime': datetime,
    });
  }

  TransactionTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? clientId,
      Value<double>? amount,
      Value<String>? status,
      Value<DateTime>? datetime}) {
    return TransactionTableCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      datetime: datetime ?? this.datetime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTableCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('datetime: $datetime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientTableTable clientTable = $ClientTableTable(this);
  late final $TransactionTableTable transactionTable =
      $TransactionTableTable(this);
  late final ClientDao clientDao = ClientDao(this as AppDatabase);
  late final TransactionDao transactionDao =
      TransactionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [clientTable, transactionTable];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('client_table',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transaction_table', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ClientTableTableCreateCompanionBuilder = ClientTableCompanion
    Function({
  Value<int> id,
  required String name,
  required String category,
});
typedef $$ClientTableTableUpdateCompanionBuilder = ClientTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
});

final class $$ClientTableTableReferences
    extends BaseReferences<_$AppDatabase, $ClientTableTable, ClientTableData> {
  $$ClientTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionTableTable, List<TransactionTableData>>
      _transactionTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionTable,
              aliasName: $_aliasNameGenerator(
                  db.clientTable.id, db.transactionTable.clientId));

  $$TransactionTableTableProcessedTableManager get transactionTableRefs {
    final manager =
        $$TransactionTableTableTableManager($_db, $_db.transactionTable)
            .filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientTableTableFilterComposer
    extends Composer<_$AppDatabase, $ClientTableTable> {
  $$ClientTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionTableRefs(
      Expression<bool> Function($$TransactionTableTableFilterComposer f) f) {
    final $$TransactionTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableFilterComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientTableTable> {
  $$ClientTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$ClientTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientTableTable> {
  $$ClientTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  Expression<T> transactionTableRefs<T extends Object>(
      Expression<T> Function($$TransactionTableTableAnnotationComposer a) f) {
    final $$TransactionTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionTable,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionTableTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientTableTable,
    ClientTableData,
    $$ClientTableTableFilterComposer,
    $$ClientTableTableOrderingComposer,
    $$ClientTableTableAnnotationComposer,
    $$ClientTableTableCreateCompanionBuilder,
    $$ClientTableTableUpdateCompanionBuilder,
    (ClientTableData, $$ClientTableTableReferences),
    ClientTableData,
    PrefetchHooks Function({bool transactionTableRefs})> {
  $$ClientTableTableTableManager(_$AppDatabase db, $ClientTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
          }) =>
              ClientTableCompanion(
            id: id,
            name: name,
            category: category,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
          }) =>
              ClientTableCompanion.insert(
            id: id,
            name: name,
            category: category,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ClientTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionTableRefs) db.transactionTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionTableRefs)
                    await $_getPrefetchedData<ClientTableData,
                            $ClientTableTable, TransactionTableData>(
                        currentTable: table,
                        referencedTable: $$ClientTableTableReferences
                            ._transactionTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientTableTableReferences(db, table, p0)
                                .transactionTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.clientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientTableTable,
    ClientTableData,
    $$ClientTableTableFilterComposer,
    $$ClientTableTableOrderingComposer,
    $$ClientTableTableAnnotationComposer,
    $$ClientTableTableCreateCompanionBuilder,
    $$ClientTableTableUpdateCompanionBuilder,
    (ClientTableData, $$ClientTableTableReferences),
    ClientTableData,
    PrefetchHooks Function({bool transactionTableRefs})>;
typedef $$TransactionTableTableCreateCompanionBuilder
    = TransactionTableCompanion Function({
  Value<int> id,
  required int clientId,
  required double amount,
  required String status,
  required DateTime datetime,
});
typedef $$TransactionTableTableUpdateCompanionBuilder
    = TransactionTableCompanion Function({
  Value<int> id,
  Value<int> clientId,
  Value<double> amount,
  Value<String> status,
  Value<DateTime> datetime,
});

final class $$TransactionTableTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionTableTable, TransactionTableData> {
  $$TransactionTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ClientTableTable _clientIdTable(_$AppDatabase db) =>
      db.clientTable.createAlias($_aliasNameGenerator(
          db.transactionTable.clientId, db.clientTable.id));

  $$ClientTableTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientTableTableTableManager($_db, $_db.clientTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnFilters(column));

  $$ClientTableTableFilterComposer get clientId {
    final $$ClientTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clientTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientTableTableFilterComposer(
              $db: $db,
              $table: $db.clientTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnOrderings(column));

  $$ClientTableTableOrderingComposer get clientId {
    final $$ClientTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clientTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientTableTableOrderingComposer(
              $db: $db,
              $table: $db.clientTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTableTable> {
  $$TransactionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get datetime =>
      $composableBuilder(column: $table.datetime, builder: (column) => column);

  $$ClientTableTableAnnotationComposer get clientId {
    final $$ClientTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clientTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientTableTableAnnotationComposer(
              $db: $db,
              $table: $db.clientTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionTableTable,
    TransactionTableData,
    $$TransactionTableTableFilterComposer,
    $$TransactionTableTableOrderingComposer,
    $$TransactionTableTableAnnotationComposer,
    $$TransactionTableTableCreateCompanionBuilder,
    $$TransactionTableTableUpdateCompanionBuilder,
    (TransactionTableData, $$TransactionTableTableReferences),
    TransactionTableData,
    PrefetchHooks Function({bool clientId})> {
  $$TransactionTableTableTableManager(
      _$AppDatabase db, $TransactionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> clientId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> datetime = const Value.absent(),
          }) =>
              TransactionTableCompanion(
            id: id,
            clientId: clientId,
            amount: amount,
            status: status,
            datetime: datetime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int clientId,
            required double amount,
            required String status,
            required DateTime datetime,
          }) =>
              TransactionTableCompanion.insert(
            id: id,
            clientId: clientId,
            amount: amount,
            status: status,
            datetime: datetime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientId,
                    referencedTable:
                        $$TransactionTableTableReferences._clientIdTable(db),
                    referencedColumn:
                        $$TransactionTableTableReferences._clientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionTableTable,
    TransactionTableData,
    $$TransactionTableTableFilterComposer,
    $$TransactionTableTableOrderingComposer,
    $$TransactionTableTableAnnotationComposer,
    $$TransactionTableTableCreateCompanionBuilder,
    $$TransactionTableTableUpdateCompanionBuilder,
    (TransactionTableData, $$TransactionTableTableReferences),
    TransactionTableData,
    PrefetchHooks Function({bool clientId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientTableTableTableManager get clientTable =>
      $$ClientTableTableTableManager(_db, _db.clientTable);
  $$TransactionTableTableTableManager get transactionTable =>
      $$TransactionTableTableTableManager(_db, _db.transactionTable);
}
