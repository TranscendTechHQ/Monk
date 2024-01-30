import 'package:flutter/material.dart';

class InfiniteScrollingListView extends StatefulWidget {
  const InfiniteScrollingListView({super.key});

  @override
  _InfiniteScrollingListViewState createState() =>
      _InfiniteScrollingListViewState();
}

class _InfiniteScrollingListViewState extends State<InfiniteScrollingListView> {
  final ScrollController _scrollController = ScrollController();
  final List<int> _dataList = List.generate(20, (index) => index);

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulating a delay to fetch more data
      await Future.delayed(const Duration(seconds: 2));

      List<int> newDataList =
          List.generate(20, (index) => index + _dataList.length);

      setState(() {
        _dataList.addAll(newDataList);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _dataList.length + 1,
      itemBuilder: (context, index) {
        if (index < _dataList.length) {
          return ListTile(
            title: Text('Item ${_dataList[index]}'),
          );
        } else {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container();
        }
      },
    );
  }
}
