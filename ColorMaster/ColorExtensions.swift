//
//  ColorExtensions.swift
//  ColorMaster
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIColor {
    var data: Data {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var stringedColor = [red,green,blue,alpha].reduce("") { "\($0),\($1)" }
        stringedColor.remove(at: stringedColor.startIndex)
        return stringedColor.data(using: .utf8)!
    }
    
    convenience init(data: Data) {
        let stringedColor = String(data: data, encoding: .utf8)!
        let colors = stringedColor.components(separatedBy: ",")
        self.init(red: CGFloat(Double(colors[0])!),
                  green: CGFloat(Double(colors[1])!),
                  blue: CGFloat(Double(colors[2])!),
                  alpha: CGFloat(Double(colors[3])!))
    }
}
