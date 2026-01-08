import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_event.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_state.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_card.dart';
import 'package:newwwwwwww/features/home/presentation/pages/suppliers/supplier_detail.dart';
import '../../../../../core/theme/colors.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';
import '../../../../../injection_container.dart';

class AllSuppliersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SuppliersBloc>()..add(FetchSuppliers()),
      child: AllSuppliersView(),
    );
  }
}

class AllSuppliersView extends StatefulWidget {
  @override
  State<AllSuppliersView> createState() => _AllSuppliersViewState();
}

class _AllSuppliersViewState extends State<AllSuppliersView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      _loadMoreSuppliers();
    }
  }

  Future<void> _loadMoreSuppliers() async {
    setState(() => _isLoadingMore = true);

    // محاكاة تحميل بيانات جديدة
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final paddingTop = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          const SizedBox.expand(),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Water Suppliers',
            is_returned: true,
          ),
          Positioned.fill(
            top: paddingTop + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
                right: screenWidth * .037,
                left: screenWidth * .037,
                bottom: screenHeight*.09
              ),
              child: BlocBuilder<SuppliersBloc, SuppliersState>(
                builder: (context, state) {
                  if (state is SuppliersInitial || state is SuppliersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary,),
                    );
                  } else if (state is SuppliersError) {
                    return Center(
                      child: Text(
                        'Failed to load suppliers: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is SuppliersLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: state.suppliers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SupplierDetails(
                                  supplier: state.suppliers[index],
                                ),
                              ),
                            );
                          },
                          child: BuildCardSupplier(
                            context,
                            screenHeight,
                            screenWidth,
                            state.suppliers[index],
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
