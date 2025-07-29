import 'package:budget_zise/domain/repositories/dashboard_repository.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:hydrated_bloc/hydrated_bloc.dart';

class NotificationCountCubit extends HydratedCubit<NotificationState> {
  DashboardRepository dashboardRepository;
  NotificationCountCubit(this.dashboardRepository)
    : super(NotificationState()) {
    fetchNotificationCount();
  }

  void setValue(NotificationState value) => emit(value);

  void clearUser() => emit(NotificationState());

  NotificationState get getCount => state;

  Future<void> fetchNotificationCount() async {
    if (state.isFechting) return;
    try {
      emit(NotificationState(isFechting: true));
      final count = await dashboardRepository.getUnreadNotificationsCount();
      debugPrint("count----------: $count");
      emit(NotificationState(count: count, isFechting: false));
    } catch (e) {
      emit(NotificationState());
    }
  }

  @override
  NotificationState? fromJson(Map<String, dynamic> json) {
    try {
      return NotificationState.fromJson(json);
    } catch (_) {
      return NotificationState();
    }
  }

  @override
  Map<String, dynamic>? toJson(NotificationState state) {
    return state.toJson();
  }
}

class NotificationState {
  final bool isFechting;
  final int count;

  NotificationState({this.isFechting = false, this.count = 0});

  NotificationState copyWith({bool? isFechting, int? count}) {
    return NotificationState(
      isFechting: isFechting ?? this.isFechting,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toJson() {
    return {'isFechting': isFechting, 'count': count};
  }

  factory NotificationState.fromJson(Map<String, dynamic> json) {
    return NotificationState(
      isFechting: json['isFechting'] ?? false,
      count: json['count'] ?? 0,
    );
  }
}
