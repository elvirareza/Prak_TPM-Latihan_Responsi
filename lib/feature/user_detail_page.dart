import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latihan_responsi/data/base_network.dart';

import 'dashboard_page.dart';
import 'user_page.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _box = Hive.box('search');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${_box.get('show')}'),
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
        body: Container(
          child: (_box.get('show') != 'Repository')
              ? _searchFollow()
              : _searchRepository(),
        ));
  }

  Widget _searchFollow() {
    return FutureBuilder(
      future: getFollow(_box.get('username'), _box.get('action')),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          return _buildListView(snapshot);
        } else if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Center(child: Text('${snapshot.error}'))]);
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Center(child: CircularProgressIndicator())]);
      },
    );
  }

  Widget _searchRepository() {
    return FutureBuilder(
      future: getRepository(_box.get('username')),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('snapshot has data');
          return _buildRepository(snapshot);
        } else if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Center(child: Text('${snapshot.error}'))]);
        }
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Center(child: CircularProgressIndicator())]);
      },
    );
  }

  Widget _buildListView(snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            _box.put('username', snapshot.data[index].username);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) => const UserPage()));
          },
          child: Card(
              margin: const EdgeInsets.all(15),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network('${snapshot.data[index].ava}'),
                ),
                title: Text('${snapshot.data[index].username}'),
                subtitle: Text('${snapshot.data[index].type}'),
              )),
        );
      },
    );
  }

  Widget _buildRepository(snapshot) {
    return ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              margin: const EdgeInsets.all(15),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent)),
              child: ListTile(
                title: Text('${snapshot.data[index].name}'),
              ));
        });
  }
}
