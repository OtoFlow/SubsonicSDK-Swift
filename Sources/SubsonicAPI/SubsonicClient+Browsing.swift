import Foundation

public typealias Genre = Components.Schemas.Genre
public typealias AlbumWithSongsID3 = Components.Schemas.AlbumWithSongsID3

extension SubsonicClient {
    public func getGenres() async throws -> [Genre] {
        try await underlyingClient.getGenres()
            .ok.body.json.subsonic_hyphen_response.value2.genres.genre
    }

    public func getAlbum(id: String) async throws -> AlbumWithSongsID3 {
        try await underlyingClient.getAlbum(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.value2.album
    }
}
