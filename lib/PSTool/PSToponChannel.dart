enum PSToponChannel {
  unity,
  tiktok,
  mintegral,
  facebook,
  moloco,
  organic,
  other;

  static final _word = RegExp(r'[a-z0-9]+');

  static PSToponChannel? fromAdjust({String? network, String? trackerName}) {
    final reportedNetwork = network?.trim();
    final source = reportedNetwork != null && reportedNetwork.isNotEmpty
        ? reportedNetwork
        : trackerName?.trim();
    if (source == null || source.isEmpty) return null;

    final name = _word.firstMatch(source.toLowerCase())?.group(0);
    return switch (name) {
      'unity' || 'unityads' => unity,
      'tiktok' || 'tiktokads' => tiktok,
      'mintegral' => mintegral,
      'facebook' || 'facebookads' || 'instagram' => facebook,
      'moloco' => moloco,
      'organic' => organic,
      _ => other,
    };
  }
}
