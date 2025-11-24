import 'package:budget_zise/budget_zise.dart';
import 'package:budget_zise/presentation/cubits/platform_stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatformStatsCubit, PlatformStatsState>(
      bloc: context.read<PlatformStatsCubit>(),
      builder: (context, state) {
        final List<Map<String, String>> stats = [
          {
            'value': '${state.platformStats.totalUsers} ',
            'label': LocaleKeys.home_stats_active_users.tr(),
          },
          {
            'value':
                '${state.platformStats.currency}${state.platformStats.totalRecharges} ',
            'label': LocaleKeys.home_stats_savings.tr(),
          },
          {
            'value': state.platformStats.averageReview.toString(),
            'label': LocaleKeys.home_stats_rating.tr(),
          },
          {
            'value': state.platformStats.availability.toString(),
            'label': LocaleKeys.home_stats_availability.tr(),
          },
        ];
        return Skeletonizer(
          enabled: state.isFechting,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.spaceBetween,
              children: stats.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        item['value']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
