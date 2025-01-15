import Foundation

public typealias Playlist = Components.Schemas.Playlist

extension SubsonicClient {
    public func getPlaylists(username: String? = nil) async throws -> [Playlist] {
        try await underlyingClient.getPlaylists(query: .init(username: username))
            .ok.body.json.subsonic_hyphen_response.value2.playlists.playlist
    }
}
