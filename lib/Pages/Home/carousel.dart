import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  CarouselState createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  final String buildingPath = 'assets/Profile.png';

  final List<String> hostels = [
    "Aqua", "Opal", "Agate", "Garnet", "Amber", "Topaz", "Coral", "Beryl"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            String title = hostels[index % hostels.length];
            return BuildingListTile(
              imagePath: buildingPath,
              title: title,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class BuildingListTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final int index;

  const BuildingListTile({
    required this.imagePath,
    required this.title,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: index.isEven
            ? [
                Text(title, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Image.asset(imagePath),
              ]
            : [
                Image.asset(imagePath),
                const SizedBox(height: 10),
                Text(title, textAlign: TextAlign.center),
              ],
      ),
    );
  }
}
