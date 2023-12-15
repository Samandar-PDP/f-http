import 'dart:ui';

import 'package:f_http_a3/api_service.dart';
import 'package:f_http_a3/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _apiService = ApiService();

  bool _isAppbarVisible = true;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    listenListScroll();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() { });
    super.dispose();
  }

  void listenListScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isAppbarVisible = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isAppbarVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AnimatedOpacity(
          opacity: _isAppbarVisible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          child: AppBar(
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text("Shaftoli Qoqi Uz"),
          ),
        ),
      ) ,
      // body: CustomScrollView(
      //   slivers: <Widget>[
      //    const SliverAppBar(
      //       pinned: true,
      //       floating: true,
      //       expandedHeight: 400.0,
      //       flexibleSpace: const FlexibleSpaceBar(
      //         title: Text('Shaftoli Qoqi Uz',style: TextStyle(color: Colors.blueGrey),),
      //         background: FlutterLogo(),
      //       ),
      //      backgroundColor: Colors.red,
      //     ),
      //     SliverList(
      //       delegate: SliverChildBuilderDelegate(
      //             (BuildContext context, int index) {
      //           return Container(
      //             color: index.isOdd ? Colors.white : Colors.black12,
      //             height: 100.0,
      //             child: Center(
      //               child:
      //               Text('$index', textScaler: const TextScaler.linear(5)),
      //             ),
      //           );
      //         },
      //         childCount: 20,
      //       ),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FutureBuilder(
          future: _apiService.getAllProducts(),
          builder: (context, snapshot) {
            if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
              return GridView.builder(
                controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 350,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8
              ),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                return _buildItem(snapshot.data?[index]);
              });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
  Widget _buildItem(Product? product) {
    return GestureDetector(
      onLongPress: () => _deleteProduct(product?.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.indigo.shade200
        ),
        child: Column(
          children: [
            Image.network(product?.image ?? "",fit: BoxFit.cover, height: 250, width: double.infinity,),
            const SizedBox(height: 20),
            Expanded(child: Text(product?.title ?? "No data"))
          ],
        ),
      ),
    );
  }
  void _deleteProduct(int? id) {
    _apiService.deleteProduct(id).then((value) {
      if(value) {
        setState(() {

        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
      }
    });
  }
}
