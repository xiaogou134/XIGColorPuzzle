//
//  ColorModel.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/16.
//

import Foundation
import UIKit
import RxDataSources

class ColorModel {
    let column: Int
    let row: Int
    
    let minXMinYColor: ColorStruct = ColorStruct()
    let minXMaxYColor: ColorStruct = ColorStruct()
    let maxXMinYColor: ColorStruct = ColorStruct()
    let maxXMaxYColor: ColorStruct = ColorStruct()
    
    lazy var colorArray: [SectionOfColorData] = {
        var array = [SectionOfColorData]()
        
        var stepArray: [Int] = [Int]()
        
        var beginLineColor = minXMinYColor.divideColorStruct(minXMaxYColor, many: row)
        var endLineColor = maxXMinYColor.divideColorStruct(maxXMaxYColor, many: row)
        
        var temp =  [ColorStruct]()
        for i in 0 ..< row {
            temp += beginLineColor[i].divideColorStruct(endLineColor[i], many: column)
        }
        array.append(SectionOfColorData(items:
                        temp.map{ ColorData(color: $0.transToUIColor()) }))
        return array
    }()
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}

struct ColorData: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        return "\(color)"
    }

    var color: UIColor
    
    static func == (lhs: ColorData, rhs: ColorData) -> Bool {
        return lhs.color == rhs.color
    }
}

struct SectionOfColorData {
    var items: [Item]
}

extension SectionOfColorData: AnimatableSectionModelType {
    var identity: String {
        return "\(items)"
    }
    
    typealias Identity = String
    
    typealias Item = ColorData
    
    init(original: SectionOfColorData, items: [Item]) {
        self = original
        self.items = items
    }
}
