import Foundation

public typealias ListType = Components.Schemas.ListType
public typealias Album = Components.Schemas.Album
public typealias AlbumID3 = Components.Schemas.AlbumID3
public typealias Song = Components.Schemas.Song

extension SubsonicClient {
    public func getAlbumList(
        type: ListType,
        size: Int? = nil,
        offset: Int? = nil,
        fromYear: Int? = nil,
        toYear: Int? = nil,
        genre: String? = nil,
        musicFolderId: Int? = nil
    ) async throws -> [Album] {
        try await underlyingClient.getAlbumList(
            query: .init(
                _type: type,
                size: size,
                offset: offset,
                fromYear: fromYear,
                toYear: toYear,
                genre: genre,
                musicFolderId: musicFolderId
            )
        ).ok.body.json.subsonic_hyphen_response.value2.albumList.album
    }

    public func getRandomSongs() async throws -> [Song] {
        try await underlyingClient.getRandomSongs()
            .ok.body.json.subsonic_hyphen_response.value2.randomSongs.song
    }

    public func getSongsByGenre(
        _ genre: String,
        count: Int = 10,
        offset: Int = 0,
        musicFolderId: Int? = nil
    ) async throws -> [Song] {
        try await underlyingClient.getSongsByGenre(
            query: .init(
                genre: genre,
                count: count,
                offset: offset,
                musicFolderId: musicFolderId
            )
        ).ok.body.json.subsonic_hyphen_response.value2.songsByGenre.song
    }
}
