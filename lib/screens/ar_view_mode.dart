import 'package:augmented_reality_plugin/augmented_reality_plugin.dart';
import 'package:flutter/material.dart';


class ArViewMode extends StatefulWidget
{
  String? clickedItemImageLink;

  ArViewMode({this.clickedItemImageLink,});

  @override
  State<ArViewMode> createState() => _ArViewModeState();
}

class _ArViewModeState extends State<ArViewMode>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "AR View",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
      ),
      body: AugmentedRealityPlugin(widget.clickedItemImageLink.toString()),
    );
  }
}
