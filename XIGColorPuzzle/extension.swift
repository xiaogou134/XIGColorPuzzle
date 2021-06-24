//
//  extension.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/22.
//

import UIKit

extension UIColor {
    convenience init(intRed: Int, intGreen: Int, intBlue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(intRed) / 255.0, green: CGFloat(intGreen) / 255.0, blue: CGFloat(intBlue) / 255.0, alpha: alpha)
    }
}

extension Array{
    mutating func randomArray() {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        self = list
    }
}
