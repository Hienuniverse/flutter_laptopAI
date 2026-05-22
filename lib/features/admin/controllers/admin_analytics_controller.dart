import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChartStat {
  final String name;
  final int count;

  const ChartStat({required this.name, required this.count});
}

class ProductBenchmark {
  final int? maSP;
  final String tenSP;
  final double giaBan;
  final int soLuongTon;
  final int reviewCount;
  final double avgRating;
  final double aiScore;
  final String insight;

  const ProductBenchmark({
    required this.maSP,
    required this.tenSP,
    required this.giaBan,
    required this.soLuongTon,
    required this.reviewCount,
    required this.avgRating,
    required this.aiScore,
    required this.insight,
  });
}

class AdminAnalyticsController extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  bool isLoading = false;
  String? errorMessage;

  int totalProducts = 0;
  int totalOrders = 0;
  int totalReviews = 0;
  int lowStockProducts = 0;

  double totalRevenue = 0;
  double averageRating = 0;
  double averageProductPrice = 0;

  final List<ChartStat> categoryStats = [];
  final List<ChartStat> brandStats = [];
  final List<ProductBenchmark> benchmarks = [];

  AdminAnalyticsController() {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final productsData = await _client.from('sanpham').select('*');
      final ordersData = await _client.from('donhang').select('*');

      List reviewsData = [];

      try {
        reviewsData = await _client.from('danhgia').select('*');
      } catch (_) {
        reviewsData = [];
      }

      final products = List<Map>.from(productsData as List);
      final orders = List<Map>.from(ordersData as List);
      final reviews = List<Map>.from(reviewsData);

      totalProducts = products.length;
      totalOrders = orders.length;
      totalReviews = reviews.length;

      totalRevenue = orders.fold<double>(
        0,
        (sum, item) => sum + _toDouble(item['tongtien'] ?? item['tongTien']),
      );

      lowStockProducts = products.where((item) {
        final stock = _toInt(item['soluongton'] ?? item['soLuongTon']) ?? 0;
        return stock <= 5;
      }).length;

      averageProductPrice = products.isEmpty
          ? 0
          : products.fold<double>(
                  0,
                  (sum, item) =>
                      sum + _toDouble(item['giaban'] ?? item['giaBan']),
                ) /
                products.length;

      averageRating = reviews.isEmpty
          ? 0
          : reviews.fold<double>(
                  0,
                  (sum, item) =>
                      sum + (_toInt(item['sosao'] ?? item['rating']) ?? 0),
                ) /
                reviews.length;

      await _loadCategoryStats(products);
      await _loadBrandStats(products);
      _buildBenchmark(products, reviews);
    } catch (e) {
      errorMessage = 'Không thể tải thống kê: $e';
      debugPrint('ANALYTICS ERROR: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCategoryStats(List<Map> products) async {
    final counter = <int, int>{};

    for (final product in products) {
      final maDM = _toInt(product['madm'] ?? product['maDM']);
      if (maDM != null) {
        counter[maDM] = (counter[maDM] ?? 0) + 1;
      }
    }

    categoryStats.clear();

    for (final entry in counter.entries) {
      String name = 'Danh mục ${entry.key}';

      try {
        final category = await _client
            .from('danhmuc')
            .select('tendm')
            .eq('madm', entry.key)
            .maybeSingle();

        if (category != null && category['tendm'] != null) {
          name = category['tendm'].toString();
        }
      } catch (_) {}

      categoryStats.add(ChartStat(name: name, count: entry.value));
    }

    categoryStats.sort((a, b) => b.count.compareTo(a.count));
  }

  Future<void> _loadBrandStats(List<Map> products) async {
    final counter = <int, int>{};

    for (final product in products) {
      final maHang = _toInt(product['mahang'] ?? product['maHang']);
      if (maHang != null) {
        counter[maHang] = (counter[maHang] ?? 0) + 1;
      }
    }

    brandStats.clear();

    for (final entry in counter.entries) {
      String name = 'Hãng ${entry.key}';

      try {
        final brand = await _client
            .from('hang')
            .select('tenhang')
            .eq('mahang', entry.key)
            .maybeSingle();

        if (brand != null && brand['tenhang'] != null) {
          name = brand['tenhang'].toString();
        }
      } catch (_) {}

      brandStats.add(ChartStat(name: name, count: entry.value));
    }

    brandStats.sort((a, b) => b.count.compareTo(a.count));
  }

  void _buildBenchmark(List<Map> products, List<Map> reviews) {
    benchmarks.clear();

    final reviewMap = <int, List<int>>{};

    for (final review in reviews) {
      final maSP = _toInt(review['masp'] ?? review['maSP']);
      final rating = _toInt(review['sosao'] ?? review['rating']) ?? 0;

      if (maSP != null) {
        reviewMap.putIfAbsent(maSP, () => []);
        reviewMap[maSP]!.add(rating);
      }
    }

    final List<double> prices = products
        .map((item) => _toDouble(item['giaban'] ?? item['giaBan']))
        .where((price) => price > 0)
        .toList();

    final double minPrice = prices.isEmpty
        ? 0.0
        : prices.reduce((a, b) => a < b ? a : b);
    final double maxPrice = prices.isEmpty
        ? 1.0
        : prices.reduce((a, b) => a > b ? a : b);

    for (final product in products) {
      final maSP = _toInt(product['masp'] ?? product['maSP']);
      final tenSP = (product['tensp'] ?? product['tenSP'] ?? 'Laptop')
          .toString();
      final giaBan = _toDouble(product['giaban'] ?? product['giaBan']);
      final stock = _toInt(product['soluongton'] ?? product['soLuongTon']) ?? 0;

      final ratings = maSP == null ? <int>[] : (reviewMap[maSP] ?? <int>[]);
      final reviewCount = ratings.length;
      final avgRating = ratings.isEmpty
          ? 0.0
          : ratings.fold<double>(0, (sum, item) => sum + item) / ratings.length;

      final priceScore = _calculatePriceScore(
        price: giaBan,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      final ratingScore = avgRating <= 0 ? 50 : (avgRating / 5) * 100;
      final reviewScore = reviewCount >= 20 ? 100 : reviewCount * 5;
      final stockScore = stock <= 0
          ? 20
          : stock <= 5
          ? 60
          : 100;

      final aiScore =
          (priceScore * 0.35) +
          (ratingScore * 0.35) +
          (reviewScore * 0.15) +
          (stockScore * 0.15);

      benchmarks.add(
        ProductBenchmark(
          maSP: maSP,
          tenSP: tenSP,
          giaBan: giaBan,
          soLuongTon: stock,
          reviewCount: reviewCount,
          avgRating: avgRating,
          aiScore: aiScore.clamp(0, 100),
          insight: _buildInsight(
            score: aiScore,
            priceScore: priceScore,
            rating: avgRating,
            reviewCount: reviewCount,
            stock: stock,
          ),
        ),
      );
    }

    benchmarks.sort((a, b) => b.aiScore.compareTo(a.aiScore));
  }

  double _calculatePriceScore({
    required double price,
    required double minPrice,
    required double maxPrice,
  }) {
    if (price <= 0 || maxPrice <= minPrice) {
      return 50;
    }

    final normalized = 1 - ((price - minPrice) / (maxPrice - minPrice));
    return (normalized * 100).clamp(0, 100);
  }

  String _buildInsight({
    required double score,
    required double priceScore,
    required double rating,
    required int reviewCount,
    required int stock,
  }) {
    if (score >= 80) {
      return 'Điểm AI cao, sản phẩm có tiềm năng đề xuất tốt.';
    }

    if (priceScore >= 75 && stock > 5) {
      return 'Giá cạnh tranh, tồn kho ổn, phù hợp đẩy bán.';
    }

    if (rating >= 4) {
      return 'Đánh giá tốt, nên ưu tiên hiển thị trong gợi ý.';
    }

    if (reviewCount == 0) {
      return 'Chưa có nhiều dữ liệu đánh giá, AI score chỉ mang tính tham khảo.';
    }

    if (stock <= 5) {
      return 'Tồn kho thấp, cần cân nhắc nhập thêm trước khi đẩy đề xuất.';
    }

    return 'Hiệu năng tổng quan ở mức trung bình.';
  }

  String formatCurrency(double value) {
    return '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ';
  }
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is double) {
    return value;
  }

  if (value is int) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}
