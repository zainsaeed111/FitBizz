import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Tables
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get branchId => text()();
  TextColumn get memberNumber => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get planId => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class AttendanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get branchId => text()();
  TextColumn get memberId => text()();
  DateTimeColumn get checkInAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get method => text().withDefault(const Constant('MANUAL'))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class OfflineQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tenantId => text()();
  TextColumn get operationType => text()(); // CREATE_MEMBER, CHECK_IN
  TextColumn get targetEntity => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
}

@DriftDatabase(tables: [Members, AttendanceRecords, OfflineQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'fitbizz_local_db');
  }
}
