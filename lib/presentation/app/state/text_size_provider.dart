import 'package:iced26/core/constants/text_size_preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'text_size_provider.g.dart';

@riverpod
class TextSizeNotifier extends _$TextSizeNotifier {
  static const _kKey = 'text_size';

  @override
  Future<TextSizePreference> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _parse(prefs.getString(_kKey));
  }

  Future<void> setPreference(TextSizePreference pref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, pref.name);
    state = AsyncData(pref);
  }

  static TextSizePreference _parse(String? value) {
    return TextSizePreference.values.firstWhere(
      (p) => p.name == value,
      orElse: () => TextSizePreference.medium,
    );
  }
}
