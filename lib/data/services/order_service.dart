import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order_model.dart';

class OrderService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<OrderModel>> getOrders() async {
    final response = await _client
        .from('donhang')
        .select()
        .order('ngaydat', ascending: false);

    return response
        .map<OrderModel>((item) => OrderModel.fromJson(item))
        .toList();
  }

  Future<void> createOrder({
    required int maTK,
    required double tongTien,
    String phuongThucThanhToan = 'Tiền mặt',
  }) async {
    await _client.from('donhang').insert({
      'matk': maTK,
      'ngaydat': DateTime.now().toIso8601String(),
      'tongtien': tongTien,
      'phuongthucthanhtoan': phuongThucThanhToan,
      'trangthai': 'Chờ xử lý',
      'riskscore_ai': 0.0,
    });
  }

  Future<void> updateOrderStatus({
    required int maDH,
    required String trangThai,
  }) async {
    await _client
        .from('donhang')
        .update({'trangthai': trangThai})
        .eq('madh', maDH);
  }
}