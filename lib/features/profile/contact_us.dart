import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/custom_text.dart';
import '../../core/utils/dimensions.dart';
import '../timeline/timeline_feed.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String name = timeLineController.userFullName.value;
      // String email = timeLineController.userEmail.value;
      String number = timeLineController.userPhoneNumber.value;
      String message = timeLineController.userMessage.value;
      bool isClickAble = name.isNotEmpty &&
          // email.isNotEmpty &&
          number.isNotEmpty &&
          message.isNotEmpty;

      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(children: const [
                      CustomText(
                        text: 'Contact Us',
                        weight: FontWeight.w500,
                        size: 16,
                      ),
                    ]).paddingSymmetric(horizontal: 20),
                    const SizedBox(height: 20),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.chevron_left_outlined),
                              SizedBox(width: 5),
                              CustomText(
                                text: 'Back to home',
                                size: 14,
                              )
                            ]).paddingSymmetric(horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SingleChildScrollView(
                      child: Column(children: [
                        CustomLabelField(
                          label: 'Full Name',
                          hint: 'Enter full name here',
                          onChange: (val) {
                            timeLineController.userFullName(val);
                          },
                        ),
                        // CustomLabelField(
                        //   label: 'Email Address',
                        //   hint: 'Enter email here',
                        // ),
                        CustomLabelField(
                          label: 'Phone Number',
                          hint: 'Enter phone number here',
                          onChange: (val) {
                            timeLineController.userPhoneNumber(val);
                          },
                        ),
                        CustomLabelField(
                          label: 'message',
                          maxLine: 4,
                          hint: 'Type message here',
                          onChange: (val) {
                            timeLineController.userMessage(val);
                          },
                        ),
                      ]),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: InkWell(
                        onTap: isClickAble
                            ? () {
                                timeLineController.sendMail(context);
                              }
                            : null,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isClickAble
                                ? AppColors.primaryColor
                                : Colors.grey.shade200,
                          ),
                          child: CustomText(
                            text: 'Send',
                            color: isClickAble
                                ? Colors.white
                                : Colors.black.withOpacity(0.6),
                            weight: FontWeight.w500,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      );
    });
  }
}

class CustomLabelField extends StatelessWidget {
  final String label;
  final String hint;
  final int? maxLine;
  final Function(String? val)? onChange;
  const CustomLabelField({
    super.key,
    this.maxLine,
    this.onChange,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(
        text: label,
        size: 15,
        weight: FontWeight.w500,
      ),
      const SizedBox(height: 5),
      TextFormField(
        onChanged: onChange,
        maxLines: maxLine,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.5),
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ]).paddingSymmetric(horizontal: 20);
  }
}
