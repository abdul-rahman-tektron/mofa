enum ApplyPassCategory {
  myself,
  someoneElse,
  group,
}

class InfoSection {
  final String title;
  final List<String> bulletPoints;

  InfoSection({required this.title, required this.bulletPoints});
}