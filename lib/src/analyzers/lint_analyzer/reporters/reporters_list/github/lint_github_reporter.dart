import 'dart:io';

import '../../../../../reporters/models/github_reporter.dart';
import '../../../../models/file_report.dart';
import '../../../../models/severity.dart';

class LintGitHubReporter extends GitHubReporter {
  const LintGitHubReporter(IOSink output) : super(output);

  @override
  Future<void> report(Iterable<FileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    for (final analysisRecord in records) {
      for (final antiPattern in analysisRecord.antiPatternCases) {
        output.writeln(GitHubReporter.commands.warning(
          antiPattern.message,
          sourceSpan: antiPattern.location,
        ));
      }

      for (final issue in analysisRecord.issues) {
        output.writeln(
          issue.severity == Severity.error
              ? GitHubReporter.commands
                  .error(issue.message, sourceSpan: issue.location)
              : GitHubReporter.commands
                  .warning(issue.message, sourceSpan: issue.location),
        );
      }
    }
  }
}