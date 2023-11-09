

import 'package:intl/intl.dart';

String get generateOrderId => 'Order_$gerFormattedCurrentDate';

String get gerFormattedCurrentDate => DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());