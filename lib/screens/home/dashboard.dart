import 'package:flutter/material.dart';
import 'package:reach_me/utils/constants.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = "dashboard_screen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Hello Tay',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor)),
                            SizedBox(height: 7),
                            Flexible(
                              child: Text(
                                  'Good morning, remember to save today 💰',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: const Color(0xFF002B42)),
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/profile.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: size.width,
                    height: 180,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Account Balance',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF85B7FF)),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'N500,000.00',
                          style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFD5F6EE),
                        maximumSize: const Size(150, double.infinity),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        children: const [
                          Image(
                              image: AssetImage('assets/icons/add-money.png'),
                              width: 31),
                          SizedBox(width: 10),
                          Text(
                            'Add money',
                            style: TextStyle(
                                fontSize: 17, color: Color(0xFF5E5E5E)),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF1D1),
                        maximumSize: const Size(150, double.infinity),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        children: const [
                          Image(
                              image: AssetImage('assets/icons/withdraw.png'),
                              width: 31),
                          SizedBox(width: 10),
                          Text(
                            'Withdraw',
                            style: TextStyle(
                                fontSize: 17, color: Color(0xFF5E5E5E)),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 30),
                  const Text('Get your money working for you',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor)),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        fixedSize: Size(size.width, double.infinity),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                                color: Color(0xFFC9C9C9), width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF5F9FF)),
                              child: const Image(
                                  image: AssetImage('assets/icons/wallet.png'),
                                  width: 31),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Save for an emergency',
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: AppColors.textColor, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        fixedSize: Size(size.width, double.infinity),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                                color: Color(0xFFC9C9C9), width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF5F9FF)),
                              child: const Image(
                                  image: AssetImage('assets/icons/invest.png'),
                                  width: 31),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Invest your money',
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: AppColors.textColor, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Ways to earn more money',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor)),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        fixedSize: Size(size.width, double.infinity),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                                color: Color(0xFFC9C9C9), width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF5F9FF)),
                              child: const Image(
                                  image: AssetImage('assets/icons/invite.png'),
                                  width: 31),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Invite your friends and get a bonus',
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 15, color: AppColors.textColor),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: AppColors.textColor, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
