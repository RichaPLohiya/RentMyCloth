import 'package:flutter/material.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.deepPurple,
              size: 30.0,
            ),
          ),
          automaticallyImplyLeading: true,
          title: const Text(
            "FAQs",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
        ),

        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            FAQTile(
              question: 'How can I register my outfits on the platform?',
              answer:
              "To register your outfits, simply Login and follow the steps to list your items with details and photos.",
            ),
            FAQTile(
              question: 'Who can browse and rent outfits on the platform?',
              answer:
              'Any registered user can browse the available outfits and proceed to rent or buy them.',
            ),
            FAQTile(
              question:
              'What types of outfits can be listed on the platform?',
              answer:
              'Users can list a wide range of outfits, including clothing, costumes, accessories, and more.',
            ),
            FAQTile(
              question: 'How does the rental process work?',
              answer:
              'Users can select the desired outfit, specify the rental period, and proceed with the payment. The outfit will be shipped or picked up according to the chosen option.',
            ),
            FAQTile(
              question:
              'Is there a security deposit for renting outfits?',
              answer:
              'Yes, renters may be required to pay a security deposit, which will be refunded upon returning the outfit in good condition.',
            ),
            FAQTile(
              question: 'Can I sell my outfits on the platform as well?',
              answer:
              'Yes, users have the option to sell their outfits in addition to renting them out.',
            ),
            FAQTile(
              question:
              'What measures are in place to ensure the quality of outfits listed on the platform?',
              answer:
              'The platform implements a review and rating system, allowing users to provide feedback on their rental experience and the condition of the outfits.',
            ),
            FAQTile(
              question:
              'How does the payment process work for renting or buying outfits?',
              answer:
              'Payments can be made securely through the platform using various payment methods, including credit/debit cards and online wallets.',
            ),
            FAQTile(
              question:
              'What happens if there are any issues with the rented outfit?',
              answer:
              'Users can contact customer support for assistance in resolving any issues with the rented outfit, such as sizing discrepancies or damages.',
            ),
            FAQTile(
              question: 'Do you have a physical store?',
              answer: "We don't have a physical store - we're only online.",
            ),
          ],
        ),
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                answer,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),

      ],
    );
  }
}

