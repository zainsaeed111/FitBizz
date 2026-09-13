// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberNumberMeta = const VerificationMeta(
    'memberNumber',
  );
  @override
  late final GeneratedColumn<String> memberNumber = GeneratedColumn<String>(
    'member_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    branchId,
    memberNumber,
    fullName,
    email,
    phone,
    planId,
    status,
    joinedAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('member_number')) {
      context.handle(
        _memberNumberMeta,
        memberNumber.isAcceptableOrUnknown(
          data['member_number']!,
          _memberNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_memberNumberMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      memberNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_number'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final String id;
  final String tenantId;
  final String branchId;
  final String memberNumber;
  final String fullName;
  final String? email;
  final String? phone;
  final String? planId;
  final String status;
  final DateTime joinedAt;
  final DateTime? expiresAt;
  const Member({
    required this.id,
    required this.tenantId,
    required this.branchId,
    required this.memberNumber,
    required this.fullName,
    this.email,
    this.phone,
    this.planId,
    required this.status,
    required this.joinedAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['branch_id'] = Variable<String>(branchId);
    map['member_number'] = Variable<String>(memberNumber);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<String>(planId);
    }
    map['status'] = Variable<String>(status);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      branchId: Value(branchId),
      memberNumber: Value(memberNumber),
      fullName: Value(fullName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      planId: planId == null && nullToAbsent
          ? const Value.absent()
          : Value(planId),
      status: Value(status),
      joinedAt: Value(joinedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      branchId: serializer.fromJson<String>(json['branchId']),
      memberNumber: serializer.fromJson<String>(json['memberNumber']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      planId: serializer.fromJson<String?>(json['planId']),
      status: serializer.fromJson<String>(json['status']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'branchId': serializer.toJson<String>(branchId),
      'memberNumber': serializer.toJson<String>(memberNumber),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'planId': serializer.toJson<String?>(planId),
      'status': serializer.toJson<String>(status),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  Member copyWith({
    String? id,
    String? tenantId,
    String? branchId,
    String? memberNumber,
    String? fullName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> planId = const Value.absent(),
    String? status,
    DateTime? joinedAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => Member(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    branchId: branchId ?? this.branchId,
    memberNumber: memberNumber ?? this.memberNumber,
    fullName: fullName ?? this.fullName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    planId: planId.present ? planId.value : this.planId,
    status: status ?? this.status,
    joinedAt: joinedAt ?? this.joinedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      memberNumber: data.memberNumber.present
          ? data.memberNumber.value
          : this.memberNumber,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      planId: data.planId.present ? data.planId.value : this.planId,
      status: data.status.present ? data.status.value : this.status,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('branchId: $branchId, ')
          ..write('memberNumber: $memberNumber, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('planId: $planId, ')
          ..write('status: $status, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    branchId,
    memberNumber,
    fullName,
    email,
    phone,
    planId,
    status,
    joinedAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.branchId == this.branchId &&
          other.memberNumber == this.memberNumber &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.planId == this.planId &&
          other.status == this.status &&
          other.joinedAt == this.joinedAt &&
          other.expiresAt == this.expiresAt);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> branchId;
  final Value<String> memberNumber;
  final Value<String> fullName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> planId;
  final Value<String> status;
  final Value<DateTime> joinedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.memberNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.planId = const Value.absent(),
    this.status = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String tenantId,
    required String branchId,
    required String memberNumber,
    required String fullName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.planId = const Value.absent(),
    this.status = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       branchId = Value(branchId),
       memberNumber = Value(memberNumber),
       fullName = Value(fullName);
  static Insertable<Member> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? branchId,
    Expression<String>? memberNumber,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? planId,
    Expression<String>? status,
    Expression<DateTime>? joinedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (branchId != null) 'branch_id': branchId,
      if (memberNumber != null) 'member_number': memberNumber,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (planId != null) 'plan_id': planId,
      if (status != null) 'status': status,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? branchId,
    Value<String>? memberNumber,
    Value<String>? fullName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? planId,
    Value<String>? status,
    Value<DateTime>? joinedAt,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      branchId: branchId ?? this.branchId,
      memberNumber: memberNumber ?? this.memberNumber,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      planId: planId ?? this.planId,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (memberNumber.present) {
      map['member_number'] = Variable<String>(memberNumber.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('branchId: $branchId, ')
          ..write('memberNumber: $memberNumber, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('planId: $planId, ')
          ..write('status: $status, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceRecordsTable extends AttendanceRecords
    with TableInfo<$AttendanceRecordsTable, AttendanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInAtMeta = const VerificationMeta(
    'checkInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkInAt = GeneratedColumn<DateTime>(
    'check_in_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MANUAL'),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    branchId,
    memberId,
    checkInAt,
    method,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('check_in_at')) {
      context.handle(
        _checkInAtMeta,
        checkInAt.isAcceptableOrUnknown(data['check_in_at']!, _checkInAtMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      checkInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in_at'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $AttendanceRecordsTable createAlias(String alias) {
    return $AttendanceRecordsTable(attachedDatabase, alias);
  }
}

class AttendanceRecord extends DataClass
    implements Insertable<AttendanceRecord> {
  final String id;
  final String tenantId;
  final String branchId;
  final String memberId;
  final DateTime checkInAt;
  final String method;
  final bool synced;
  const AttendanceRecord({
    required this.id,
    required this.tenantId,
    required this.branchId,
    required this.memberId,
    required this.checkInAt,
    required this.method,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['branch_id'] = Variable<String>(branchId);
    map['member_id'] = Variable<String>(memberId);
    map['check_in_at'] = Variable<DateTime>(checkInAt);
    map['method'] = Variable<String>(method);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  AttendanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceRecordsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      branchId: Value(branchId),
      memberId: Value(memberId),
      checkInAt: Value(checkInAt),
      method: Value(method),
      synced: Value(synced),
    );
  }

  factory AttendanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRecord(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      branchId: serializer.fromJson<String>(json['branchId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      checkInAt: serializer.fromJson<DateTime>(json['checkInAt']),
      method: serializer.fromJson<String>(json['method']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'branchId': serializer.toJson<String>(branchId),
      'memberId': serializer.toJson<String>(memberId),
      'checkInAt': serializer.toJson<DateTime>(checkInAt),
      'method': serializer.toJson<String>(method),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  AttendanceRecord copyWith({
    String? id,
    String? tenantId,
    String? branchId,
    String? memberId,
    DateTime? checkInAt,
    String? method,
    bool? synced,
  }) => AttendanceRecord(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    branchId: branchId ?? this.branchId,
    memberId: memberId ?? this.memberId,
    checkInAt: checkInAt ?? this.checkInAt,
    method: method ?? this.method,
    synced: synced ?? this.synced,
  );
  AttendanceRecord copyWithCompanion(AttendanceRecordsCompanion data) {
    return AttendanceRecord(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      checkInAt: data.checkInAt.present ? data.checkInAt.value : this.checkInAt,
      method: data.method.present ? data.method.value : this.method,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecord(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('branchId: $branchId, ')
          ..write('memberId: $memberId, ')
          ..write('checkInAt: $checkInAt, ')
          ..write('method: $method, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tenantId, branchId, memberId, checkInAt, method, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRecord &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.branchId == this.branchId &&
          other.memberId == this.memberId &&
          other.checkInAt == this.checkInAt &&
          other.method == this.method &&
          other.synced == this.synced);
}

class AttendanceRecordsCompanion extends UpdateCompanion<AttendanceRecord> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> branchId;
  final Value<String> memberId;
  final Value<DateTime> checkInAt;
  final Value<String> method;
  final Value<bool> synced;
  final Value<int> rowid;
  const AttendanceRecordsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.checkInAt = const Value.absent(),
    this.method = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceRecordsCompanion.insert({
    required String id,
    required String tenantId,
    required String branchId,
    required String memberId,
    this.checkInAt = const Value.absent(),
    this.method = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       branchId = Value(branchId),
       memberId = Value(memberId);
  static Insertable<AttendanceRecord> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? branchId,
    Expression<String>? memberId,
    Expression<DateTime>? checkInAt,
    Expression<String>? method,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (branchId != null) 'branch_id': branchId,
      if (memberId != null) 'member_id': memberId,
      if (checkInAt != null) 'check_in_at': checkInAt,
      if (method != null) 'method': method,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? branchId,
    Value<String>? memberId,
    Value<DateTime>? checkInAt,
    Value<String>? method,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return AttendanceRecordsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      branchId: branchId ?? this.branchId,
      memberId: memberId ?? this.memberId,
      checkInAt: checkInAt ?? this.checkInAt,
      method: method ?? this.method,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (checkInAt.present) {
      map['check_in_at'] = Variable<DateTime>(checkInAt.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('branchId: $branchId, ')
          ..write('memberId: $memberId, ')
          ..write('checkInAt: $checkInAt, ')
          ..write('method: $method, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineQueueTable extends OfflineQueue
    with TableInfo<$OfflineQueueTable, OfflineQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineQueueTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetEntityMeta = const VerificationMeta(
    'targetEntity',
  );
  @override
  late final GeneratedColumn<String> targetEntity = GeneratedColumn<String>(
    'target_entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    operationType,
    targetEntity,
    payloadJson,
    createdAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('target_entity')) {
      context.handle(
        _targetEntityMeta,
        targetEntity.isAcceptableOrUnknown(
          data['target_entity']!,
          _targetEntityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetEntityMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      targetEntity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_entity'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $OfflineQueueTable createAlias(String alias) {
    return $OfflineQueueTable(attachedDatabase, alias);
  }
}

class OfflineQueueData extends DataClass
    implements Insertable<OfflineQueueData> {
  final int id;
  final String tenantId;
  final String operationType;
  final String targetEntity;
  final String payloadJson;
  final DateTime createdAt;
  final String status;
  const OfflineQueueData({
    required this.id,
    required this.tenantId,
    required this.operationType,
    required this.targetEntity,
    required this.payloadJson,
    required this.createdAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['operation_type'] = Variable<String>(operationType);
    map['target_entity'] = Variable<String>(targetEntity);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  OfflineQueueCompanion toCompanion(bool nullToAbsent) {
    return OfflineQueueCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      operationType: Value(operationType),
      targetEntity: Value(targetEntity),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      status: Value(status),
    );
  }

  factory OfflineQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineQueueData(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      targetEntity: serializer.fromJson<String>(json['targetEntity']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'operationType': serializer.toJson<String>(operationType),
      'targetEntity': serializer.toJson<String>(targetEntity),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
    };
  }

  OfflineQueueData copyWith({
    int? id,
    String? tenantId,
    String? operationType,
    String? targetEntity,
    String? payloadJson,
    DateTime? createdAt,
    String? status,
  }) => OfflineQueueData(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    operationType: operationType ?? this.operationType,
    targetEntity: targetEntity ?? this.targetEntity,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
  );
  OfflineQueueData copyWithCompanion(OfflineQueueCompanion data) {
    return OfflineQueueData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      targetEntity: data.targetEntity.present
          ? data.targetEntity.value
          : this.targetEntity,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('operationType: $operationType, ')
          ..write('targetEntity: $targetEntity, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    operationType,
    targetEntity,
    payloadJson,
    createdAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineQueueData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.operationType == this.operationType &&
          other.targetEntity == this.targetEntity &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.status == this.status);
}

class OfflineQueueCompanion extends UpdateCompanion<OfflineQueueData> {
  final Value<int> id;
  final Value<String> tenantId;
  final Value<String> operationType;
  final Value<String> targetEntity;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<String> status;
  const OfflineQueueCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.targetEntity = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  OfflineQueueCompanion.insert({
    this.id = const Value.absent(),
    required String tenantId,
    required String operationType,
    required String targetEntity,
    required String payloadJson,
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
  }) : tenantId = Value(tenantId),
       operationType = Value(operationType),
       targetEntity = Value(targetEntity),
       payloadJson = Value(payloadJson);
  static Insertable<OfflineQueueData> custom({
    Expression<int>? id,
    Expression<String>? tenantId,
    Expression<String>? operationType,
    Expression<String>? targetEntity,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (operationType != null) 'operation_type': operationType,
      if (targetEntity != null) 'target_entity': targetEntity,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
    });
  }

  OfflineQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? tenantId,
    Value<String>? operationType,
    Value<String>? targetEntity,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<String>? status,
  }) {
    return OfflineQueueCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      operationType: operationType ?? this.operationType,
      targetEntity: targetEntity ?? this.targetEntity,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (targetEntity.present) {
      map['target_entity'] = Variable<String>(targetEntity.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('operationType: $operationType, ')
          ..write('targetEntity: $targetEntity, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MembersTable members = $MembersTable(this);
  late final $AttendanceRecordsTable attendanceRecords =
      $AttendanceRecordsTable(this);
  late final $OfflineQueueTable offlineQueue = $OfflineQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    members,
    attendanceRecords,
    offlineQueue,
  ];
}

typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      required String id,
      required String tenantId,
      required String branchId,
      required String memberNumber,
      required String fullName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> planId,
      Value<String> status,
      Value<DateTime> joinedAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> branchId,
      Value<String> memberNumber,
      Value<String> fullName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> planId,
      Value<String> status,
      Value<DateTime> joinedAt,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberNumber => $composableBuilder(
    column: $table.memberNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberNumber => $composableBuilder(
    column: $table.memberNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get memberNumber => $composableBuilder(
    column: $table.memberNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, BaseReferences<_$AppDatabase, $MembersTable, Member>),
          Member,
          PrefetchHooks Function()
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> memberNumber = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                tenantId: tenantId,
                branchId: branchId,
                memberNumber: memberNumber,
                fullName: fullName,
                email: email,
                phone: phone,
                planId: planId,
                status: status,
                joinedAt: joinedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String branchId,
                required String memberNumber,
                required String fullName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> planId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                tenantId: tenantId,
                branchId: branchId,
                memberNumber: memberNumber,
                fullName: fullName,
                email: email,
                phone: phone,
                planId: planId,
                status: status,
                joinedAt: joinedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, BaseReferences<_$AppDatabase, $MembersTable, Member>),
      Member,
      PrefetchHooks Function()
    >;
typedef $$AttendanceRecordsTableCreateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      required String id,
      required String tenantId,
      required String branchId,
      required String memberId,
      Value<DateTime> checkInAt,
      Value<String> method,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$AttendanceRecordsTableUpdateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      Value<String> id,
      Value<String> tenantId,
      Value<String> branchId,
      Value<String> memberId,
      Value<DateTime> checkInAt,
      Value<String> method,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$AttendanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkInAt => $composableBuilder(
    column: $table.checkInAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkInAt => $composableBuilder(
    column: $table.checkInAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<DateTime> get checkInAt =>
      $composableBuilder(column: $table.checkInAt, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$AttendanceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceRecordsTable,
          AttendanceRecord,
          $$AttendanceRecordsTableFilterComposer,
          $$AttendanceRecordsTableOrderingComposer,
          $$AttendanceRecordsTableAnnotationComposer,
          $$AttendanceRecordsTableCreateCompanionBuilder,
          $$AttendanceRecordsTableUpdateCompanionBuilder,
          (
            AttendanceRecord,
            BaseReferences<
              _$AppDatabase,
              $AttendanceRecordsTable,
              AttendanceRecord
            >,
          ),
          AttendanceRecord,
          PrefetchHooks Function()
        > {
  $$AttendanceRecordsTableTableManager(
    _$AppDatabase db,
    $AttendanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<DateTime> checkInAt = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceRecordsCompanion(
                id: id,
                tenantId: tenantId,
                branchId: branchId,
                memberId: memberId,
                checkInAt: checkInAt,
                method: method,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String branchId,
                required String memberId,
                Value<DateTime> checkInAt = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceRecordsCompanion.insert(
                id: id,
                tenantId: tenantId,
                branchId: branchId,
                memberId: memberId,
                checkInAt: checkInAt,
                method: method,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceRecordsTable,
      AttendanceRecord,
      $$AttendanceRecordsTableFilterComposer,
      $$AttendanceRecordsTableOrderingComposer,
      $$AttendanceRecordsTableAnnotationComposer,
      $$AttendanceRecordsTableCreateCompanionBuilder,
      $$AttendanceRecordsTableUpdateCompanionBuilder,
      (
        AttendanceRecord,
        BaseReferences<
          _$AppDatabase,
          $AttendanceRecordsTable,
          AttendanceRecord
        >,
      ),
      AttendanceRecord,
      PrefetchHooks Function()
    >;
typedef $$OfflineQueueTableCreateCompanionBuilder =
    OfflineQueueCompanion Function({
      Value<int> id,
      required String tenantId,
      required String operationType,
      required String targetEntity,
      required String payloadJson,
      Value<DateTime> createdAt,
      Value<String> status,
    });
typedef $$OfflineQueueTableUpdateCompanionBuilder =
    OfflineQueueCompanion Function({
      Value<int> id,
      Value<String> tenantId,
      Value<String> operationType,
      Value<String> targetEntity,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<String> status,
    });

class $$OfflineQueueTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableFilterComposer({
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

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetEntity => $composableBuilder(
    column: $table.targetEntity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableOrderingComposer({
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

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetEntity => $composableBuilder(
    column: $table.targetEntity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineQueueTable> {
  $$OfflineQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetEntity => $composableBuilder(
    column: $table.targetEntity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$OfflineQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineQueueTable,
          OfflineQueueData,
          $$OfflineQueueTableFilterComposer,
          $$OfflineQueueTableOrderingComposer,
          $$OfflineQueueTableAnnotationComposer,
          $$OfflineQueueTableCreateCompanionBuilder,
          $$OfflineQueueTableUpdateCompanionBuilder,
          (
            OfflineQueueData,
            BaseReferences<_$AppDatabase, $OfflineQueueTable, OfflineQueueData>,
          ),
          OfflineQueueData,
          PrefetchHooks Function()
        > {
  $$OfflineQueueTableTableManager(_$AppDatabase db, $OfflineQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> targetEntity = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => OfflineQueueCompanion(
                id: id,
                tenantId: tenantId,
                operationType: operationType,
                targetEntity: targetEntity,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tenantId,
                required String operationType,
                required String targetEntity,
                required String payloadJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => OfflineQueueCompanion.insert(
                id: id,
                tenantId: tenantId,
                operationType: operationType,
                targetEntity: targetEntity,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineQueueTable,
      OfflineQueueData,
      $$OfflineQueueTableFilterComposer,
      $$OfflineQueueTableOrderingComposer,
      $$OfflineQueueTableAnnotationComposer,
      $$OfflineQueueTableCreateCompanionBuilder,
      $$OfflineQueueTableUpdateCompanionBuilder,
      (
        OfflineQueueData,
        BaseReferences<_$AppDatabase, $OfflineQueueTable, OfflineQueueData>,
      ),
      OfflineQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$AttendanceRecordsTableTableManager get attendanceRecords =>
      $$AttendanceRecordsTableTableManager(_db, _db.attendanceRecords);
  $$OfflineQueueTableTableManager get offlineQueue =>
      $$OfflineQueueTableTableManager(_db, _db.offlineQueue);
}
