class MySettingsItem {
  final bool isTitle;
  final String label;
  final bool hasSwitch;
  bool switchValue;
  String routeName;

  MySettingsItem({
    this.isTitle = true,
    this.label = '',
    this.hasSwitch = false,
    this.switchValue = true,
    this.routeName = '',
  });
}
