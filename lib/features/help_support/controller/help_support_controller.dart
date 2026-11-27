import 'package:get/get.dart';

class HelpSupportController extends GetxController {
  final faqs = [
    {
      'question': 'How to upload files?',
      'answer': 'Tap on the "+" button on the home screen to upload photos or videos.'
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, we use end-to-end encryption to keep your data safe and private.'
    },
    {
      'question': 'How to upgrade to Premium?',
      'answer': 'Go to the Profile section and tap on Subscription to see premium plans.'
    },
  ].obs;
}
