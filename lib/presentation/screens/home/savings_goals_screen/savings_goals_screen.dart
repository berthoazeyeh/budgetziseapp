import 'package:auto_route/auto_route.dart';
import 'package:budget_zise/router/app_router.dart';
import 'package:flutter/material.dart';

// Modèle de données pour un objectif d'épargne
class SavingsGoal {
  final String title;
  final String emoji;
  final double currentAmount;
  final double targetAmount;
  final String deadline;
  final Color color;

  SavingsGoal({
    required this.title,
    required this.emoji,
    required this.currentAmount,
    required this.targetAmount,
    required this.deadline,
    required this.color,
  });

  double get progressPercentage =>
      (currentAmount / targetAmount * 100).clamp(0, 100);
  double get remainingAmount => targetAmount - currentAmount;
}

@RoutePage()
class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  State<SavingsGoalsScreen> createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  final List<SavingsGoal> goals = [
    SavingsGoal(
      title: 'Vacances d\'été',
      emoji: '🏖️',
      currentAmount: 1200,
      targetAmount: 2500,
      deadline: 'Juin 2025',
      color: Colors.green,
    ),
    SavingsGoal(
      title: 'Nouvelle voiture',
      emoji: '🚗',
      currentAmount: 2800,
      targetAmount: 15000,
      deadline: 'Décembre 2025',
      color: Colors.amber,
    ),
    SavingsGoal(
      title: 'Nouvelle voiture',
      emoji: '🚗',
      currentAmount: 2800,
      targetAmount: 15000,
      deadline: 'Décembre 2025',
      color: Colors.amber,
    ),
    SavingsGoal(
      title: 'Apport appartement',
      emoji: '🏠',
      currentAmount: 7500,
      targetAmount: 25000,
      deadline: 'Long terme',
      color: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header avec résumé total
            SavingsHeader(),

            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Titre et bouton d'ajout
                    GoalsListHeader(),

                    SizedBox(height: 20),
                    // Liste des objectifs
                    ...goals.map(
                      (goal) => Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: GoalCard(goal: goal),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Conseils d'épargne
                    SavingsAdviceCard(),

                    SizedBox(height: 20),

                    // Graphique d'évolution
                    SavingsChartCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Header avec gradient et résumé de l'épargne totale
class SavingsHeader extends StatelessWidget {
  const SavingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre principal
          Row(
            children: [
              Text(
                'Objectifs d\'épargne',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Résumé de l'épargne totale
          SavingsSummaryCard(),
        ],
      ),
    );
  }
}

// Card de résumé de l'épargne totale
class SavingsSummaryCard extends StatelessWidget {
  const SavingsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et indicateur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Épargne totale',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '📈 +8% ce mois',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[300],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Montant principal
          Text(
            '4,750 €',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8),

          // Objectif annuel
          Text(
            'Objectif annuel : 12,000 €',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: 12),

          // Barre de progression
          ProgressBar(
            progress: 0.395,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            progressColor: Colors.white.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }
}

// Header de la liste des objectifs
class GoalsListHeader extends StatelessWidget {
  const GoalsListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mes objectifs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1e293b),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.router.push(const NewSavingsGoalRoute());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF667eea),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            '+ Nouvel objectif',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Card pour un objectif d'épargne individuel
class GoalCard extends StatelessWidget {
  final SavingsGoal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFf8fafc),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFe2e8f0)),
      ),
      child: Row(
        children: [
          // Icône de l'objectif
          GoalIcon(emoji: goal.emoji, color: goal.color),

          SizedBox(width: 10),

          // Informations de progression
          Expanded(child: GoalProgress(goal: goal)),
        ],
      ),
    );
  }
}

// Icône de l'objectif
class GoalIcon extends StatelessWidget {
  final String emoji;
  final Color color;

  const GoalIcon({super.key, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(emoji, style: TextStyle(fontSize: 24))),
    );
  }
}

// Informations de progression d'un objectif
class GoalProgress extends StatelessWidget {
  final SavingsGoal goal;

  const GoalProgress({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre et montants
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 3,
          children: [
            Expanded(
              child: Text(
                goal.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1e293b),
                ),
              ),
            ),
            Text(
              '${goal.currentAmount.toInt()}€ / ${goal.targetAmount.toInt()}€',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: goal.color,
              ),
            ),
          ],
        ),

        SizedBox(height: 8),

        // Barre de progression
        ProgressBar(
          progress: goal.progressPercentage / 100,
          progressColor: goal.color,
        ),

        SizedBox(height: 8),

        // Informations supplémentaires
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reste ${goal.remainingAmount.toInt()}€',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748b)),
            ),
            Text(
              goal.deadline,
              style: TextStyle(fontSize: 12, color: Color(0xFF64748b)),
            ),
          ],
        ),
      ],
    );
  }
}

// Composant de barre de progression réutilisable
class ProgressBar extends StatelessWidget {
  final double progress;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.progressColor,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFFf1f5f9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0.0, 1.0),
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: progressColor ?? Color(0xFF667eea),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}

// Card de conseils d'épargne
class SavingsAdviceCard extends StatelessWidget {
  const SavingsAdviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFf0f9ff), Color(0xFFe0f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec icône
          Row(
            children: [
              Text('💰', style: TextStyle(fontSize: 24)),
              SizedBox(width: 12),
              Text(
                'Conseils d\'épargne',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0c4a6e),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Conseil principal
          Text(
            'Vous êtes en avance sur votre objectif vacances ! Pensez à mettre en place un virement automatique pour votre épargne logement.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF0c4a6e),
            ),
          ),

          SizedBox(height: 8),

          // Objectif suggéré
          Text(
            '🎯 Objectif suggéré : Économiser 300€ de plus ce mois-ci.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF0c4a6e),
            ),
          ),
        ],
      ),
    );
  }
}

// Card du graphique d'évolution
class SavingsChartCard extends StatelessWidget {
  const SavingsChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Évolution de l\'épargne',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1e293b),
            ),
          ),

          SizedBox(height: 16),

          // Placeholder pour le graphique
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFf8fafc), Color(0xFFe2e8f0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '📈 Graphique d\'évolution mensuelle',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748b),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
