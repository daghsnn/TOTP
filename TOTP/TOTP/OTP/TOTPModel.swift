//
//  TOTPModel.swift
//  TOTP
//
//  Created by Hasan Dag on 22.12.2021.
//

import Foundation

struct TOTP {
    let secret: Data
    let digits: Int
    let timeInterval: Int
    let algorithm: OTPAlgorithm
    
    public init?(secret: Data, digits: Int = AppConstants.kDIGITS, timeInterval: Int, algorithm: OTPAlgorithm) {
        self.secret = secret
        self.digits = digits
        self.timeInterval = timeInterval
        self.algorithm = algorithm
    }
    
    func generate(time: Date) -> String? {
        let secondsPast1970 = Int(floor(time.timeIntervalSince1970))
        
        return generate(secondsPast1970: secondsPast1970)
    }
    
    func generate(secondsPast1970: Int) -> String? {
        let counterValue = Int(floor(Double(secondsPast1970) / Double(timeInterval)))
        
        return GenerateOTP.shared.generateOTP(secret: secret, algorithm: algorithm, counter: UInt64(counterValue), digits: digits)
    }
        
}
