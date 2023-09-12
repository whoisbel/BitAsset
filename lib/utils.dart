import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

TextStyle textStyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.roboto(fontSize: size, color: color, fontWeight: fw);
}

Color _getColor(double percentage) {
  if (percentage > 0) {
    return Colors.green; // Positive percentage, display in green
  } else if (percentage < 0) {
    return Colors.red; // Negative percentage, display in red
  } else {
    return Colors
        .grey; // Zero percentage, display in grey or any other color you prefer
  }
}
