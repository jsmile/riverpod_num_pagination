import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../repositories/product_repository.dart';
import '../../utilities/ansicolor_debug.dart';
import '../product/product_page.dart';
import 'products_providers.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  int page = 1;

  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(getProductsProvider(page));
    // debugPrint(success('### productList : $productList '));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          backgroundColor: Colors.deepPurple[200],
        ),
        body: productList.when(
          data: (products) => ListView.separated(
            itemCount: products.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductPage(id: product.id),
                  ),
                ),
                child: ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.brand),
                ),
              );
            },
          ),
          error: (e, st) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                e.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomNavigationBar: (totalProducts == 0 && totalPages == 1)
            ? const SizedBox.shrink() // data 가 없으면 보이지 않게
            : Card(
                margin: EdgeInsets.zero,
                elevation: 4,
                child: NumberPaginator(
                  numberPages: totalPages, // 총 페이지 수
                  onPageChange: (int index) {
                    // 페이지 변경시 호출
                    setState(() {
                      page = index + 1; // index 는 0 부터 시작 : 선택된 페이지
                    });
                  },
                ),
              ),
      ),
    );
  }
}
