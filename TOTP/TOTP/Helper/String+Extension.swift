//
//  String+Extension.swift
//  TOTP
//
//  Created by Hasan Dag on 21.12.2021.
//

import Foundation

extension String {

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    subscript(i: Int) -> String {
            return String(self[index(startIndex, offsetBy: i)])
        }
}
