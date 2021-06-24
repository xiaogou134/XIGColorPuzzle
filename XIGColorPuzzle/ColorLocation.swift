//
//  ColorLocation.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/23.
//

import UIKit
import RxDataSources

class ColorLocation {
    let column: Int
    let row: Int
    var colorData: [ColorData] = []
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        
        let colorModel = ColorModel(row: row, column: column)
        let colorArray = colorModel.colorArray
        for i in 0..<colorArray.count {
            colorData += [ColorData(freeze: (arc4random() % 2 != 0), originLoc: IndexPath(row: i, section: 0), color: colorArray[i])]
        }
        colorData.randomArray()
    }
    
    
}


struct ColorData: IdentifiableType, Equatable {
    typealias Identity = String
    var freeze: Bool
    var originLoc: IndexPath
    
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
