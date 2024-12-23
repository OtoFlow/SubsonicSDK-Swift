import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public final class SubsonicClient {
    public struct Configuration {
        public let serverURL: URL
        public let client: String
        public let version: String
        public let deviceName: String
        public let deviceID: String

        public init(
            serverURL: URL,
            client: String,
            version: String,
            deviceName: String,
            deviceID: String
        ) {
            self.serverURL = serverURL
            self.client = client
            self.version = version
            self.deviceName = deviceName
            self.deviceID = deviceID
        }
    }

    public let configuration: Configuration

    public private(set) var username: String?
    public private(set) var salt: String?
    public private(set) var token: String?

    let underlyingClient: any APIProtocol

    private(set) var authenticationMiddleware: AuthenticationMiddleware?

    init(configuration: Configuration, underlyingClient: any APIProtocol) {
        self.configuration = configuration
        self.underlyingClient = underlyingClient
    }

    public convenience init(
        configuration: Configuration,
        username: String? = nil,
        salt: String? = nil,
        token: String? = nil
    ) {
        let authenticationMiddleware = AuthenticationMiddleware(
            client: configuration.client,
            device: configuration.deviceName,
            deviceID: configuration.deviceID,
            version: configuration.version,
            username: username,
            token: token,
            salt: salt
        )

        self.init(
            configuration: configuration,
            underlyingClient: Client(
                serverURL: configuration.serverURL,
                configuration: .init(
                    dateTranscoder: ISO8601DateTranscoder(
                        options: [.withTimeZone]
                    )
                ),
                transport: URLSessionTransport(),
                middlewares: [
                    authenticationMiddleware
                ]
            )
        )

        self.username = username
        self.salt = salt
        self.token = token
        self.authenticationMiddleware = authenticationMiddleware
    }
}

public typealias Artist = Components.Schemas.Artist

extension SubsonicClient {
    public func signIn(username: String, password: String) async throws -> AuthenticationResponse {
        let salt = String(UUID().uuidString.prefix(8)).lowercased()
        let token = (password + salt).md5()

        authenticationMiddleware?.reset()

        let response = try await underlyingClient.signIn(
            query: .init(
                u: username,
                t: token,
                s: salt
            )
        ).ok.body.json.subsonic_hyphen_response

        self.username = username
        self.salt = salt
        self.token = token

        authenticationMiddleware?.update(
            username: username,
            token: token,
            salt: salt
        )

        return .init(
            salt: salt,
            token: token,
            version: response.version,
            serverName: response._type,
            serverVersion: response.serverVersion,
            isOpenSubsonic: response.openSubsonic == true
        )
    }
}
