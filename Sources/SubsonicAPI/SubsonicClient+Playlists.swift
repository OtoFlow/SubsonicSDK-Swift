import Foundation

public typealias Playlist = Components.Schemas.Playlist
public typealias PlaylistWithSongs = Components.Schemas.PlaylistWithSongs

extension SubsonicClient {
    public func getPlaylists(username: String? = nil) async throws -> [Playlist] {
        try await underlyingClient.getPlaylists(query: .init(username: username))
            .ok.body.json.subsonic_hyphen_response.value2.playlists.playlist
    }

    public func getPlaylist(id: String) async throws -> PlaylistWithSongs {
        try await underlyingClient.getPlaylist(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.value2.playlist
    }
}
