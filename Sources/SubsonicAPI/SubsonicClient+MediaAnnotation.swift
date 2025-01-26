import Foundation

extension SubsonicClient {
    public func attachStar(
        _ star: Bool,
        id: String? = nil,
        albumId: String? = nil,
        artistId: String? = nil
    ) async throws {
        if star {
            _ = try await underlyingClient.star(
                query: .init(id: id, albumId: albumId, artistId: artistId)
            )
        } else {
            _ = try await underlyingClient.unstar(
                query: .init(id: id, albumId: albumId, artistId: artistId)
            )
        }
    }

    public func scrobble(
        id: String,
        time: Int? = nil,
        isSubmission: Bool? = nil
    ) async throws {
        _ = try await underlyingClient.scrobble(
            query: .init(id: id, time: time, submission: isSubmission)
        )
    }
}
