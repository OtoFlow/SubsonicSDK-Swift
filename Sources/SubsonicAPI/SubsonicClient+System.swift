import Foundation

public typealias Response = Components.Schemas.Response

extension SubsonicClient {
    public func ping() async throws -> Response {
        try await underlyingClient.ping()
            .ok.body.json.subsonic_hyphen_response
    }
}
