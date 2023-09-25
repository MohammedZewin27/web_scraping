import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Article> articles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse(
        'https://www.amazon.sa/s?rh=n%3A16966419031&fs=true&ref=lp_16966419031_sar');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('h2 > a > span')
        .map((e) => e.innerHtml.trim())
        .toList();
    final image = html
        .querySelectorAll('span > a > div > img')
        .map((e) => e.attributes['src']!)
        .toList();


    print('count :${titles.length}');
    setState(() {
      articles = List.generate(
        titles.length,
        (index) => Article(url: '', title: titles[index], urlImage:image[index]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('$index -${articles[index].title}'),
            leading: Image.network(articles[index].urlImage,width: 50,fit: BoxFit.fitHeight,),
          );

      },),
    );
  }
}

class Article {
  final String url;
  final String title;
  final String urlImage;

  Article({required this.url, required this.title, required this.urlImage});
}
