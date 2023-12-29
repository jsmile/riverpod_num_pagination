import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/ansicolor_debug.dart';
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
    debugPrint(error('### productList : $productList '));

    return SafeArea(
      child: Scaffold(
        body: productList.when(
          data: (products) => ListView.separated(
            itemCount: products.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final product = products[index];

              return ListTile(
                title: Text(product.title),
                subtitle: Text(product.brand),
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
      ),
    );
  }
}
