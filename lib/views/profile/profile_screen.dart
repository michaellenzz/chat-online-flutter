import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final name;
  // ignore: prefer_typing_uninitialized_variables
  final photo;
  // ignore: prefer_typing_uninitialized_variables
  final phone;
  // ignore: prefer_typing_uninitialized_variables
  final recado;
  const ProfileScreen(this.phone, this.photo, this.recado, this.name,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: width * 0.8,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(name),
              background: ExtendedImage.network(
                photo,
                fit: BoxFit.fitWidth,
                cache: true,
                handleLoadingProgress: true,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((c, i) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Telefone:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7cc6fe)),
                  ),
                  Text(
                    phone,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Recado',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7cc6fe)),
                  ),
                  Text(
                    recado,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0a1045)),
                  ),
                  SizedBox(
                    height: height * 0.8,
                  )
                ],
              ),
            );
          }, childCount: 1))
        ],
      ),
    );
  }
}
