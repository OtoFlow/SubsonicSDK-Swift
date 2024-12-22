import Foundation

public struct AuthenticationResponse {
    public let salt: String
    public let token: String
    public let version: String
    public let serverName: String?
    public let serverVersion: String?
    public let isOpenSubsonic: Bool
}
