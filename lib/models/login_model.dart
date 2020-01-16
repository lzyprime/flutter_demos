class LoginModel {
   Stream<int> login(dynamic data) => Stream.fromFuture(
     Future.delayed(Duration(seconds: 2), () {
          if (data["username"] == "lzyprime" && data["password"] == "123")
            return 0;
          return -1;
        }),
   );
}
