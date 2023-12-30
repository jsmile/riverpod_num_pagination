import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

void main() {
  ansiColorDisabled = false;
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
