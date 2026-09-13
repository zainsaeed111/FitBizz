import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';

class SyncEngine {
  final AppDatabase database;
  final ApiClient apiClient;

  SyncEngine({required this.database, required this.apiClient});

  Future<bool> isOnline() async {
    final connectivity = await Connectivity().checkConnectivity();
    return !connectivity.contains(ConnectivityResult.none);
  }

  Future<int> syncPendingMutations() async {
    if (!await isOnline()) return 0;

    final pending = await database.select(database.offlineQueue).get();
    if (pending.isEmpty) return 0;

    int syncedCount = 0;
    for (final item in pending) {
      try {
        final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
        final response = await apiClient.post('/sync/push', [
          {
            'operation': item.operationType,
            'entity': item.targetEntity,
            'payload': payload,
          }
        ]);

        if (response.statusCode == 200) {
          await (database.delete(database.offlineQueue)
                ..where((tbl) => tbl.id.equals(item.id)))
              .go();
          syncedCount++;
        }
      } catch (e) {
        // Retain in queue for next sync retry
      }
    }
    return syncedCount;
  }
}
