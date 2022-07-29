import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/constants.dart';

ClipPath customHeader(BuildContext context, int completedTask, int totalTask) {
  String _formattedDate = DateFormat('EEE, MMMM d').format(DateTime.now());

  return ClipPath(
    clipper: CustomHeadCliper(),
    child: Container(
      height: 260,
      width: 100,
      decoration: BoxDecoration(
        gradient: kGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    child: Icon(
                      Icons.menu,
                      size: 35,
                      color: kTextColor2,
                    ),
                    onTap: null,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 80, bottom: 15),
              height: 60,
              width: 180,
              decoration: BoxDecoration(
                gradient: kGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF2A2A72).withOpacity(0.8),
                    blurRadius: 5,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _formattedDate,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: kTextColor2),
                ),
              ),
            ),
            Text(
              "My Task",
              style: TextStyle(
                color: kTextColor2,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "$completedTask of $totalTask",
              style: TextStyle(
                color: kTextColor2,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class CustomHeadCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
