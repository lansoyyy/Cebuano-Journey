import 'package:flutter/widgets.dart';

/// App Spacing Constants
/// Consistent spacing throughout the application
class AppSpacing {
  AppSpacing._();

  // Extra Small Spacing (4px)
  static const double xs = 4.0;

  // Small Spacing (8px)
  static const double sm = 8.0;

  // Medium Spacing (16px)
  static const double md = 16.0;

  // Large Spacing (24px)
  static const double lg = 24.0;

  // Extra Large Spacing (32px)
  static const double xl = 32.0;

  // Extra Extra Large Spacing (48px)
  static const double xxl = 48.0;

  // Extra Extra Extra Large Spacing (64px)
  static const double xxxl = 64.0;

  // ========== Edge Insets ==========

  // Extra Small Padding
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(
    horizontal: xs,
  );
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingOnlyTopXS = EdgeInsets.only(top: xs);
  static const EdgeInsets paddingOnlyBottomXS = EdgeInsets.only(bottom: xs);
  static const EdgeInsets paddingOnlyLeftXS = EdgeInsets.only(left: xs);
  static const EdgeInsets paddingOnlyRightXS = EdgeInsets.only(right: xs);

  // Small Padding
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingOnlyTopSM = EdgeInsets.only(top: sm);
  static const EdgeInsets paddingOnlyBottomSM = EdgeInsets.only(bottom: sm);
  static const EdgeInsets paddingOnlyLeftSM = EdgeInsets.only(left: sm);
  static const EdgeInsets paddingOnlyRightSM = EdgeInsets.only(right: sm);

  // Medium Padding
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingOnlyTopMD = EdgeInsets.only(top: md);
  static const EdgeInsets paddingOnlyBottomMD = EdgeInsets.only(bottom: md);
  static const EdgeInsets paddingOnlyLeftMD = EdgeInsets.only(left: md);
  static const EdgeInsets paddingOnlyRightMD = EdgeInsets.only(right: md);

  // Large Padding
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingOnlyTopLG = EdgeInsets.only(top: lg);
  static const EdgeInsets paddingOnlyBottomLG = EdgeInsets.only(bottom: lg);
  static const EdgeInsets paddingOnlyLeftLG = EdgeInsets.only(left: lg);
  static const EdgeInsets paddingOnlyRightLG = EdgeInsets.only(right: lg);

  // Extra Large Padding
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: xl,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );
  static const EdgeInsets paddingOnlyTopXL = EdgeInsets.only(top: xl);
  static const EdgeInsets paddingOnlyBottomXL = EdgeInsets.only(bottom: xl);
  static const EdgeInsets paddingOnlyLeftXL = EdgeInsets.only(left: xl);
  static const EdgeInsets paddingOnlyRightXL = EdgeInsets.only(right: xl);

  // ========== Gap/SizedBox ==========

  // Extra Small Gap
  static const SizedBox gapXS = SizedBox(width: xs, height: xs);
  static const SizedBox gapXSHorizontal = SizedBox(width: xs);
  static const SizedBox gapXSVertical = SizedBox(height: xs);

  // Small Gap
  static const SizedBox gapSM = SizedBox(width: sm, height: sm);
  static const SizedBox gapSMHorizontal = SizedBox(width: sm);
  static const SizedBox gapSMVertical = SizedBox(height: sm);

  // Medium Gap
  static const SizedBox gapMD = SizedBox(width: md, height: md);
  static const SizedBox gapMDHorizontal = SizedBox(width: md);
  static const SizedBox gapMDVertical = SizedBox(height: md);

  // Large Gap
  static const SizedBox gapLG = SizedBox(width: lg, height: lg);
  static const SizedBox gapLGHorizontal = SizedBox(width: lg);
  static const SizedBox gapLGVertical = SizedBox(height: lg);

  // Extra Large Gap
  static const SizedBox gapXL = SizedBox(width: xl, height: xl);
  static const SizedBox gapXLHorizontal = SizedBox(width: xl);
  static const SizedBox gapXLVertical = SizedBox(height: xl);

  // ========== Border Radius ==========

  // Extra Small Radius (4px)
  static const double radiusXS = 4.0;
  static BorderRadius borderRadiusXS = BorderRadius.circular(radiusXS);

  // Small Radius (8px)
  static const double radiusSM = 8.0;
  static BorderRadius borderRadiusSM = BorderRadius.circular(radiusSM);

  // Medium Radius (12px)
  static const double radiusMD = 12.0;
  static BorderRadius borderRadiusMD = BorderRadius.circular(radiusMD);

  // Large Radius (16px)
  static const double radiusLG = 16.0;
  static BorderRadius borderRadiusLG = BorderRadius.circular(radiusLG);

  // Extra Large Radius (20px)
  static const double radiusXL = 20.0;
  static BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);

  // Extra Extra Large Radius (24px)
  static const double radiusXXL = 24.0;
  static BorderRadius borderRadiusXXL = BorderRadius.circular(radiusXXL);

  // Full Radius (Circular)
  static BorderRadius borderRadiusFull = BorderRadius.circular(999);

  // ========== Screen Padding ==========

  // Safe area padding for mobile screens
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets screenPaddingLG = EdgeInsets.symmetric(
    horizontal: lg,
  );

  // ========== Card/Container Spacing ==========

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingSM = EdgeInsets.all(sm);
  static const EdgeInsets cardPaddingLG = EdgeInsets.all(lg);

  // Card margin
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
  static const EdgeInsets cardMarginSM = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: sm,
  );
  static const EdgeInsets cardMarginLG = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );

  // ========== List Item Spacing ==========

  // List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
  static const EdgeInsets listItemPaddingCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  // List item margin
  static const EdgeInsets listItemMargin = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  // ========== Button Spacing ==========

  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
  static const EdgeInsets buttonPaddingSM = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets buttonPaddingLG = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 16,
  );

  // ========== Input Field Spacing ==========

  // Input field padding
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const EdgeInsets inputPaddingSM = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );
  static const EdgeInsets inputPaddingLG = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );

  // ========== Dialog/Modal Spacing ==========

  // Dialog padding
  static const EdgeInsets dialogPadding = EdgeInsets.all(lg);
  static const EdgeInsets dialogPaddingLG = EdgeInsets.all(xl);

  // ========== Bottom Sheet Spacing ==========

  // Bottom sheet padding
  static const EdgeInsets bottomSheetPadding = EdgeInsets.all(md);
  static const EdgeInsets bottomSheetPaddingLG = EdgeInsets.all(lg);
}
