import 'package:finshare/util/colors.dart';
import 'package:flutter/material.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({Key? key}) : super(key: key);

  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.background,
        title: Text(
          "All transactions",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list,
              ))
        ],
      ),
      body: ListView.builder(
          itemCount: 20,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 48.0),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
              child: SizedBox(
                height: screenHeight * 0.09,
                child: Card(
                  elevation: .2,
                  shadowColor: AppColors.shadow,
                  margin: EdgeInsets.only(top: 2.5),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            child: Text(
                              "A",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.black,
                          ),
                        ),
                        Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Apple Store",
                                      style:
                                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900, color: AppColors.text),
                                    ),
                                    Text(
                                      "\$17.34",
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Chicago, IL",
                                          style: TextStyle(
                                              fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey),
                                        ),
                                        Text(
                                          "Yesterday",
                                          style: TextStyle(
                                              fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "2%",
                                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey.shade400,
                              size: 22,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
