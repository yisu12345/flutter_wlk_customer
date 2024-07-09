import 'package:flutter/material.dart';
import 'package:flutter_wlk_customer/utils/pull_refresh_widget/pull_refresh_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomerReshPage extends StatefulWidget {
  const CustomerReshPage({super.key});

  @override
  State<CustomerReshPage> createState() => _CustomerReshPageState();
}

class _CustomerReshPageState extends State<CustomerReshPage> {
  RefreshController controller = RefreshController(initialRefresh: false);

  int indexCount = 20;
  List<int> arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,6, 7, 8, 9, 10, 11];

  onRefresh() {
    arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    setState(() {});
    controller.refreshCompleted();
  }

  onLoading() async{
    print('object');
    await Future.delayed(const Duration(milliseconds: 1000));
    arr.add(11);
    if(mounted)
      setState(() {

      });
    controller.loadComplete();

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('resh'),
      ),
      body: PullRefreshListWidget(
        controller: controller,
        enablePullUp: true,
        onRefresh: () => onRefresh(),
        onLoading: () => onLoading(),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: arr.length,
          // controller: controller,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('index + $index'),
            );
          },
        ),
      ),
    );
  }
}
