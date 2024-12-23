import Foundation

public typealias Genre = Components.Schemas.Genre

extension SubsonicClient {
    public func getGenres() async throws -> [Genre] {
        try await underlyingClient.getGenres()
            .ok.body.json.subsonic_hyphen_response.value2.genres.genre
    }
}
