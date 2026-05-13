// void showOtpDialog(BuildContext context, String phone) {
//   final TextEditingController controller = TextEditingController();

//   int seconds = 30;
//   bool canResend = false;
//   bool isActive = true;

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           /// ⏱ Timer
//           void startTimer() {
//             Future.doWhile(() async {
//               await Future.delayed(const Duration(seconds: 1));
//               if (!isActive) return false; // 🔥 STOP HERE
//               if (seconds > 0) {
//                 setState(() => seconds--);
//                 return true;
//               } else {
//                 setState(() => canResend = true);
//                 return false;
//               }
//             });
//           }

//           /// start timer once
//           if (seconds == 30 && !canResend) {
//             startTimer();
//           }

//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),

//             title: const Text(
//               "Verification Code",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),

//             content: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "Enter the code sent to $phone",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),

//                     const SizedBox(height: 20),

//                     /// 🔢 INPUT
//                     buildOtpField(
//                       controller: controller,
//                       onChanged: (value) {
//                         setState(() {});
//                       },
//                     ),

//                     const SizedBox(height: 10),

//                     /// ⏱ TIMER / RESEND
//                     canResend
//                         ? TextButton(
//                             onPressed: () async {
//                               setState(() {
//                                 seconds = 30;
//                                 canResend = false;
//                               });
//                               startTimer();

//                               /// 🔁 resend logic later
//                               await resendOtp(phone);
//                             },
//                             child: const Text("Resend Code"),
//                           )
//                         : Text(
//                             "Resend in $seconds s",
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                   ],
//                 ),
//               ),
//             ),

//             actions: [
//               /// ❌ CANCEL
//               TextButton(
//                 onPressed: () {
//                   isActive = false; //  STOP TIMER
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Cancel"),
//               ),

//               /// ✅ VERIFY
//               ElevatedButton(
//                 onPressed: () async {
//                   isActive = false;
//                   if (controller.text.length < 6) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Enter full code")),
//                     );
//                     return;
//                   }

//                   String otp = controller.text;

//                   /// 🔐 connect Firebase later
//                   print("OTP: $otp");
//                   if (await verifyOtp(otp)) {
//                     print('succccccccesssssssssssssssssssssss');
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) {
//                           return LoginScreen();
//                         },
//                       ),
//                     );
//                   } else {
//                     print('faillllllllllllled');
//                   }
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2E7D32),
//                 ),
//                 child: const Text(
//                   "Verify",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// void showOtpConfirmationDialog({
//   required BuildContext context,
//   required String phone,
//   required VoidCallback onContinue,
// }) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               /// 📱 ICON
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withValues(alpha: 0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.sms_outlined,
//                   color: Colors.green,
//                   size: 30,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               /// 🏷️ TITLE
//               const Text(
//                 "Verification Required",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 10),

//               /// 📄 MESSAGE
//               Text(
//                 "We will send a verification code to:",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey[600]),
//               ),

//               const SizedBox(height: 8),

//               /// 📱 PHONE
//               Text(
//                 phone,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               /// 🔘 ACTIONS
//               Row(
//                 children: [
//                   /// ❌ CANCEL
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Cancel"),
//                     ),
//                   ),

//                   const SizedBox(width: 10),

//                   /// ✅ CONTINUE
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         await sendOtp(phone: phone);
//                         print('otpppppppp seeeent');
//                         Navigator.pop(context); // close dialog
//                         onContinue(); // go to OTP
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2E7D32),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         "Continue",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
