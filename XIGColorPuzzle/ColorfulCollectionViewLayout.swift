//
//  ColorfulCollectionViewLayout.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/23.
//

import Foundation
import UIKit

class ColorfulCollectionViewLayout: UICollectionViewFlowLayout{
    let row: Int
    let column: Int
    
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var contentBounds = CGRect.zero
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0)  {
            if let attr = layoutAttributesForItem(at: IndexPath(item: item, section: 0)) {
                cachedAttributes.append(attr)
            }
        }

    }
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        super.init()
        
        itemSize = CGSize(width: UIScreen.main.bounds.width / CGFloat(column),
                          height: UIScreen.main.bounds.height / CGFloat(row))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }

        let currentColumn = indexPath.row % column
        let currentRow = indexPath.row / column
        
        attributes.frame = CGRect(x: itemSize.width * CGFloat(currentColumn),
                                  y: itemSize.height * CGFloat(currentRow),
                                  width: attributes.frame.width,
                                  height: attributes.frame.height)
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collection = collectionView, collection.numberOfSections > 0 else { return super.collectionViewContentSize }
        
        return CGSize(width: collection.bounds.width, height: collection.bounds.height)
    }
}
