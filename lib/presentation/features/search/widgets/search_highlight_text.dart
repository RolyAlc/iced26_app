import 'package:flutter/material.dart';

/// Texto con resaltado de la query de búsqueda.
class SearchHighlightText extends StatelessWidget {
  const SearchHighlightText({
    super.key,
    required this.text,
    required this.query,
    this.style,
  });

  final String text;
  final String query;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final highlightColor = Theme.of(context).colorScheme.primary;
    final spans = _buildHighlightSpans(text, query, highlightColor);

    return Text.rich(TextSpan(children: spans), style: style);
  }
}

/// Divide [text] en spans, coloreando cada ocurrencia de [query].
List<TextSpan> _buildHighlightSpans(
  String text,
  String query,
  Color highlightColor,
) {
  final highlightStyle = TextStyle(color: highlightColor);
  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();

  final spans = <TextSpan>[];
  int start = 0;

  while (start < text.length) {
    final index = lowerText.indexOf(lowerQuery, start);
    if (index == -1) {
      spans.add(TextSpan(text: text.substring(start)));
      break;
    }
    if (index > start) {
      spans.add(TextSpan(text: text.substring(start, index)));
    }
    spans.add(
      TextSpan(
        text: text.substring(index, index + query.length),
        style: highlightStyle,
      ),
    );
    start = index + query.length;
  }

  return spans;
}
