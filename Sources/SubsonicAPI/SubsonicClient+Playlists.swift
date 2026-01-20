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

    public func createPlaylist(name: String, songIds: [String]? = nil) async throws -> PlaylistWithSongs {
        try await underlyingClient.createPlaylist(
            query: .init(
                playlistId: nil,
                name: name,
                songId: songIds
            )
        ).ok.body.json.subsonic_hyphen_response.value2.playlist
    }

    @discardableResult
    public func updatePlaylist(
        id: String,
        name: String? = nil,
        comment: String? = nil,
        public isPublic: Bool? = nil,
        songIdsToAdd: [String]? = nil,
        songIndexsToRemove: [Int]? = nil
    ) async throws -> Bool {
        try await underlyingClient.updatePlaylist(
            query: .init(
                playlistId: id,
                name: name,
                comment: comment,
                _public: isPublic,
                songIdToAdd: songIdsToAdd,
                songIndexToRemove: songIndexsToRemove
            )
        ).ok.body.json.subsonic_hyphen_response.status == .ok
    }

    @discardableResult
    public func deletePlaylist(id: String) async throws -> Bool {
        try await underlyingClient.deletePlaylist(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.status == .ok
    }
}
