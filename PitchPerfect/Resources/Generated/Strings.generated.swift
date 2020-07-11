// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Home {
    /// Error trying to start audio engine
    internal static let audioEngineError = L10n.tr("Localizable", "Home.AudioEngineError")
    /// Error trying to create audio file
    internal static let audioFileError = L10n.tr("Localizable", "Home.AudioFileError")
    /// Error
    internal static let genericError = L10n.tr("Localizable", "Home.GenericError")
    /// Recording in progress
    internal static let recordingInProgress = L10n.tr("Localizable", "Home.RecordingInProgress")
    /// Tap to record
    internal static let tapToRecord = L10n.tr("Localizable", "Home.TapToRecord")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
