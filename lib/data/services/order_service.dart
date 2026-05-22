import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_item_model.dart';
import '../models/order_detail_model.dart';
import '../models/order_model.dart';

class OrderService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<OrderModel>> getOrders() async {
    final ordersResponse = await _client
        .from('donhang')
        .select()
        .order('ngaydat', ascending: false);

    final List<OrderModel> orders = [];

    for (final orderJson in ordersResponse) {
      final order = OrderModel.fromJson(orderJson);

      final detailsResponse = await _client
          .from('chitietdonhang')
          .select()
          .eq('madh', order.maDH as Object);

      final details = detailsResponse
          .map<OrderDetailModel>(
            (item) => OrderDetailModel.fromJson(item),
      )
          .toList();

      orders.add(
        OrderModel(
          maDH: order.maDH,
          maTK: order.maTK,
          ngayDat: order.ngayDat,
          tongTien: order.tongTien,
          phuongThucThanhToan: order.phuongThucThanhToan,
          trangThai: order.trangThai,
          riskScoreAi: order.riskScoreAi,
          chiTiet: details,
        ),
      );
    }

    return orders;
  }

  Future<OrderModel?> createOrder({
    required List<CartItemModel> cartItems,
    required double totalPrice,
    required String phuongThucThanhToan,
  }) async {
    if (cartItems.isEmpty) return null;

    final insertedOrder = await _client
        .from('donhang')
        .insert({
      'matk': 1,
      'ngaydat': DateTime.now().toIso8601String(),
      'tongtien': totalPrice,
      'phuongthucthanhtoan': phuongThucThanhToan,
      'trangthai': 'Chờ xử lý',
      'riskscore_ai': 0.0,
      'isspam': false,
      'dathanhtoan': phuongThucThanhToan == 'Chuyển khoản',
    })
        .select()
        .single();

    final maDH = insertedOrder['madh'];

    final detailRows = cartItems
        .where((item) => item.laptop != null)
        .map((item) {
      final laptop = item.laptop!;

      return {
        'madh': maDH,
        'masp': laptop.maSP,
        'soluong': item.soLuong,
        'giaban': laptop.giaBan,
      };
    })
        .toList();

    if (detailRows.isNotEmpty) {
      await _client.from('chitietdonhang').insert(detailRows);
    }

    final details = detailRows
        .map(
          (item) => OrderDetailModel.fromJson(item),
    )
        .toList();

    return OrderModel(
      maDH: maDH,
      maTK: 1,
      ngayDat: DateTime.tryParse(insertedOrder['ngaydat'].toString()) ??
          DateTime.now(),
      tongTien: totalPrice,
      phuongThucThanhToan: phuongThucThanhToan,
      trangThai: 'Chờ xử lý',
      riskScoreAi: 0.0,
      chiTiet: details,
    );
  }
}