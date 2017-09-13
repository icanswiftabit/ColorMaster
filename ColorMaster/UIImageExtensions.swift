//
//  UIImageExtensions.swift
//  ColorMaster
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIImage {
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let img = renderer.image { (ctx) in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.fill(rect)
        }
        return img
    }
}
