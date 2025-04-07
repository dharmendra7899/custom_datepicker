/*


class SocketController extends GetxController {
  static SocketController get instances => Get.isRegistered()
      ? Get.find()
      : Get.put(SocketController(), permanent: true);
  final SocketService _socketService = SocketService();
  final RxBool isConnected = false.obs;
  final RxList<ExpenseHistory> expenses = <ExpenseHistory>[].obs;
  late Rx<LocationDataModel> locationDataModel = LocationDataModel().obs;

  Future<void> connectToServer(String? authToken) async {
    print("This is Called Socket Connected");
    if (authToken!.isEmpty) {
      print("Token is empty. Unable to connect.");
      return;
    }
    try {
      await _socketService.connect(authToken);
      _socketService.on('connect', (_) {
        isConnected.value = true;
        _socketService.on('returnCurrentlocation', (data) {
          _handleUpdateLocation(data);
        });
        _socketService.on('returnExpenseHistory', (data) {
          _handleUpdate(data);
        });
      });

      _socketService.on('disconnect', (_) {
        print("Disconnected from WebSocket.");
        isConnected.value = false;
      });

      _socketService.on('connect_error', (error) {
        print("WebSocket connection error: $error");
      });
    } catch (e) {
      print("Error connecting to WebSocket: $e");
    }
  }

  void _handleUpdate(dynamic data) {
    if (data is Map<String, dynamic> && data['status'] == true) {
      final List<dynamic> dataList = data['data'] ?? [];
      expenses.value = dataList.map((e) => ExpenseHistory.fromJson(e)).toList();
      update();
    }
  }

  void _handleUpdateLocation(dynamic data) {
    if (data is Map<String, dynamic> && data['status'] == true) {
      locationDataModel.value = LocationDataModel.fromJson(data);
      update();
    } else {
      print("Invalid data or status is false.");
    }
  }

  void sendRequest(String operation, String groupId) {
    _socketService.emit('getExpenseHistory', {"id": groupId});
  }

  void sendLocationRequest(String operation, Map<String, dynamic> map) async {
    print("SendLocationRequest Map:::: $map");
    if (!_socketService.socket.connected) {
      var info = await PrefUtils.getUserInfo();
      await connectToServer(info.token);
    }
    _socketService.emit('gecurrentlocation', map);
  }

  void disconnect() {
    _socketService.disconnect();
    isConnected.value = false;
  }

  double updateSplitAmount(int index) {
    if (expenses[index].paidBy?.isPrimary ?? false) {
      return ((double.tryParse(expenses[index].totalAmount.toString()) ?? 0) -
          (double.tryParse(expenses[index].amountToPay.toString()) ?? 0));
    }
    return double.tryParse(expenses[index].amountToPay.toString()) ?? 0;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
*/
