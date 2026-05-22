class LaptopModel {
  final int? maSP;
  final String tenSP;
  final int? maHang;
  final int? maDM;
  final double giaBan;
  final int soLuongTon;
  final String? hinhAnh;
  final String? cpu;
  final String? ram;
  final String? oCung;
  final String? vga;
  final String? manHinh;
  final double? trongLuong;
  final String? moTa;
  final bool trangThai;

  // 🔥 AI SCORE
  final int aiScore;

  LaptopModel({
    this.maSP,
    required this.tenSP,
    this.maHang,
    this.maDM,
    required this.giaBan,
    this.soLuongTon = 0,
    this.hinhAnh,
    this.cpu,
    this.ram,
    this.oCung,
    this.vga,
    this.manHinh,
    this.trongLuong,
    this.moTa,
    this.trangThai = true,
    this.aiScore = 0,
  });

  int? get id => maSP;

  String get name => tenSP;

  double get price => giaBan;

  int get stock => soLuongTon;

  String get image =>
      hinhAnh ?? 'https://picsum.photos/200';

  String get brand => 'Hãng mã $maHang';

  String get category => 'Danh mục $maDM';

  String? get gpu => vga;

  String? get storage => oCung;

  String? get screen => manHinh;

  String? get description => moTa;

  factory LaptopModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final hinhAnhData =
        json['HinhAnh'] ??
            json['hinhAnh'] ??
            json['hinhanh'];

    return LaptopModel(
      maSP:
      json['MaSP'] ??
          json['maSP'] ??
          json['masp'],

      tenSP:
      json['TenSP'] ??
          json['tenSP'] ??
          json['tensp'] ??
          '',

      maHang:
      json['MaHang'] ??
          json['maHang'] ??
          json['mahang'],

      maDM:
      json['MaDM'] ??
          json['maDM'] ??
          json['madm'],

      giaBan: ((json['GiaBan'] ??
          json['giaBan'] ??
          json['giaban'] ??
          0)
      as num)
          .toDouble(),

      soLuongTon:
      json['SoLuongTon'] ??
          json['soLuongTon'] ??
          json['soluongton'] ??
          0,

      hinhAnh: hinhAnhData is List
          ? (hinhAnhData.isNotEmpty
          ? hinhAnhData.first.toString()
          : null)
          : hinhAnhData?.toString(),

      cpu: json['CPU'] ?? json['cpu'],

      ram: json['RAM'] ?? json['ram'],

      oCung:
      json['O_Cung'] ??
          json['oCung'] ??
          json['o_cung'],

      vga: json['VGA'] ?? json['vga'],

      manHinh:
      json['ManHinh'] ??
          json['manHinh'] ??
          json['manhinh'],

      trongLuong: ((json['TrongLuong'] ??
          json['trongLuong'] ??
          json['trongluong'] ??
          0)
      as num)
          .toDouble(),

      moTa:
      json['MoTa'] ??
          json['moTa'] ??
          json['mota'],

      trangThai:
      json['TrangThai'] == true ||
          json['TrangThai'] == 1 ||
          json['trangthai'] == true,

      // 🔥 AI SCORE
      aiScore:
      json['aiscore'] ??
          json['aiScore'] ??
          json['DiemTong'] ??
          json['diemtong'] ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'masp': maSP,
      'tensp': tenSP,
      'mahang': maHang,
      'madm': maDM,
      'giaban': giaBan,
      'soluongton': soLuongTon,
      'hinhanh': hinhAnh,
      'cpu': cpu,
      'ram': ram,
      'o_cung': oCung,
      'vga': vga,
      'manhinh': manHinh,
      'trongluong': trongLuong,
      'mota': moTa,
      'trangthai': trangThai,

      // 🔥 LƯU AI SCORE
      'aiscore': aiScore,
    };
  }
}