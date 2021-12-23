//
//  GenerateOTP.swift
//  TOTP
//
//  Created by Hasan Dag on 21.12.2021.
//

import Foundation
import CryptoKit

final class GenerateOTP {
    static let shared = GenerateOTP()
    
    func generateOTP(secret: Data, algorithm: OTPAlgorithm, counter: UInt64, digits: Int = 6) -> String? {

        let counterMessage = counter.bigEndian.data
        
        var hmac = Data()
        
        switch algorithm {
        case .sha1:
            hmac = Data(HMAC<Insecure.SHA1>.authenticationCode(for: counterMessage, using: SymmetricKey.init(data: secret)))
        case .sha256:
            hmac = Data(HMAC<SHA256>.authenticationCode(for: counterMessage, using: SymmetricKey.init(data: secret)))
        case .sha512:
            hmac = Data(HMAC<SHA512>.authenticationCode(for: counterMessage, using: SymmetricKey.init(data: secret)))
        }
        
        let offset = Int((hmac.last ?? 0x00) & 0x0f)
        
        let truncatedHMAC = Array(hmac[offset...offset + 3])
        
        let data =  Data(truncatedHMAC)
        
        var number = UInt32(strtoul(data.bytes.toHexString(), nil, 16))
        
        number &= 0x7fffffff
        
        number = number % UInt32(pow(10, Float(digits)))

        let strNum = String(number)
        
        if strNum.count == digits {
            return strNum
        }
        
        let prefixedZeros = String(repeatElement("0", count: (digits - strNum.count)))
        return (prefixedZeros + strNum)
    }
}
