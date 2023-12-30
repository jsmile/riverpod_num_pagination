import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_num_pagination/src/pages/product/product_providers.dart';

class ProductPage extends ConsumerWidget {
  final int id;

  const ProductPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(getProductProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product Info'),
      ),
      body: product.when(
        data: (product) => ListView(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  child: Text(
                    id.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const Divider(),
            BulletedList(
              bullet: const Icon(
                Icons.check,
                color: Colors.deepPurple,
              ),
              listItems: [
                'brand: ${product.brand}',
                'price: \$${product.price}',
                'discount(%): ${product.discountPercentage}',
                'stock: ${product.stock}',
                'category: ${product.category}',
                'description: ${product.description}',
              ],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              error.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
