class BenchmarkModel {
  final String laptopId;
  final double cpuScore;
  final double gpuScore;
  final double ramScore;
  final double totalScore;

  const BenchmarkModel({
    required this.laptopId,
    required this.cpuScore,
    required this.gpuScore,
    required this.ramScore,
    required this.totalScore,
  });

  factory BenchmarkModel.fromJson(Map<String, dynamic> json) => BenchmarkModel(
    laptopId: json['laptopId']?.toString() ?? '',
    cpuScore: double.tryParse(json['cpuScore']?.toString() ?? '0') ?? 0,
    gpuScore: double.tryParse(json['gpuScore']?.toString() ?? '0') ?? 0,
    ramScore: double.tryParse(json['ramScore']?.toString() ?? '0') ?? 0,
    totalScore: double.tryParse(json['totalScore']?.toString() ?? '0') ?? 0,
  );
}
