import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firestore.instance.settings(host: "10.0.2.2:8080", sslEnabled: false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: "First page"),
        '/second': (context) => MyHomePage(title: "Second page"),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    setState(() {
      _counter++;
      Navigator.of(context).pushNamed('/second');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('requests')
          .document('0xD214cEE4caf198a72C55b169f7AbB88Cb58dCfac')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data.exists)
          return LinearProgressIndicator();
        return _buildList(
            context, UserRequestsDocument.fromSnapshot(snapshot.data));
      },
    );
  }

  Widget _buildList(BuildContext context, UserRequestsDocument urd) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          urd.requests.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, VacationRequest request) {
    // final record = VacationRequest.fromSnapshot(data)
    return Padding(
      key: ValueKey(request.address),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(request.address),
          subtitle: Text(request.status),
          isThreeLine: true,
          onTap: () => print(request),
        ),
      ),
    );
  }
}

class UserRequestsDocument {
  final String owner;
  final DocumentReference reference;
  final List<VacationRequest> requests;

  static List<VacationRequest> convert(
      List<dynamic> data, DocumentReference ref) {
    var mapped =
        data.map((x) => VacationRequest.fromMap(Map.from(x), reference: ref));
    var list = mapped.toList();
    return list;
  }

  UserRequestsDocument.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['owner'] != null),
        owner = map['owner'],
        requests = convert(map['requests'], reference);

  UserRequestsDocument.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

class VacationRequest {
  final String address;
  final List events;
  String get status => (events != null && events.length > 0)
      ? events[events.length - 1]['event']
      : 'Empty event name';
  final DocumentReference reference;

  VacationRequest.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['address'] != null),
        address = map['address'],
        events = List.from(map['events']);

  VacationRequest.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$address>";
}
