import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Tutorial',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            debugShowCheckedModeBanner: false,
            home: HomePage(title: '上拉加载更多'),
        );
    }
}

class HomePage extends StatefulWidget {
    HomePage({Key key, this.title}) : super(key: key);
    final String title;
    @override
    _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final _scrollController = ScrollController();
    // 生成数组
    final numbers = List.generate(20, (i) => i);
    bool isLoading = false;

    @override
    void initState() {
        super.initState();
        print(numbers);
        // 监听现在的位置是否下滑到了底部
        _scrollController.addListener(() {
            if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
                print('滑动到底部了...');
                // 加载更多数据
                loadMore(numbers.length);
            }
        });
    }

    loadMore(int from) async {
        if (!isLoading) setState(() => isLoading=true);
        // 延迟处理任务
        await Future.delayed(Duration(seconds: 2), () {
            setState(() {
                isLoading = false;
                numbers.addAll(List.generate(20, (i) => i + from));
            });
        });
    }

    @override
    Widget build(BuildContext context) {
        //声明不同颜色的分割线
        Widget redDivider = Divider(color: Colors.red);
        Widget blueDivider = Divider(color: Colors.blue);
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                centerTitle: true,
            ),
            body: ListView.separated(
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                    print(index);
                    // 如果下滑到底部，显示加载动画，否则正常显示 ListTile
                    if (index == numbers.length) {
                        print('本组数据加载完了...');
                        return Container(
                            padding: EdgeInsets.all(14),
                            child: Opacity(
                                opacity: isLoading ? 1.0 : 0.0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text('加载中...'),
                                        )
                                    ],
                                )
                            ),
                        );
                    } else {
                        return ListTile(
                            contentPadding: EdgeInsets.only(left: 18,right: 5),
                            title: Text('item ${numbers[index]}'),
                            leading: CircleAvatar(
                                child: Text('$index',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                                backgroundColor: Colors.blue,
                            ),
                            trailing: Icon(Icons.chevron_right),
                            onTap: (){},
                        );
                    }
                },
                //判断奇偶数进行分割线颜色处理
                separatorBuilder: (BuildContext context, int index){
                    return index % 2 == 0 ? redDivider:blueDivider;
                },
                // 记得在这里加1
                itemCount: numbers.length + 1
            ),
        );
    }
}
