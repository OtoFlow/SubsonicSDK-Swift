import Foundation
import OpenAPIRuntime

public struct ISO8601DownsamplingDateTranscoder: DateTranscoder, @unchecked Sendable {

    private let lock: NSLock

    private let locked_formatter: ISO8601DateFormatter

    private static var defaultFormatOptions: ISO8601DateFormatter.Options = [
        .withInternetDateTime, .withFractionalSeconds
    ]

    private var candidateFormatOptions: ISO8601DateFormatter.Options {
        [
            .withFullDate, .withTime, .withTimeZone,
            .withDashSeparatorInDate, .withColonSeparatorInTime, .withColonSeparatorInTimeZone,
        ]
    }

    public init() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = Self.defaultFormatOptions
        lock = NSLock()
        lock.name = "org.subsonic.runtime.ISO8601DateTranscoder"
        locked_formatter = formatter
    }

    public func encode(_ date: Date) throws -> String {
        lock.lock()
        defer { lock.unlock() }
        return locked_formatter.string(from: date)
    }

    public func decode(_ dateString: String) throws -> Date {
        lock.lock()
        defer { lock.unlock() }
        if let date = locked_formatter.date(from: dateString) { return date }
        locked_formatter.formatOptions = candidateFormatOptions
        if let date = locked_formatter.date(from: dateString) {
            locked_formatter.formatOptions = Self.defaultFormatOptions
            return date
        }
        throw DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "Expected date string to be ISO8601-formatted.")
        )
    }
}
