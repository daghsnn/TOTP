//
//  Data+Extension.swift
//  TOTP
//
//  Created by Hasan Dag on 21.12.2021.
//

import Foundation

extension UInt64 {
    var data: Data {
        var int = self
        let intData = Data(bytes: &int, count: MemoryLayout.size(ofValue: self))
        return intData
    }
}
extension Data {
    public var bytes: Array<UInt8> {
        return Array(self)
    }

    public init(hex: String) {
        self.init(hex: hex)
    }
}

extension Array where Element == UInt8 {
    public func toHexString() -> String {
        `lazy`.reduce(into: "") {
          var s = String($1, radix: 16)
          if s.count == 1 {
            s = "0" + s
          }
          $0 += s
        }
    }

}
