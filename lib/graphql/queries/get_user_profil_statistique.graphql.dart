import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;
import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;

class Variables$Query$GetUserProfileStatistique {
  factory Variables$Query$GetUserProfileStatistique({required int userID}) =>
      Variables$Query$GetUserProfileStatistique._({r'userID': userID});

  Variables$Query$GetUserProfileStatistique._(this._$data);

  factory Variables$Query$GetUserProfileStatistique.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$userID = data['userID'];
    result$data['userID'] = (l$userID as int);
    return Variables$Query$GetUserProfileStatistique._(result$data);
  }

  Map<String, dynamic> _$data;

  int get userID => (_$data['userID'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$userID = userID;
    result$data['userID'] = l$userID;
    return result$data;
  }

  CopyWith$Variables$Query$GetUserProfileStatistique<
    Variables$Query$GetUserProfileStatistique
  >
  get copyWith =>
      CopyWith$Variables$Query$GetUserProfileStatistique(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$GetUserProfileStatistique ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$userID = userID;
    final lOther$userID = other.userID;
    if (l$userID != lOther$userID) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$userID = userID;
    return Object.hashAll([l$userID]);
  }
}

abstract class CopyWith$Variables$Query$GetUserProfileStatistique<TRes> {
  factory CopyWith$Variables$Query$GetUserProfileStatistique(
    Variables$Query$GetUserProfileStatistique instance,
    TRes Function(Variables$Query$GetUserProfileStatistique) then,
  ) = _CopyWithImpl$Variables$Query$GetUserProfileStatistique;

  factory CopyWith$Variables$Query$GetUserProfileStatistique.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$GetUserProfileStatistique;

  TRes call({int? userID});
}

