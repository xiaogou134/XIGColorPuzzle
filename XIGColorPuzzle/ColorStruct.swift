//
//  ColorStruct.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/22.
//

import UIKit

struct ColorStruct {
    var red: Int
    var green: Int
    var blue: Int
    
    init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init() {
        self.init(red: Int(arc4random_uniform(255)), green: Int(arc4random_uniform(255)), blue: Int(arc4random_uniform(255)))
    }
    
    func divideColorStruct(_ other: ColorStruct, many: Int) -> [ColorStruct] {
        let redArray: [Int] = divide(self.red, other.red, many: many)
        let greenArray: [Int] = divide(self.green, other.green, many: many)
        let blueArray: [Int] = divide(self.blue, other.blue, many: many)
        
        var array: [ColorStruct] = []
        for i in 0..<many {
            array.append(ColorStruct(red: redArray[i], green: greenArray[i], blue: blueArray[i]))
        }
        return array
    }
    
    func transToUIColor() -> UIColor {
        return UIColor(intRed: red, intGreen: green, intBlue: blue, alpha: 1.0)
    }
    
    func divide(_ ln: Int, _ rn: Int, many: Int) -> [Int] {
        var nums: [Int] = Array(repeating: 0, count: many)
        let steps = (rn - ln) / many
        
        for i in 0..<nums.count {
            nums[i] = ln + steps * i
        }
        return nums
    }
    
}
