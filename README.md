A customizable radial menu widget for Flutter that expands items in various directions and quadrants.

## Getting started

```bash
flutter pub add radial_menu_pro
```

```dart
import 'package:radial_menu_pro/radial_menu_pro.dart';
```

## Features

*   **Multi-Directional Deployment:** Expand menu items in 9 different directions, including specific quadrants (`firstQuadrant`, etc.), cardinal directions (`top`, `down`, `left`, `right`), or a full 360° circle (`whole`).
*   **Customizable Animations:** Smooth transition control with adjustable duration (`milliseconds`) and an optional rotation effect (`rotateItems`) for items as they deploy.
*   **Flexible Styling:** Fully customize the toggle button’s appearance with separate widgets and background colors for both `activated` and `deactivated` states.
*   **Dynamic Sizing:** Control the menu's reach by adjusting the `distance` (offset from the center) and the `radialMenuRadius`.
*   **Smart Layout:** Use the `alignment` property to position your menu anywhere within its allocated `areaWidth` and `areaHeight`.
*   **Zero Dependencies:** Built entirely with native Flutter widgets and `dart:math` for a lightweight footprint.

## Usage

```dart
RadialMenu(
  radialMenuButtonActivated: Icon(Icons.home),
  radialMenuButtonDeactivated: Icon(Icons.close),
  radialMenuItems: [
    RadIcon(
      icon: Icons.build,
      onTap: (){},
    ),
    RadIcon(
      icon: Icons.build_circle,
      onTap: (){},
    ),
  ],
  direction: RadialDirection.left,
),
```

Helper custom widget:

```dart
class RadIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const RadIcon({
    required this.icon,
    this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: Colors.brown,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
```