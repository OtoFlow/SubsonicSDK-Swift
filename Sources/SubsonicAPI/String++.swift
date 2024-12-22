import Foundation
import CommonCrypto

extension String {
    func md5() -> String {
        let data = Data(utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }

        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
