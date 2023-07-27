import 'package:flutter/material.dart';

class ListaInfinitaTela extends StatefulWidget {
  @override
  _ListaInfinitaTelaState createState() => _ListaInfinitaTelaState();
}
//teste
class _ListaInfinitaTelaState extends State<ListaInfinitaTela> {
  List<String> _items = List.generate(50, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Infinita'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              setState(() {
                _items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item removido: $item'),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      setState(() {
                        _items.insert(index, item);
                      });
                    },
                  ),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              title: Text(item),
            ),
          );
        },
      ),
    );
  }
}
