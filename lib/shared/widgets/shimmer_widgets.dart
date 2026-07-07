import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A simple rectangular shimmer placeholder box.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for the 2x2 stats grid used in Home and Admin Dashboard.
class ShimmerStatsGrid extends StatelessWidget {
  const ShimmerStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(4, (_) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        )),
      ),
    );
  }
}

/// Shimmer placeholder for a single report card (thumbnail + text lines).
class ShimmerReportCard extends StatelessWidget {
  const ShimmerReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Thumbnail placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 200, height: 12, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 120, height: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a list of report cards.
class ShimmerReportList extends StatelessWidget {
  final int itemCount;

  const ShimmerReportList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (_) => const ShimmerReportCard()),
    );
  }
}

/// Shimmer placeholder for the report detail screen.
class ShimmerDetailScreen extends StatelessWidget {
  const ShimmerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID + badge row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 80, height: 14, color: Colors.white),
                      Container(
                        width: 70,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Container(width: double.infinity, height: 20, color: Colors.white),
                  const SizedBox(height: 12),
                  // Description
                  Container(width: double.infinity, height: 14, color: Colors.white),
                  const SizedBox(height: 6),
                  Container(width: 250, height: 14, color: Colors.white),
                  const SizedBox(height: 20),
                  // Divider
                  Container(width: double.infinity, height: 1, color: Colors.white),
                  const SizedBox(height: 16),
                  // Coordinates
                  Container(width: 180, height: 14, color: Colors.white),
                  const SizedBox(height: 16),
                  // Map placeholder
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Photo gallery
                  Container(width: 120, height: 16, color: Colors.white),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: List.generate(3, (i) => Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Timeline section
            Container(width: 140, height: 20, color: Colors.white),
            const SizedBox(height: 16),
            ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 100, height: 14, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(width: 160, height: 12, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder for the admin dashboard chart area.
class ShimmerChartPlaceholder extends StatelessWidget {
  const ShimmerChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for report list items (without thumbnail, matching list card style).
class ShimmerReportListItem extends StatelessWidget {
  const ShimmerReportListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 120, height: 12, color: Colors.white),
                Container(
                  width: 70,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 250, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder list of report list items.
class ShimmerReportListItems extends StatelessWidget {
  final int itemCount;

  const ShimmerReportListItems({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(itemCount, (_) => const ShimmerReportListItem()),
      ),
    );
  }
}
