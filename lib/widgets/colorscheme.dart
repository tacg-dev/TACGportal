import 'package:flutter/material.dart';

class ColorSchemeDisplay extends StatelessWidget {
  final ColorScheme colorScheme;

  const ColorSchemeDisplay({Key? key, required this.colorScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ColorScheme Visualizer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Color Scheme Overview',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _colorBox('Primary', colorScheme.primary, colorScheme.onPrimary),
                _colorBox('On Primary', colorScheme.onPrimary, colorScheme.primary),
                _colorBox('Primary Container', colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
                _colorBox('On Primary Container', colorScheme.onPrimaryContainer, colorScheme.primaryContainer),
                _colorBox('Secondary', colorScheme.secondary, colorScheme.onSecondary),
                _colorBox('On Secondary', colorScheme.onSecondary, colorScheme.secondary),
                _colorBox('Secondary Container', colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
                _colorBox('On Secondary Container', colorScheme.onSecondaryContainer, colorScheme.secondaryContainer),
                _colorBox('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
                _colorBox('On Tertiary', colorScheme.onTertiary, colorScheme.tertiary),
                _colorBox('Tertiary Container', colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
                _colorBox('On Tertiary Container', colorScheme.onTertiaryContainer, colorScheme.tertiaryContainer),
                _colorBox('Error', colorScheme.error, colorScheme.onError),
                _colorBox('On Error', colorScheme.onError, colorScheme.error),
                _colorBox('Surface', colorScheme.surface, colorScheme.onSurface),
                _colorBox('On Surface', colorScheme.onSurface, colorScheme.surface),
                _colorBox('Surface Variant', colorScheme.surfaceVariant, colorScheme.onSurfaceVariant),
                _colorBox('On Surface Variant', colorScheme.onSurfaceVariant, colorScheme.surfaceVariant),
                _colorBox('Background', colorScheme.background, colorScheme.onBackground),
                _colorBox('On Background', colorScheme.onBackground, colorScheme.background),
                _colorBox('Outline', colorScheme.outline, Colors.white),
                _colorBox('Inverse Surface', colorScheme.inverseSurface, colorScheme.onInverseSurface),
                _colorBox('On Inverse Surface', colorScheme.onInverseSurface, colorScheme.inverseSurface),
                _colorBox('Shadow', colorScheme.shadow, Colors.white),
                _colorBox('Surface Tint', colorScheme.surfaceTint, Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorBox(String label, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      color: color,
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
