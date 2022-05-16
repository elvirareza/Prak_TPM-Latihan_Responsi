import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latihan_responsi/data/base_network.dart';
import 'package:latihan_responsi/feature/dashboard_page.dart';
import 'package:latihan_responsi/feature/user_detail_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _box = Hive.box('search');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_box.get('username')}'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const DashboardPage()));
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: _buildData()
    );
  }

  Widget _buildData() {
    return FutureBuilder(
      future: getUser(_box.get('username')),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData) {
          debugPrint('snapshot has data');
          return _buildUser(snapshot);
        } else if(snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text('${snapshot.error}'))]
          );
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(child: CircularProgressIndicator())]
        );
      },
    );
  }

  Widget _buildUser(snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network('${snapshot.data.ava}',
              height: 200, width: 200
          ),
        ),
        const SizedBox(height: 20),
        Text('${snapshot.data.name}', style: const TextStyle(fontSize: 30)),
        Text('${snapshot.data.username}', style: const TextStyle(fontSize: 20, color: Colors.grey)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _box.put('action', 'following');
                _box.put('show', 'Following');
                debugPrint('following');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UserDetailPage())
                );
              },
              child: SizedBox(
                width: 80,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${snapshot.data.following}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 5),
                    const Text('following')
                  ],
                ),
              ),
            ),
            const SizedBox(width: 30),
            InkWell(
              onTap: () {
                _box.put('action', 'followers');
                _box.put('show', 'Followers');
                debugPrint('followers');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UserDetailPage())
                );
              },
              child: SizedBox(
                width: 80,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${snapshot.data.followers}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 5),
                    const Text('followers')
                  ],
                ),
              ),
            ),
            const SizedBox(width: 30),
            InkWell(
              onTap: () {
                _box.put('show', 'Repository');
                debugPrint('repository');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const UserDetailPage())
                );
              },
              child: SizedBox(
                width: 80,
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${snapshot.data.repos}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 5),
                    const Text('repository')
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
