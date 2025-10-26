// ...existing code...
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prog2025_firtst/models/points_dao.dart';
import 'package:prog2025_firtst/database/points.dart';
import '../widgets/points_card.dart';
import '../widgets/reward_action_button.dart';
import '../widgets/reward_item.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final ValueNotifier<int> points = ValueNotifier<int>(0);
  final int maxLevel = 1000;
  final PointsDatabase _pointsDb = PointsDatabase();

  User? user = FirebaseAuth.instance.currentUser;
  String get userId => user?.uid ?? 'guest';

  List<PointsDao> _recent = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPointsData();
  }

  Future<void> _loadPointsData() async {
    setState(() => _loading = true);
    try {
      final bal = await _pointsDb.GET_TOTAL_BALANCE();
      final recent = await _pointsDb.SELECT_RECENT(20);
      points.value = bal.round();
      _recent = recent.where((p) => p.userId == null || p.userId == userId).toList();
    } catch (e) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addPoints(double amount, String type, String description) async {
    final now = DateTime.now().toIso8601String();
    final dao = PointsDao(
      type: type,
      ammount: amount,
      date: now,
      description: description,
      userId: userId,
    );
    await _pointsDb.INSERT(dao);
    await _loadPointsData();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('+$amount puntos agregados')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<int>(
              valueListenable: points,
              builder: (context, value, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PointsCard(value: value, maxLevel: maxLevel),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          RewardActionButton(
                            title: "Redeem\nHistory",
                            icon: Icons.card_giftcard,
                            iconColor: Colors.redAccent,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          RewardActionButton(
                            title: "How to\nearn point?",
                            icon: Icons.attach_money,
                            iconColor: Colors.greenAccent,
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
                        onTap: () => _addPoints(50.0, 'REFERRAL', 'Refer first friend'),
                      ),
                      const SizedBox(height: 12),
                      RewardItem(
                        icon: Icons.account_balance_wallet,
                        color: Colors.green,
                        title: "Add 50\$ To App Balance",
                        subtitle: "Put money in first time",
                        points: "+500",
                        onTap: () => _addPoints(500.0, 'TOPUP', 'Top up first time'),
                      ),
                      const SizedBox(height: 12),
                      RewardItem(
                        icon: Icons.shopping_cart,
                        color: Colors.purple,
                        title: "First Spend 25\$",
                        subtitle: "Make the first 25\$ history with app",
                        points: "+250",
                        onTap: () => _addPoints(250.0, 'PURCHASE', 'First spend >= 25'),
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Recent points activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recent.length,
                        separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                        itemBuilder: (context, index) {
                          final p = _recent[index];
                          final amt = p.ammount ?? 0.0;
                          final sign = amt >= 0 ? '+' : '';
                          final date = p.date != null ? p.date!.split('T').first : '';
                          return ListTile(
                            tileColor: const Color(0xFF12121A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: amt >= 0 ? Colors.green : Colors.red,
                              child: Text(sign + amt.round().toString()),
                            ),
                            title: Text(p.type ?? 'Points', style: const TextStyle(color: Colors.white)),
                            subtitle: Text(p.description ?? '', style: const TextStyle(color: Colors.white70)),
                            trailing: Text(date, style: const TextStyle(color: Colors.white54)),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
// ...existing code...