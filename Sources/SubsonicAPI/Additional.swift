//
//  Additional.swift
//  SubsonicAPI
//
//  Created by Xianhe Meng on 2025/8/3.
//

import Foundation

struct AdditionalWrapper<Base> {

    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol AdditionalCompatible { }

extension AdditionalCompatible {

    var additive: AdditionalWrapper<Self> {
        get { AdditionalWrapper(self) }
        set { }
    }
}

struct ChainingWrapper<Base> {

    let base: Base

    var value: Base { base }

    init(_ base: Base) {
        self.base = base
    }
}

protocol ChainingCompatible { }

extension ChainingCompatible {

    var chained: ChainingWrapper<Self> {
        ChainingWrapper(self)
    }
}

extension AdditionalWrapper where Base == URL {

    enum DirectoryHint : Sendable {
        case isDirectory
        case notDirectory
        case inferFromPath
    }

    func appending<S>(
        path: S,
        directoryHint: DirectoryHint = .inferFromPath
    ) -> URL where S: StringProtocol
    {
        base.appending(path: path, directoryHint: directoryHint)
    }

    func appending(queryItems: [URLQueryItem]) -> URL {
        base._appending(queryItems: queryItems)
    }
}

extension URL: AdditionalCompatible { }
extension URL: ChainingCompatible { }

extension URL {

    fileprivate func appending<S>(
        path: S,
        directoryHint: AdditionalWrapper<URL>.DirectoryHint = .inferFromPath
    ) -> URL where S: StringProtocol
    {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            let directoryHint: URL.DirectoryHint = switch directoryHint {
            case .isDirectory: .isDirectory
            case .notDirectory: .notDirectory
            case .inferFromPath: .inferFromPath
            }
            return appending(
                path: path,
                directoryHint: directoryHint
            )
        } else {
            var url = self
            let isDirectory: Bool = switch directoryHint {
            case .isDirectory: true
            case .notDirectory: false
            case .inferFromPath: path.hasSuffix("/")
            }
            url.appendPathComponent(String(path), isDirectory: isDirectory)
            return url
        }
    }

    fileprivate func _appending(queryItems: [URLQueryItem]) -> URL {
        if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            return appending(queryItems: queryItems)
        } else {
            guard var components = URLComponents(
                url: self,
                resolvingAgainstBaseURL: true
            ) else { return self }

            var existingQueryItems = components.queryItems ?? []
            existingQueryItems.append(contentsOf: queryItems)
            components.queryItems = existingQueryItems

            return components.url ?? self
        }
    }
}


extension ChainingWrapper where Base == URL {

    func appending<S>(
        path: S,
        directoryHint: AdditionalWrapper<URL>.DirectoryHint = .inferFromPath
    ) -> ChainingWrapper<Base> where S: StringProtocol
    {
        base.appending(path: path, directoryHint: directoryHint).chained
    }

    func appending(queryItems: [URLQueryItem]) -> ChainingWrapper<Base> {
        base._appending(queryItems: queryItems).chained
    }
}
