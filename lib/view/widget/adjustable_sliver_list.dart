import 'package:flutter/material.dart';

class AdjustableSliverList extends StatefulWidget {
  const AdjustableSliverList({super.key, this.initialCount = 12, required this.prefix, this.onTap});

  final int initialCount;
  final String prefix;
  final Function(BuildContext context, int index)? onTap;

  @override
  State<AdjustableSliverList> createState() => _AdjustableSliverListState();
}

class _AdjustableSliverListState extends State<AdjustableSliverList> {
  late int items;

  @override
  void initState() {
    super.initState();
    items = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(8.0),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() {
                    items--;
                  }),
                  child: Text('Remove Item'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    items++;
                  }),
                  child: Text('Add Item'),
                ),
              ],
            ),
          ),
          SliverList.builder(
            itemCount: items,
            itemBuilder: (context, index) {
              // debugPrint('Build Card $index');
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  title: Text('${widget.prefix} $index'),
                  onTap: () => widget.onTap?.call(context, index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
