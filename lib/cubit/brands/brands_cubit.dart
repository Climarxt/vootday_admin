import 'package:bloc/bloc.dart';
import 'package:vootday_admin/cubit/brands/brands_state.dart';
import 'package:vootday_admin/repositories/brand/brand_repository.dart';

enum Status { initial, loading, loaded, error }

class BrandCubit extends Cubit<BrandState> {
  final BrandRepository _brandRepository;

  BrandCubit({required BrandRepository brandRepository})
      : _brandRepository = brandRepository,
        super(BrandState.initial());

  void fetchBrands() async {
    try {
      emit(state.copyWith(status: Status.loading));

      final brands = await _brandRepository.getAllBrands();

      emit(state.copyWith(brands: brands, status: Status.loaded));
    } catch (err) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
