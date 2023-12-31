import 'package:equatable/equatable.dart';
import 'package:vootday_admin/cubit/brands/brands_cubit.dart';
import 'package:vootday_admin/models/models.dart';

class BrandState extends Equatable {
  final List<Brand> brands;
  final Status status;

  const BrandState({
    required this.brands,
    required this.status,
  });

  static BrandState initial() {
    return const BrandState(brands: [], status: Status.initial);
  }

  BrandState copyWith({
    List<Brand>? brands,
    Status? status,
  }) {
    return BrandState(
      brands: brands ?? this.brands,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [brands, status];
}
