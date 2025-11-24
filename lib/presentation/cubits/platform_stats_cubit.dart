import 'package:budget_zise/data/dto/platform_stats.dart';
import 'package:budget_zise/domain/repositories/public_repository.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:hydrated_bloc/hydrated_bloc.dart';

class PlatformStatsCubit extends HydratedCubit<PlatformStatsState> {
  PublicRepository publicRepository;
  PlatformStatsCubit(this.publicRepository) : super(PlatformStatsState()) {
    fetchPlatformStats();
  }

  void setValue(PlatformStatsState value) => emit(value);

  void clearUser() => emit(PlatformStatsState());

  PlatformStatsState get getCount => state;

  Future<void> fetchPlatformStats() async {
    if (state.isFechting) {
      return;
    }
    try {
      emit(PlatformStatsState(isFechting: true));
      final platformStats = await publicRepository.getAppStats();
      debugPrint("platformStats----------: $platformStats");
      emit(PlatformStatsState(platformStats: platformStats, isFechting: false));
    } catch (e) {
      emit(PlatformStatsState(error: e.toString()));
    }
  }

  @override
  PlatformStatsState? fromJson(Map<String, dynamic> json) {
    try {
      return PlatformStatsState.fromJson(json);
    } catch (_) {
      return PlatformStatsState();
    }
  }

  @override
  Map<String, dynamic>? toJson(PlatformStatsState state) {
    return state.toJson();
  }
}

class PlatformStatsState {
  final bool isFechting;
  final String? error;
  final PlatformStats platformStats;

  PlatformStatsState({
    this.isFechting = false,
    this.error,
    PlatformStats? platformStats,
  }) : platformStats =
           platformStats ??
           const PlatformStats(
             averageReview: 0,
             totalRecharges: 0,
             totalUsers: 0,
             currency: '',
             availability: 0,
           );

  PlatformStatsState copyWith({
    bool? isFechting,
    String? error,
    PlatformStats? platformStats,
  }) {
    return PlatformStatsState(
      isFechting: isFechting ?? this.isFechting,
      error: error ?? this.error,
      platformStats: platformStats ?? this.platformStats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFechting': isFechting,
      'error': error,
      'platformStats': platformStats,
    };
  }

  factory PlatformStatsState.fromJson(Map<String, dynamic> json) {
    return PlatformStatsState(
      isFechting: json['isFechting'] ?? false,
      error: json['error'],
      platformStats:
          json['platformStats'] ??
          const PlatformStats(
            averageReview: 0,
            totalRecharges: 0,
            totalUsers: 0,
            currency: '',
            availability: 0,
          ),
    );
  }
}
