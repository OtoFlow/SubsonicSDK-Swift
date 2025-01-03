import Foundation

public typealias Genre = Components.Schemas.Genre
public typealias Artist = Components.Schemas.Artist
public typealias ArtistID3 = Components.Schemas.ArtistID3
public typealias AlbumWithSongsID3 = Components.Schemas.AlbumWithSongsID3

extension SubsonicClient {
    public func getGenres() async throws -> [Genre] {
        try await underlyingClient.getGenres()
            .ok.body.json.subsonic_hyphen_response.value2.genres.genre
    }

    public func getAritst(id: String) async throws -> Artist {
        try await underlyingClient.getArtist(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.value2.artist
    }

    public func getAlbum(id: String) async throws -> AlbumWithSongsID3 {
        try await underlyingClient.getAlbum(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.value2.album
    }
}
