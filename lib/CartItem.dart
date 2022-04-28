import 'package:matjer/Post.dart';

class CartItem {
  Post post;
  int count;
  DateTime time = DateTime.now();
  CartItem(this.post, this.count);
}
