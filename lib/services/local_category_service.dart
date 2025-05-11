import 'package:flutter/services.dart' show rootBundle;
import 'package:bugbear_app/models/reflex_category.dart';

/// Lädt reflex categories aus assets per Locale und parsed im Hintergrund-Isolate.
class LocalCategoryService {
  Future<List<ReflexCategory>> loadCategories(String locale) async {
    // 1. Asset-Pfad anhand locale
    final fileName = 'assets/reflex_categories_${locale.toLowerCase()}.json';

    // 2. Rohes JSON einlesen
    final rawJson = await rootBundle.loadString(fileName);

    // 3. Parsing in Hintergrund-Isolate
    return await parseCategoriesIsolate(rawJson);
  }
}
