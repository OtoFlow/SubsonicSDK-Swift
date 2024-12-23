import Foundation

public typealias ListType = Components.Schemas.ListType
public typealias Album = Components.Schemas.Album

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
}
