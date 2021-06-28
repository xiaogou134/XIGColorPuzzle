//
//  ColorfulCollectionViewCell.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/16.
//

import UIKit
import SnapKit

enum CellStatus {
    case normal
    case selected
    case freeze
}

class ColorfulCollectionViewCell: UICollectionViewCell {
    var cellStatus: CellStatus {
        didSet {
            switch cellStatus {
            case .normal:
                statusImageView.image = nil
            case .selected:
                statusImageView.image = UIImage.init(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
            case .freeze:
                statusImageView.image = UIImage.init(systemName: "multiply")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let statusImageView: UIImageView = UIImageView()
    
    var originLoc: IndexPath
    
    override init(frame: CGRect) {
        self.cellStatus = .normal
        self.originLoc = IndexPath()
        super.init(frame: .zero)
        
        statusImageView.contentMode = .scaleAspectFill
        addSubview(statusImageView)
        statusImageView.tintColor = .black
        statusImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
