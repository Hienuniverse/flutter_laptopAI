class OrderModel {
  final String id;
  final String status;
  final double total;

  const OrderModel({
    required this.id,
    required this.status,
    required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
    status: json['status']?.toString() ?? 'pending',
    total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
  );
}
