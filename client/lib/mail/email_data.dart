import 'package:faker/faker.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// Function to generate a random date for each email
String generateRandomDate() {
  final randomDate = faker.date.dateTimeBetween(
    DateTime.now().subtract(const Duration(days: 30)),
    DateTime.now(),
  );
  return DateFormat('dd/MM/yyyy').format(randomDate);
}

// Function to generate a random avatar URL
String generateRandomAvatar() {
  // Generate a random number to use for the avatar URL
  final random = Random();
  final avatarId = random.nextInt(100); // You can adjust the range of numbers

  // Return the URL for a random avatar
  return 'https://avatar.iran.liara.run/public/$avatarId';
}

List<Map<String, dynamic>> emails = [
  {
    'id': 101,
    'sender': 'Alice Johnson',
    'title': '',
    'content': 'Dear Team, this is a gentle reminder about our scheduled meeting tomorrow at 10 AM in the conference room on the 3rd floor. Please make sure to bring all necessary documents and prepare for the presentation. If you are unable to attend, kindly inform me ahead of time so we can reschedule accordingly. Looking forward to seeing everyone there!',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 102,
    'sender': 'Bob Smith',
    'title': 'Project Update',
    'content': 'Hi All, I have updated the project status in the shared document. We are making great progress, but there are still a few roadblocks that need to be addressed. Please review the document and provide your feedback by the end of the week. I appreciate all your hard work so far. Let’s keep up the momentum and ensure we meet our deadline.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 103,
    'sender': 'Charlie Davis',
    'title': 'Holiday Plans',
    'content': 'Hello everyone, as we are approaching the holiday season, I wanted to touch base about our office holiday party. We’ve decided on December 15th for the event, and it will be held at the Grand Hall. We will have food, music, and a few surprises, so please mark your calendars. I look forward to celebrating with all of you.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 104,
    'sender': 'Diana Prince',
    'title': 'Invoice Attached',
    'content': 'Greetings, I hope this email finds you well. Attached to this email is the invoice for the services rendered in the past month. Kindly review the details and let me know if you have any questions or concerns. We kindly ask for payment to be processed by the end of this week. If you need any further information, feel free to reach out.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 105,
    'sender': 'Ethan Hunt',
    'title': 'Mission Briefing',
    'content': 'Team, the mission details will be shared in the upcoming briefing session. Please ensure you’re fully prepared and bring any questions you might have. We are targeting to finish this task by Friday, and I expect all of you to be on top of your respective assignments. Time is of the essence, and we must complete this successfully without any setbacks.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 106,
    'sender': 'Fiona Carter',
    'title': 'Birthday Party',
    'content': 'Hi friends, I’m excited to invite you all to my birthday party this Friday evening at 7 PM. It will be a casual gathering with dinner, drinks, and some fun games. Please let me know if you plan to attend so we can make the necessary arrangements. I’m looking forward to celebrating with everyone and having a great time!',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 107,
    'sender': 'George Wilson',
    'title': 'Weekly Report',
    'content': 'Dear Team, as we approach the end of the week, please ensure that your weekly reports are updated and submitted by the end of the day tomorrow. It’s essential that we stay on track and review our progress in the upcoming meeting. If you face any challenges, please feel free to reach out to me for assistance.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 108,
    'sender': 'Hannah Brown',
    'title': 'Welcome Onboard',
    'content': 'Hello, welcome to our team! We are thrilled to have you join us. I’m looking forward to working together and achieving great things. We have a wonderful team here, and I’m sure you’ll fit in perfectly. Please don’t hesitate to reach out if you have any questions or need help settling in.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 109,
    'sender': 'Ian Clarke',
    'title': 'Feedback Requested',
    'content': 'Dear All, we recently conducted a survey to gather your opinions on our current processes. Your feedback is extremely valuable to us as we look to improve and streamline our operations. Please take a moment to complete the survey if you haven’t already. Your input will help shape the future of our workflow.',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
  {
    'id': 110,
    'sender': 'Jane Foster',
    'title': 'Dinner Plans',
    'content': 'Hi there, I hope you’re doing well. Let’s plan to catch up over dinner this weekend. It’s been a while since we’ve had a chance to sit down and chat, and I’m really looking forward to hearing what you’ve been up to. Let me know if Friday or Saturday works better for you!',
    'isStarred': false,
    'isRead': false,
    'isDeleted': false,
    'time': generateRandomDate(),
    'imgLink': generateRandomAvatar(),
  },
];


List<Map<String, dynamic>> drafts = [];










