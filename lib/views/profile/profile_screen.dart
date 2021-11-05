import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Morgana'),
              background: Image.network(
                  'https://i.pinimg.com/originals/56/2e/fc/562efc6231a0b03e13ea715ae1ad9f1c.png',
                  scale: 1.5,),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate((c, i) {
            return const Text('data');
          }))
        ],
      ),
    );
  }
}
