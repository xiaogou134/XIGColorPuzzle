//
//  ColorModel.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/16.
//

import UIKit
import RxDataSources

class ColorModel {
    let column: Int
    let row: Int
    
    let minXMinYColor: ColorStruct = ColorStruct()
    let minXMaxYColor: ColorStruct = ColorStruct()
    let maxXMinYColor: ColorStruct = ColorStruct()
    let maxXMaxYColor: ColorStruct = ColorStruct()
    
    lazy var colorArray: [UIColor] = {
        var array = [UIColor]()
        
        var stepArray: [Int] = [Int]()
        
        var beginLineColor = minXMinYColor.divideColorStruct(minXMaxYColor, many: row)
        var endLineColor = maxXMinYColor.divideColorStruct(maxXMaxYColor, many: row)
        
        var temp =  [ColorStruct]()
        for i in 0 ..< row {
            temp += beginLineColor[i].divideColorStruct(endLineColor[i], many: column)
        }
        array += temp.map{ $0.transToUIColor() }
        return array
    }()
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}

