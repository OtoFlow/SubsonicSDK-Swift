import Foundation

public typealias SearchResult = Components.Schemas.SearchResult

extension SubsonicClient {
    public func search(
        _ query: String,
        artistCount: Int? = nil,
        artistOffset: Int? = nil,
        albumCount: Int? = nil,
        albumOffset: Int? = nil,
        songCount: Int? = nil,
        songOffset: Int? = nil,
        musicFolderId: Int? = nil
    ) async throws -> SearchResult {
        try await underlyingClient.search(
            query: .init(
                query: query,
                artistCount: artistCount,
                artistOffset: artistOffset,
                albumCount: albumCount,
                albumOffset: albumOffset,
                songCount: songCount,
                songOffset: songOffset,
                musicFolderId: musicFolderId
            )
        )
        .ok.body.json.subsonic_hyphen_response.value2.searchResult
    }
}