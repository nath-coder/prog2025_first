import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:prog2025_firtst/database/purchase.dart';
import 'package:prog2025_firtst/database/points.dart';
import 'package:prog2025_firtst/models/purchase_dao.dart';
import 'package:prog2025_firtst/models/points_dao.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar - Purchases & Points',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPurchasesPage(),
    );
  }
}

class EventItem {
  final String kind; // 'purchase' or 'points'
  final String title;
  final String subtitle;
  final double? value;
  final DateTime date;
  final dynamic raw;

  EventItem({
    required this.kind,
    required this.title,
    required this.subtitle,
    this.value,
    required this.date,
    this.raw,
  });

  @override
  String toString() => '$kind: $title';
}

class CalendarPurchasesPage extends StatefulWidget {
  const CalendarPurchasesPage({super.key});

  @override
  State<CalendarPurchasesPage> createState() => _CalendarPurchasesPageState();
}

class _CalendarPurchasesPageState extends State<CalendarPurchasesPage> {
  final PurchaseDatabaseCRUD _purchaseDb = PurchaseDatabaseCRUD();
  final PointsDatabase _pointsDb = PointsDatabase();

  late final ValueNotifier<List<EventItem>> _selectedEvents;
  Map<DateTime, List<EventItem>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _showPurchases = true;
  bool _showPoints = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  DateTime _normalize(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime? _parseDateString(String? s) {
    if (s == null) return null;
    // try ISO parse
    try {
      final d = DateTime.parse(s);
      return _normalize(d);
    } catch (_) {}
    // try common formats (yyyy-MM-dd or yyyy-MM-dd HH:mm:ss)
    try {
      final first = s.split(' ').first;
      final parts = first.split(RegExp(r'[-/]'));
      if (parts.length >= 3) {
        final y = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final d = int.tryParse(parts[2]);
        if (y != null && m != null && d != null) return _normalize(DateTime(y, m, d));
      }
    } catch (_) {}
    return null;
  }

  Future<void> _loadEvents() async {
    setState(() => _loading = true);
    final Map<DateTime, List<EventItem>> map = {};

    try {
      // Load purchases
      final purchases = await _purchaseDb.SELECT();
      for (final PurchaseDao p in purchases) {
        final dt = _parseDateString(p.date) ?? _normalize(DateTime.now());
        final item = EventItem(
          kind: 'purchase',
          title: 'Compra #${p.idPurchase ?? '-'}',
          subtitle: 'Estado: ${p.state ?? 'unknown'} - total: ${p.total ?? 0}',
          value: p.total,
          date: dt,
          raw: p,
        );
        map.putIfAbsent(dt, () => []).add(item);
      }
    } catch (e) {
      // ignore load errors
    }

    try {
      // Load points
      final points = await _pointsDb.SELECT();
      for (final PointsDao pt in points) {
        final dt = _parseDateString(pt.date) ?? _normalize(DateTime.now());
        final item = EventItem(
          kind: 'points',
          title: '${pt.type ?? 'Points'}',
          subtitle: pt.description ?? '',
          value: pt.ammount,
          date: dt,
          raw: pt,
        );
        map.putIfAbsent(dt, () => []).add(item);
      }
    } catch (e) {
      // ignore load errors
    }

    setState(() {
      _events = map;
      _loading = false;
      _updateSelectedEvents();
    });
  }

  List<EventItem> _getEventsForDay(DateTime day) {
    final d = _normalize(day);
    final list = _events[d] ?? [];
    return list.where((e) {
      if (e.kind == 'purchase' && !_showPurchases) return false;
      if (e.kind == 'points' && !_showPoints) return false;
      return true;
    }).toList();
  }

  void _updateSelectedEvents() {
    _selectedEvents.value = _getEventsForDay(_selectedDay ?? _focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar - Compras y Puntos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
            tooltip: 'Recargar',
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Compras'),
                        selected: _showPurchases,
                        onSelected: (v) => setState(() {
                          _showPurchases = v;
                          _updateSelectedEvents();
                        }),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Puntos'),
                        selected: _showPoints,
                        onSelected: (v) => setState(() {
                          _showPoints = v;
                          _updateSelectedEvents();
                        }),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          // jump to today
                          setState(() {
                            _focusedDay = DateTime.now();
                            _selectedDay = _focusedDay;
                            _updateSelectedEvents();
                          });
                        },
                        icon: const Icon(Icons.today),
                        label: const Text('Hoy'),
                      )
                    ],
                  ),
                ),
                TableCalendar<EventItem>(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: _getEventsForDay,
                  calendarStyle: const CalendarStyle(
                    markersMaxCount: 3,
                    markerDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _updateSelectedEvents();
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ValueListenableBuilder<List<EventItem>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      if (value.isEmpty) {
                        return Center(
                          child: Text(
                            'No hay eventos para ${_selectedDay != null ? '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}' : 'esta fecha'}.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: value.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final ev = value[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: ev.kind == 'purchase' ? Colors.green : Colors.orange,
                              child: Text(ev.kind == 'purchase' ? 'P' : 'Pt'),
                            ),
                            title: Text(ev.title),
                            subtitle: Text(ev.subtitle),
                            trailing: ev.value != null ? Text((ev.value! is double) ? ev.value!.toStringAsFixed(2) : ev.value.toString()) : null,
                            onTap: () {
                              // show details dialog
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(ev.title),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tipo: ${ev.kind}'),
                                        const SizedBox(height: 6),
                                        Text('Fecha: ${ev.date.day}/${ev.date.month}/${ev.date.year}'),
                                        const SizedBox(height: 6),
                                        if (ev.value != null) Text('Valor: ${ev.value}'),
                                        const SizedBox(height: 6),
                                        Text('Detalles:'),
                                        const SizedBox(height: 6),
                                        Text(ev.subtitle),
                                        const SizedBox(height: 12),
                                        Text('Raw: ${ev.raw ?? ''}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}