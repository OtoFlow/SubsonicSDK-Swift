import Foundation

extension SubsonicClient {
    public func stream(
        id: String,
        maxBitRate: Int? = nil,
        format: String? = nil,
        timeOffset: Int? = nil,
        size: (width: Int, height: Int)? = nil,
        estimateContentLength: Bool = false,
        converted: Bool = false
    ) -> URL {
        let queryItems = [
            "id": id,
            "maxBitRate": maxBitRate.map(String.init),
            "format": format,
            "timeOffset": timeOffset.map(String.init),
            "size": size.map { "\($0.width)x\($0.height)" },
            "estimateContentLength": estimateContentLength ? "true" : nil,
            "converted": converted ? "true" : nil,
        ]
            .compactMap { key, value in
                value.map { URLQueryItem(name: key, value: $0) }
            }
        return configuration.serverURL
            .appending(path: "rest/stream.view")
            .appending(queryItems: queryItems + universalQueryItems())
    }

    public func download(id: String) -> URL {
        configuration.serverURL
            .appending(path: "rest/download")
            .appending(queryItems: [
                URLQueryItem(name: "id", value: id),
            ] + universalQueryItems())
    }

    public func hls(
        id: String,
        bitRate: Int? = nil,
        size: (width: Int, height: Int)? = nil,
        audioTrack: String? = nil
    ) -> URL {
        let resolvedBitRate: String?
        if let size {
            resolvedBitRate = bitRate.map { "\($0)@\(size.width)x\(size.height)" }
        } else {
            resolvedBitRate = bitRate.map(String.init)
        }
        let queryItems = [
            "id": id,
            "bitRate": resolvedBitRate,
            "audioTrack": audioTrack,
        ]
            .compactMap { key, value in
                value.map { URLQueryItem(name: key, value: $0) }
            }
        return configuration.serverURL
            .appending(path: "rest/hls.m3u8")
            .appending(queryItems: queryItems + universalQueryItems())
    }

    public func getCaptions(id: String, format: String? = nil) -> URL {
        configuration.serverURL
            .appending(path: "rest/getCaptions")
            .appending(queryItems: [
                URLQueryItem(name: "id", value: id),
                URLQueryItem(name: "format", value: format),
            ] + universalQueryItems())
    }

    public func getCoverArt(id: String, size: Int? = nil) -> URL {
        let queryItems = [
            "id": id,
            "size": size.map(String.init),
        ].compactMap { key, value in
            value.map { URLQueryItem(name: key, value: $0) }
        }
        return configuration.serverURL
            .appending(path: "rest/getCoverArt")
            .appending(queryItems: queryItems + universalQueryItems())
    }

    public func getAvatar(username: String) -> URL {
        configuration.serverURL
            .appending(path: "rest/getAvatar")
            .appending(queryItems: [
                URLQueryItem(name: "username", value: username),
            ] + universalQueryItems())
    }

    private func universalQueryItems() -> [URLQueryItem] {
        [
            URLQueryItem(name: "u", value: username),
            URLQueryItem(name: "s", value: salt),
            URLQueryItem(name: "t", value: token),
            URLQueryItem(name: "c", value: configuration.client),
            URLQueryItem(name: "v", value: configuration.version),
        ]
    }
}
