part of 'statistique_screen.dart';

class StatisticsScreenController extends ScreenController {
  StatisticsScreenController(super.state, this.vsync);
  final TickerProvider vsync;
  late TabController _tabController;
  String selectedPeriod = 'Ce mois';

  @override
  void onInit() {
    super.onInit();
    _tabController = TabController(length: 3, vsync: vsync);
  }

  @override
  void onDispose() {
    _tabController.dispose();
    super.onDispose();
  }
}
