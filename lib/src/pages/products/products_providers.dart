import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/product_repository.dart';
import '../../models/product.dart';
import '../../utilities/ansicolor_debug.dart';

part 'products_providers.g.dart';

@riverpod
FutureOr<List<Product>> getProducts(GetProductsRef ref, int page) async {
  Timer? timer;
  final cancelToken = CancelToken();

  debugPrint(info('### getProducts( $page ) provider : initialized'));

  ref.onDispose(() {
    debugPrint(info(
        '### getProducts( $page ): disposed, timer canceled, token canceled'));
    timer?.cancel();
    cancelToken.cancel();
  });

  ref.onCancel(() {
    debugPrint(info('### getProducts( $page ): simple canceled'));
  });

  ref.onResume(() {
    debugPrint(info('### getProducts( $page ): resumed timer canceled'));

    timer?.cancel();
  });

  final products = await ref
      .watch(productRepositoryProvider)
      .getProducts(page, cancelToken: cancelToken);

  final keepAliveLink = ref.keepAlive();

  ref.onCancel(() {
    debugPrint(info('### getProducts( $page ): canceled, timer started'));

    timer = Timer(const Duration(seconds: 10), () {
      // debugPrint(info('### getProducts( $page ): keepAliveLink closed'));
      keepAliveLink.close();
    });
  });

  return products;
}
