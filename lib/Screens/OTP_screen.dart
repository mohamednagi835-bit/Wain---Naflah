import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tourism_app/Helpers/Phone_auth.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _controller = TextEditingController();

  int _seconds = 30;
  Timer? _timer;
  final bool _canResend = false;
  bool _isCounting = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _seconds = 30;
      _isCounting = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        setState(() {
          _isCounting = false; // 🔥 switch to "Resend"
        });
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  // void _startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (_seconds == 0) {
  //       setState(() {
  //         _canResend = true;
  //       });
  //       timer.cancel();
  //     } else {
  //       setState(() {
  //         _seconds--;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _verify() async {
    if (_controller.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete code")),
      );
      return;
    }

    // 🔥 connect this to Firebase later
    print("OTP: ${_controller.text}");
    if (await PhoneAuth().verifyOtp(_controller.text)) {
      print('Succcccccesssssssssss');
    } else {
      print('faaaaaaaaaaaaillled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Verification",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    /// 📩 Formal message
                    const Text(
                      "To verify your account, a one-time verification code will be sent to your registered mobile number. Please enter the code below once received.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 40),

                    /// 🔢 OTP boxes
                    _buildOtpField(),

                    const SizedBox(height: 20),

                    /// ⏱ Timer
                    // TextButton(
                    //   onPressed: _canResend
                    //       ? () {
                    //           // 🔥 For now: just restart timer (UI only)
                    //           _startTimer();
                    //         }
                    //       : null,
                    //   child: Text(
                    //     _canResend ? "Resend Code" : "Resend in $_seconds s",
                    //   ),
                    // ),
                    _buildResendSection(),

                    const Spacer(),

                    /// ✅ Verify Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verify,
                        child: const Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ❌ Cancel Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔢 Custom OTP UI (6 boxes)
  Widget _buildOtpField() {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// Hidden TextField (actual input)
        Opacity(
          opacity: 0,
          child: TextField(
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            controller: _controller,
            keyboardType: TextInputType.number,
            maxLength: 6,
            autofocus: true,
            onChanged: (_) => setState(() {}),
          ),
        ),

        /// Visible Boxes
        Row(
          textDirection: TextDirection.ltr, // ✅ VERY IMPORTANT
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            String char = "";
            if (index < _controller.text.length) {
              char = _controller.text[index];
            }

            return Container(
              width: 45,
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(char, style: const TextStyle(fontSize: 20)),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: _isCounting
          ? Text(
              "Resend code in $_seconds s",
              style: const TextStyle(color: Colors.grey),
            )
          : TextButton(
              onPressed: () {
                // 🔥 here later you will call Firebase resend
                _startTimer(); // restart cycle
              },
              child: const Text("Resend Code"),
            ),
    );
  }
}
