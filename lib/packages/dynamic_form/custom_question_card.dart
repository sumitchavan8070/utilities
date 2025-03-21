import 'package:flutter/material.dart';
import 'package:utilities/theme/app_box_decoration.dart';


class CustomQuestionCard extends StatelessWidget {
  const CustomQuestionCard({
    super.key,
    this.title,
    required this.child,
    this.titleWidget,
    required this.showCardBg,
    this.index,
    this.data,
  });

  final String? title;
  final Widget child;
  final Widget? titleWidget;
  final bool showCardBg;
  final int? index;
  final String? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: showCardBg
          ? AppBoxDecoration.getBoxDecoration(color: Colors.white, showShadow: true)
          : null,
      child: Stack(
        children: [
          Padding(
            padding: showCardBg
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data ?? "-",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20)),
                const SizedBox(height: 30),
                titleWidget ??
                    Text(title ?? "-",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600, fontSize: 20)),
                const SizedBox(height: 26),
                child
              ],
            ),
          ),
        ],
      ),
    );
  }
}

