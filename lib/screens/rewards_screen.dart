import 'package:flutter/material.dart';
import '../widgets/points_card.dart';
import '../widgets/reward_action_button.dart';
import '../widgets/reward_item.dart';


class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final ValueNotifier<int> points = ValueNotifier<int>(100);
  final int maxLevel = 1000;

  void addPoints(int value) {
    points.value += value;
    if (points.value > maxLevel) points.value = maxLevel;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("+$value points added! 🎉")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: points,
        builder: (context, value, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PointsCard(value: value, maxLevel: maxLevel),
                const SizedBox(height: 16),

                Row(
                  children: [
                    RewardActionButton(
                      title: "Redeem\nHistory",
                      icon: Icons.card_giftcard,
                      iconColor: Colors.red,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    RewardActionButton(
                      title: "How to\nearn point?",
                      icon: Icons.attach_money,
                      iconColor: Colors.green,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                RewardItem(
                  icon: Icons.person_add,
                  color: Colors.orange,
                  title: "Refer First Friend!",
                  subtitle: "Invite your first friend to register",
                  points: "+50",
                  onTap: () => addPoints(50),
                ),
                const SizedBox(height: 12),
                RewardItem(
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                  title: "Add 50\$ To App Balance",
                  subtitle: "Put money in first time",
                  points: "+500",
                  onTap: () => addPoints(500),
                ),
                const SizedBox(height: 12),
                RewardItem(
                  icon: Icons.shopping_cart,
                  color: Colors.purple,
                  title: "First Spend 25\$",
                  subtitle: "Make the first 25\$ history with app",
                  points: "+250",
                  onTap: () => addPoints(250),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
