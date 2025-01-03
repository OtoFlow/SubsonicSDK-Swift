import OpenAPIRuntime
import Foundation
import HTTPTypes

final class AuthenticationMiddleware {
    private let client: String
    private let device: String
    private let deviceID: String
    private let version: String

    private var username: String?
    private var token: String?
    private var salt: String?

    init(
        client: String,
        device: String,
        deviceID: String,
        version: String,
        username: String?,
        token: String?,
        salt: String?
    ) {
        self.client = client
        self.device = device
        self.deviceID = deviceID
        self.version = version
        self.username = username
        self.token = token
        self.salt = salt
    }

    func update(username: String, token: String, salt: String) {
        self.username = username
        self.token = token
        self.salt = salt
    }

    func reset() {
        self.username = nil
        self.token = nil
        self.salt = nil
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request

        if baseURL.lastPathComponent != "rest" {
            request.path = request.path.map { "/rest\($0)"}
        }

        var fields = universalQueryFields()

        var containsQuery = false
        if let path = request.path, let queryStart = path.firstIndex(of: "?") {
            let queryEnd = path.endIndex
            let query = path[path.index(after: queryStart)..<queryEnd]
            let queryItems = query.split(separator: "&").forEach { queryItem in
                let queryName = queryItem.split(separator: "=", maxSplits: 2).first!
                fields.removeValue(forKey: String(queryName))
            }
            containsQuery = true
        }

        let fieldString = fields
            .compactMap { key, value in
                value.map { "\(key)=\($0)" }
            }
            .joined(separator: "&")

        request.path?.append("\(containsQuery ? "&" : "?")\(fieldString)")

        return try await next(request, body, baseURL)
    }

    private func universalQueryFields() -> [String: String?] {
        [
            "u": username,
            "t": token,
            "s": salt,
            "v": version,
            "c": client,
            "f": "json",
        ]
    }
}
