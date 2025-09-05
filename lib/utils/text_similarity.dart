class TextSimilarity {
  /// Computes normalized similarity between two strings using Damerau-Levenshtein distance.
  /// Returns value in [0,1], where 1.0 is exact match.
  static double similarity(String a, String b) {
    a = a.trim().toLowerCase();
    b = b.trim().toLowerCase();
    if (a.isEmpty && b.isEmpty) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;
    final dist = _damerauLevenshtein(a, b);
    final maxLen = a.length > b.length ? a.length : b.length;
    final sim = 1.0 - (dist / maxLen);
    return sim.clamp(0.0, 1.0);
  }

  /// Returns the Damerau-Levenshtein edit distance.
  static int _damerauLevenshtein(String s, String t) {
    final m = s.length;
    final n = t.length;
    if (m == 0) return n;
    if (n == 0) return m;

    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) dp[i][0] = i;
    for (var j = 0; j <= n; j++) dp[0][j] = j;

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1, // deletion
          dp[i][j - 1] + 1, // insertion
          dp[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);

        if (i > 1 && j > 1 && s[i - 1] == t[j - 2] && s[i - 2] == t[j - 1]) {
          dp[i][j] = dp[i][j] < (dp[i - 2][j - 2] + cost)
              ? dp[i][j]
              : (dp[i - 2][j - 2] + cost); // transposition
        }
      }
    }
    return dp[m][n];
  }

  /// Basic mistake analysis: returns map with counts of common error types.
  static Map<String, dynamic> analyze(String target, String user) {
    target = target.trim().toLowerCase();
    user = user.trim().toLowerCase();
    final mistakes = <String, dynamic>{};
    int substitutions = 0, insertions = 0, deletions = 0, transpositions = 0;

    // Walk through using classic dynamic programming backtrace
    final m = target.length;
    final n = user.length;
    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) dp[i][0] = i;
    for (var j = 0; j <= n; j++) dp[0][j] = j;
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = target[i - 1] == user[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1, // deletion
          dp[i][j - 1] + 1, // insertion
          dp[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
        if (i > 1 && j > 1 && target[i - 1] == user[j - 2] && target[i - 2] == user[j - 1]) {
          dp[i][j] = dp[i][j] < (dp[i - 2][j - 2] + 1) ? dp[i][j] : (dp[i - 2][j - 2] + 1);
        }
      }
    }

    int i = m, j = n;
    while (i > 0 || j > 0) {
      if (i > 0 && j > 0 && target[i - 1] == user[j - 1]) {
        i--; j--; continue;
      }
      if (i > 1 && j > 1 && target[i - 1] == user[j - 2] && target[i - 2] == user[j - 1] && dp[i][j] == dp[i - 2][j - 2] + 1) {
        transpositions++; i -= 2; j -= 2; continue;
      }
      if (i > 0 && dp[i][j] == dp[i - 1][j] + 1) { deletions++; i--; continue; }
      if (j > 0 && dp[i][j] == dp[i][j - 1] + 1) { insertions++; j--; continue; }
      if (i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1] + 1) { substitutions++; i--; j--; continue; }
      // Fallback
      if (i > 0) i--; else if (j > 0) j--; else break;
    }

    mistakes['substitutions'] = substitutions;
    mistakes['insertions'] = insertions;
    mistakes['deletions'] = deletions;
    mistakes['transpositions'] = transpositions;
    mistakes['similarity'] = similarity(target, user);
    return mistakes;
  }
}

