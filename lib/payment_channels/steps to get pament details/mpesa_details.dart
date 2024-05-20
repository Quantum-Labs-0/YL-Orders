import 'package:flutter/material.dart';

class GetMpesaDetails extends StatefulWidget {
  const GetMpesaDetails({super.key});

  @override
  State<GetMpesaDetails> createState() => _GetMpesaDetailsState();
}

class _GetMpesaDetailsState extends State<GetMpesaDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Paybill Online Activation'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    'In order for you to accept online payments with your paybill follow the steps below or contact Safaricom through M-PESABusiness@Safaricom.co.ke for assistance on how to use the M-Pesa Daraja platform to "Go Live".',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '1. Get an M-Pesa paybill.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '2. Create an M-Pesa portal.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '3. Log in to your developer portal.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '4. Click Go Live.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '5. Enter the following values:',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '5.1. Verification Type: Short Code.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '5.2. Organization Short Code: [Your Paybill Number].',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '5.3. Organization Name: [As submitted in your paybill application].',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '5.4. M-Pesa Username: [Either the Business Admin or Business Manager as set the the M-Pesa portal].',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    '6. Enter the assistant user username, select desired API products and Go Live.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    'After approval, a passkey will be sent to your email address used in the M-Pesa Daraja platform. This will be used to initiate online payment requests via STK PUSH.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Container(
                  child: const Text(
                    'If you do not recieve the passkey in your email then send an email to M-PESABusiness@Safaricom.co.ke requesting the passkey.',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
