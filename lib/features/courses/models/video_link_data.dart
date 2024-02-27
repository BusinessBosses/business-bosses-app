class VideoLinkData {
  String url;
  bool hasSubtitles;
  bool hasTranscript;

  VideoLinkData({
    this.url = '',
    this.hasSubtitles = false,
    this.hasTranscript = false,
  });

  // Constructor to initialize from map value
  VideoLinkData.fromMap(Map<String, dynamic> map)
      : url = map['url'] ?? '',
        hasSubtitles = map['hasSubtitles'] ?? false,
        hasTranscript = map['hasTranscript'] ?? false;
}
