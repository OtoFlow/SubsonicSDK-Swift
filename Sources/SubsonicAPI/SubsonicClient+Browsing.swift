import Foundation

public typealias Genre = Components.Schemas.Genre
public typealias ItemGenre = Components.Schemas.ItemGenre
public typealias Artist = Components.Schemas.Artist
public typealias ArtistID3 = Components.Schemas.ArtistID3
public typealias AlbumWithSongsID3 = Components.Schemas.AlbumWithSongsID3

extension SubsonicClient {
    public func getGenres() async throws -> [Genre] {
        try await underlyingClient.getGenres()
            .ok.body.json.subsonic_hyphen_response.value2.genres.genre
    }

    public func getArtists() async throws -> [ArtistID3] {
        let indexs = try await underlyingClient.getArtists()
            .ok.body.json.subsonic_hyphen_response.value2.artists.index
        return (indexs ?? []).flatMap { $0.artist ?? [] }
    }

    public func getArtist(id: String) async throws -> Artist {
        try await underlyingClient.getArtist(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.value2.artist
    }

    public func getAlbum(id: String) async throws -> AlbumWithSongsID3 {
        try await underlyingClient.getAlbum(query: .init(id: id))
            .ok.body.json.subsonic_hyphen_response.value2.album
    }

    public func getSimilarSongs(id: String, count: Int? = nil) async throws -> [Song] {
        try await underlyingClient.getSimilarSongs(query: .init(id: id, count: count))
            .ok.body.json.subsonic_hyphen_response.value2.similarSongs.song ?? []
    }

    public func getSimilarSongs2(id: String, count: Int? = nil) async throws -> [Song] {
        try await underlyingClient.getSimilarSongs2(query: .init(id: id, count: count))
            .ok.body.json.subsonic_hyphen_response.value2.similarSongs2.song ?? []
    }

    public func getTopSongs(artist: String, count: Int? = nil) async throws -> [Song] {
        try await underlyingClient.getTopSongs(query: .init(artist: artist, count: count))
            .ok.body.json.subsonic_hyphen_response.value2.topSongs.song ?? []
    }
}
