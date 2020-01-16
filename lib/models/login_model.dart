class LoginModel {
  /// 直接将网络请求的 Future 对象包装成 Stream 返回
  /// Stream.fromFuture 等构造方法。更多细节参考官方文档
  /// 因为是 demo 所以用 Future.delayed 模拟请求过程
   Stream<int> login(dynamic data) => Stream.fromFuture(
     Future.delayed(Duration(seconds: 2), () {
          if (data["username"] == "lzyprime" && data["password"] == "123")
            return 0;
          return -1;
        }),
   );
}
