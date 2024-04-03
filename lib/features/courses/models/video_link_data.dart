class VideoLinkData {
  String url;
  bool hasSubtitles;
  bool hasTranscript;
  String transcript;

  VideoLinkData({
    this.url = '',
    this.hasSubtitles = false,
    this.hasTranscript = false,
    this.transcript = ''
  });

  // Constructor to initialize from map value
  VideoLinkData.fromMap(Map<String, dynamic> map)
      : url = map['url'] ?? '',
        hasSubtitles = map['hasSubtitles'] ?? false,
        hasTranscript = map['hasTranscript'] ?? false,
        transcript = map['transcript'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'hasSubtitles': hasSubtitles,
      'hasTranscript': hasTranscript,
      'transcript': transcript,
    };
  }

  @override
  String toString() {
    return 'VideoLinkData{url: $url, hasSubtitles: $hasSubtitles, hasTranscript: $hasTranscript, transcript: $transcript}';
  }
}