class _CopyWithImpl$Variables$Query$GetUserProfileStatistique<TRes>
    implements CopyWith$Variables$Query$GetUserProfileStatistique<TRes> {
  _CopyWithImpl$Variables$Query$GetUserProfileStatistique(
    this._instance,
    this._then,
  );

  final Variables$Query$GetUserProfileStatistique _instance;

  final TRes Function(Variables$Query$GetUserProfileStatistique) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? userID = _undefined}) => _then(
    Variables$Query$GetUserProfileStatistique._({
      ..._instance._$data,
      if (userID != _undefined && userID != null) 'userID': (userID as int),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$GetUserProfileStatistique<TRes>
    implements CopyWith$Variables$Query$GetUserProfileStatistique<TRes> {
  _CopyWithStubImpl$Variables$Query$GetUserProfileStatistique(this._res);

  TRes _res;

  call({int? userID}) => _res;
}

class Query$GetUserProfileStatistique {
  Query$GetUserProfileStatistique({
    required this.userProfileStatistique,
    this.$__typename = 'Query',
  });

  factory Query$GetUserProfileStatistique.fromJson(Map<String, dynamic> json) {
    final l$userProfileStatistique = json['userProfileStatistique'];
    final l$$__typename = json['__typename'];
    return Query$GetUserProfileStatistique(
      userProfileStatistique:
          Query$GetUserProfileStatistique$userProfileStatistique.fromJson(
            (l$userProfileStatistique as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$GetUserProfileStatistique$userProfileStatistique
  userProfileStatistique;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$userProfileStatistique = userProfileStatistique;
    _resultData['userProfileStatistique'] = l$userProfileStatistique.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$userProfileStatistique = userProfileStatistique;
    final l$$__typename = $__typename;
    return Object.hashAll([l$userProfileStatistique, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetUserProfileStatistique ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$userProfileStatistique = userProfileStatistique;
    final lOther$userProfileStatistique = other.userProfileStatistique;
    if (l$userProfileStatistique != lOther$userProfileStatistique) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetUserProfileStatistique
    on Query$GetUserProfileStatistique {
  CopyWith$Query$GetUserProfileStatistique<Query$GetUserProfileStatistique>
  get copyWith => CopyWith$Query$GetUserProfileStatistique(this, (i) => i);
}

abstract class CopyWith$Query$GetUserProfileStatistique<TRes> {
  factory CopyWith$Query$GetUserProfileStatistique(
    Query$GetUserProfileStatistique instance,
    TRes Function(Query$GetUserProfileStatistique) then,
  ) = _CopyWithImpl$Query$GetUserProfileStatistique;

  factory CopyWith$Query$GetUserProfileStatistique.stub(TRes res) =
      _CopyWithStubImpl$Query$GetUserProfileStatistique;

  TRes call({
    Query$GetUserProfileStatistique$userProfileStatistique?
    userProfileStatistique,
    String? $__typename,
  });
  CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<TRes>
  get userProfileStatistique;
}

class _CopyWithImpl$Query$GetUserProfileStatistique<TRes>
    implements CopyWith$Query$GetUserProfileStatistique<TRes> {
  _CopyWithImpl$Query$GetUserProfileStatistique(this._instance, this._then);

  final Query$GetUserProfileStatistique _instance;

  final TRes Function(Query$GetUserProfileStatistique) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? userProfileStatistique = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetUserProfileStatistique(
      userProfileStatistique:
          userProfileStatistique == _undefined || userProfileStatistique == null
          ? _instance.userProfileStatistique
          : (userProfileStatistique
                as Query$GetUserProfileStatistique$userProfileStatistique),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<TRes>
  get userProfileStatistique {
    final local$userProfileStatistique = _instance.userProfileStatistique;
    return CopyWith$Query$GetUserProfileStatistique$userProfileStatistique(
      local$userProfileStatistique,
      (e) => call(userProfileStatistique: e),
    );
  }
}

class _CopyWithStubImpl$Query$GetUserProfileStatistique<TRes>
    implements CopyWith$Query$GetUserProfileStatistique<TRes> {
  _CopyWithStubImpl$Query$GetUserProfileStatistique(this._res);

  TRes _res;

  call({
    Query$GetUserProfileStatistique$userProfileStatistique?
    userProfileStatistique,
    String? $__typename,
  }) => _res;

  CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<TRes>
  get userProfileStatistique =>
      CopyWith$Query$GetUserProfileStatistique$userProfileStatistique.stub(
        _res,
      );
}

const documentNodeQueryGetUserProfileStatistique = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetUserProfileStatistique'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'userID')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'userProfileStatistique'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'userID'),
                value: VariableNode(name: NameNode(value: 'userID')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'budgetCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'transactionCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'registrationDate'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'profit'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'currentMonthTransactionCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'currentMonthBudgetCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'currentMonthProfit'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
  ],
);
Query$GetUserProfileStatistique _parserFn$Query$GetUserProfileStatistique(
  Map<String, dynamic> data,
) => Query$GetUserProfileStatistique.fromJson(data);
typedef OnQueryComplete$Query$GetUserProfileStatistique =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Query$GetUserProfileStatistique?,
    );

class Options$Query$GetUserProfileStatistique
    extends graphql.QueryOptions<Query$GetUserProfileStatistique> {
  Options$Query$GetUserProfileStatistique({
    String? operationName,
    required Variables$Query$GetUserProfileStatistique variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetUserProfileStatistique? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$GetUserProfileStatistique? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null
                     ? null
                     : _parserFn$Query$GetUserProfileStatistique(data),
               ),
         onError: onError,
         document: documentNodeQueryGetUserProfileStatistique,
         parserFn: _parserFn$Query$GetUserProfileStatistique,
       );

  final OnQueryComplete$Query$GetUserProfileStatistique? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$GetUserProfileStatistique
    extends graphql.WatchQueryOptions<Query$GetUserProfileStatistique> {
  WatchOptions$Query$GetUserProfileStatistique({
    String? operationName,
    required Variables$Query$GetUserProfileStatistique variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$GetUserProfileStatistique? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryGetUserProfileStatistique,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$GetUserProfileStatistique,
       );
}

class FetchMoreOptions$Query$GetUserProfileStatistique
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$GetUserProfileStatistique({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$GetUserProfileStatistique variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryGetUserProfileStatistique,
       );
}

extension ClientExtension$Query$GetUserProfileStatistique
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$GetUserProfileStatistique>>
  query$GetUserProfileStatistique(
    Options$Query$GetUserProfileStatistique options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$GetUserProfileStatistique>
  watchQuery$GetUserProfileStatistique(
    WatchOptions$Query$GetUserProfileStatistique options,
  ) => this.watchQuery(options);

  void writeQuery$GetUserProfileStatistique({
    required Query$GetUserProfileStatistique data,
    required Variables$Query$GetUserProfileStatistique variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(
        document: documentNodeQueryGetUserProfileStatistique,
      ),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$GetUserProfileStatistique? readQuery$GetUserProfileStatistique({
    required Variables$Query$GetUserProfileStatistique variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryGetUserProfileStatistique,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Query$GetUserProfileStatistique.fromJson(result);
  }
}

graphql_flutter.QueryHookResult<Query$GetUserProfileStatistique>
useQuery$GetUserProfileStatistique(
  Options$Query$GetUserProfileStatistique options,
) => graphql_flutter.useQuery(options);
graphql.ObservableQuery<Query$GetUserProfileStatistique>
useWatchQuery$GetUserProfileStatistique(
  WatchOptions$Query$GetUserProfileStatistique options,
) => graphql_flutter.useWatchQuery(options);

class Query$GetUserProfileStatistique$Widget
    extends graphql_flutter.Query<Query$GetUserProfileStatistique> {
  Query$GetUserProfileStatistique$Widget({
    widgets.Key? key,
    required Options$Query$GetUserProfileStatistique options,
    required graphql_flutter.QueryBuilder<Query$GetUserProfileStatistique>
    builder,
  }) : super(key: key, options: options, builder: builder);
}

class Query$GetUserProfileStatistique$userProfileStatistique {
  Query$GetUserProfileStatistique$userProfileStatistique({
    required this.budgetCount,
    required this.transactionCount,
    required this.registrationDate,
    required this.profit,
    required this.currentMonthTransactionCount,
    required this.currentMonthBudgetCount,
    required this.currentMonthProfit,
    this.$__typename = 'UserProfileStatistique',
  });

  factory Query$GetUserProfileStatistique$userProfileStatistique.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$budgetCount = json['budgetCount'];
    final l$transactionCount = json['transactionCount'];
    final l$registrationDate = json['registrationDate'];
    final l$profit = json['profit'];
    final l$currentMonthTransactionCount = json['currentMonthTransactionCount'];
    final l$currentMonthBudgetCount = json['currentMonthBudgetCount'];
    final l$currentMonthProfit = json['currentMonthProfit'];
    final l$$__typename = json['__typename'];
    return Query$GetUserProfileStatistique$userProfileStatistique(
      budgetCount: (l$budgetCount as int),
      transactionCount: (l$transactionCount as int),
      registrationDate: DateTime.parse((l$registrationDate as String)),
      profit: (l$profit as String),
      currentMonthTransactionCount: (l$currentMonthTransactionCount as int),
      currentMonthBudgetCount: (l$currentMonthBudgetCount as int),
      currentMonthProfit: (l$currentMonthProfit as String),
      $__typename: (l$$__typename as String),
    );
  }

  final int budgetCount;

  final int transactionCount;

  final DateTime registrationDate;

  final String profit;

  final int currentMonthTransactionCount;

  final int currentMonthBudgetCount;

  final String currentMonthProfit;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$budgetCount = budgetCount;
    _resultData['budgetCount'] = l$budgetCount;
    final l$transactionCount = transactionCount;
    _resultData['transactionCount'] = l$transactionCount;
    final l$registrationDate = registrationDate;
    _resultData['registrationDate'] = l$registrationDate.toIso8601String();
    final l$profit = profit;
    _resultData['profit'] = l$profit;
    final l$currentMonthTransactionCount = currentMonthTransactionCount;
    _resultData['currentMonthTransactionCount'] =
        l$currentMonthTransactionCount;
    final l$currentMonthBudgetCount = currentMonthBudgetCount;
    _resultData['currentMonthBudgetCount'] = l$currentMonthBudgetCount;
    final l$currentMonthProfit = currentMonthProfit;
    _resultData['currentMonthProfit'] = l$currentMonthProfit;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$budgetCount = budgetCount;
    final l$transactionCount = transactionCount;
    final l$registrationDate = registrationDate;
    final l$profit = profit;
    final l$currentMonthTransactionCount = currentMonthTransactionCount;
    final l$currentMonthBudgetCount = currentMonthBudgetCount;
    final l$currentMonthProfit = currentMonthProfit;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$budgetCount,
      l$transactionCount,
      l$registrationDate,
      l$profit,
      l$currentMonthTransactionCount,
      l$currentMonthBudgetCount,
      l$currentMonthProfit,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$GetUserProfileStatistique$userProfileStatistique ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$budgetCount = budgetCount;
    final lOther$budgetCount = other.budgetCount;
    if (l$budgetCount != lOther$budgetCount) {
      return false;
    }
    final l$transactionCount = transactionCount;
    final lOther$transactionCount = other.transactionCount;
    if (l$transactionCount != lOther$transactionCount) {
      return false;
    }
    final l$registrationDate = registrationDate;
    final lOther$registrationDate = other.registrationDate;
    if (l$registrationDate != lOther$registrationDate) {
      return false;
    }
    final l$profit = profit;
    final lOther$profit = other.profit;
    if (l$profit != lOther$profit) {
      return false;
    }
    final l$currentMonthTransactionCount = currentMonthTransactionCount;
    final lOther$currentMonthTransactionCount =
        other.currentMonthTransactionCount;
    if (l$currentMonthTransactionCount != lOther$currentMonthTransactionCount) {
      return false;
    }
    final l$currentMonthBudgetCount = currentMonthBudgetCount;
    final lOther$currentMonthBudgetCount = other.currentMonthBudgetCount;
    if (l$currentMonthBudgetCount != lOther$currentMonthBudgetCount) {
      return false;
    }
    final l$currentMonthProfit = currentMonthProfit;
    final lOther$currentMonthProfit = other.currentMonthProfit;
    if (l$currentMonthProfit != lOther$currentMonthProfit) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$GetUserProfileStatistique$userProfileStatistique
    on Query$GetUserProfileStatistique$userProfileStatistique {
  CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<
    Query$GetUserProfileStatistique$userProfileStatistique
  >
  get copyWith =>
      CopyWith$Query$GetUserProfileStatistique$userProfileStatistique(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<
  TRes
> {
  factory CopyWith$Query$GetUserProfileStatistique$userProfileStatistique(
    Query$GetUserProfileStatistique$userProfileStatistique instance,
    TRes Function(Query$GetUserProfileStatistique$userProfileStatistique) then,
  ) = _CopyWithImpl$Query$GetUserProfileStatistique$userProfileStatistique;

  factory CopyWith$Query$GetUserProfileStatistique$userProfileStatistique.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$GetUserProfileStatistique$userProfileStatistique;

  TRes call({
    int? budgetCount,
    int? transactionCount,
    DateTime? registrationDate,
    String? profit,
    int? currentMonthTransactionCount,
    int? currentMonthBudgetCount,
    String? currentMonthProfit,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$GetUserProfileStatistique$userProfileStatistique<TRes>
    implements
        CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<TRes> {
  _CopyWithImpl$Query$GetUserProfileStatistique$userProfileStatistique(
    this._instance,
    this._then,
  );

  final Query$GetUserProfileStatistique$userProfileStatistique _instance;

  final TRes Function(Query$GetUserProfileStatistique$userProfileStatistique)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? budgetCount = _undefined,
    Object? transactionCount = _undefined,
    Object? registrationDate = _undefined,
    Object? profit = _undefined,
    Object? currentMonthTransactionCount = _undefined,
    Object? currentMonthBudgetCount = _undefined,
    Object? currentMonthProfit = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$GetUserProfileStatistique$userProfileStatistique(
      budgetCount: budgetCount == _undefined || budgetCount == null
          ? _instance.budgetCount
          : (budgetCount as int),
      transactionCount:
          transactionCount == _undefined || transactionCount == null
          ? _instance.transactionCount
          : (transactionCount as int),
      registrationDate:
          registrationDate == _undefined || registrationDate == null
          ? _instance.registrationDate
          : (registrationDate as DateTime),
      profit: profit == _undefined || profit == null
          ? _instance.profit
          : (profit as String),
      currentMonthTransactionCount:
          currentMonthTransactionCount == _undefined ||
              currentMonthTransactionCount == null
          ? _instance.currentMonthTransactionCount
          : (currentMonthTransactionCount as int),
      currentMonthBudgetCount:
          currentMonthBudgetCount == _undefined ||
              currentMonthBudgetCount == null
          ? _instance.currentMonthBudgetCount
          : (currentMonthBudgetCount as int),
      currentMonthProfit:
          currentMonthProfit == _undefined || currentMonthProfit == null
          ? _instance.currentMonthProfit
          : (currentMonthProfit as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$GetUserProfileStatistique$userProfileStatistique<
  TRes
>
    implements
        CopyWith$Query$GetUserProfileStatistique$userProfileStatistique<TRes> {
  _CopyWithStubImpl$Query$GetUserProfileStatistique$userProfileStatistique(
    this._res,
  );

  TRes _res;

  call({
    int? budgetCount,
    int? transactionCount,
    DateTime? registrationDate,
    String? profit,
    int? currentMonthTransactionCount,
    int? currentMonthBudgetCount,
    String? currentMonthProfit,
    String? $__typename,
  }) => _res;
}
