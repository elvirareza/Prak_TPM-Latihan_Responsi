import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latihan_responsi/data/base_network.dart';
import 'package:latihan_responsi/feature/user_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _box = Hive.box('search');
  bool check = false;

  final TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInput(),
          _searchUser(),
          if(_box.get('searchUsername') != null)
            _buildSuggestion(_box),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        controller: _username,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          setState(() {
            check = true;
          });
        },
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter a username',
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildSuggestion(_box) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Suggestion'),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              _box.put('username', _box.get('searchUsername'));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const UserPage()));
            },
            child: Card(
                margin: const EdgeInsets.all(15),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
                child: ListTile(
                  title: Text('${_box.get('searchName')}'),
                  subtitle: Text('${_box.get('searchUsername')}'),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network('${_box.get('searchAva')}'),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _searchUser() {
    if(check == true) {
      return FutureBuilder(
        future: getUser(_username.value.text),
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData) {
            debugPrint('snapshot has data');
            _box.put('searchUsername', _username.value.text);
            return _buildUser(snapshot);
          } else if(snapshot.hasError) {
            debugPrint('Error: ${snapshot.error}');
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
    return const SizedBox();
  }

  Widget _buildUser(snapshot) {
    _box.put('searchName', snapshot.data.name);
    _box.put('searchAva', snapshot.data.ava);
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              _box.put('username', _box.get('searchUsername'));
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const UserPage()));
            },
            child: Card(
                margin: const EdgeInsets.all(15),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
                child: ListTile(
                  title: Text('${snapshot.data.name}'),
                  subtitle: Text('${snapshot.data.username}'),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network('${snapshot.data.ava}'),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}
