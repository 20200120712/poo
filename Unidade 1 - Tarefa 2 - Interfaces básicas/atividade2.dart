import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text("Se liga"),
      ),
      
      body: Center(
        child: Column(
          children:[
            Text(
              "Daniel",
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Leônidas",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Medeiros",
              style: TextStyle(fontSize: 36.0),
            ),
            SizedBox(height: 16.0), // Espaço entre o último Text e a imagem
            FadeInImage(
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage('https://picsum.photos/200/300/'),
              fadeInDuration: Duration(milliseconds: 500),
              fadeInCurve: Curves.easeIn,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 56.0,
        color: Colors.blue,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      "Botao1",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      "Botao2",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Botao3",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  runApp(app);
}
