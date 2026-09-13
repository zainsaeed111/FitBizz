import 'package:flutter_test/flutter_test.dart';

import 'package:fitbizz_app/core/network/api_client.dart';
import 'package:fitbizz_app/features/auth/auth_state.dart';
import 'package:fitbizz_app/main.dart';

void main() {
  testWidgets('FitBizzApp smoke test', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authState = AuthState(apiClient: apiClient);

    await tester.pumpWidget(FitBizzApp(apiClient: apiClient, authState: authState));
    expect(find.text('FitBizz'), findsWidgets);
  });
}
