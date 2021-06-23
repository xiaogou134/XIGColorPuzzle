//
//  ViewController.swift
//  XIGColorPuzzle
//
//  Created by xiaogou134 on 2021/6/16.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ViewController: UIViewController {
    lazy var colorCollectionView: UICollectionView = {
        let view = UICollectionView(frame: view.frame, collectionViewLayout: ColorfulCollectionViewLayout(row: row, column: column))
        view.backgroundColor = .white
        return view
    }()
    
    private func createLayout(row: Int, column: Int) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/CGFloat(row)),
                                              heightDimension: .fractionalHeight(1.0/CGFloat(column)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    var row: Int = 10
    var column: Int = 4
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionOfColorData> {
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)){
                (source, collection, indexPath, item) -> UICollectionViewCell in
                let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorfulCollectionViewCell
                cell.backgroundColor = item.color
                return cell
        }
    }
    
    let disposeBag = DisposeBag()
    let selectedRelay: BehaviorRelay<IndexPath?> = BehaviorRelay(value: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.register(ColorfulCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        colorCollectionView.isScrollEnabled = false
        colorCollectionView.allowsSelection = true
        view.addSubview(colorCollectionView)
        colorCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        let model = ColorModel(row: row, column: column)
        Observable.just(model.colorArray).bind(to: colorCollectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        dataSource.canMoveItemAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        
        
        colorCollectionView.rx.itemSelected.map{[weak self] newIndexPath -> IndexPath? in
            guard let self = self else { return nil}
            guard let oldIndexPath = self.selectedRelay.value else {
                let cell = self.colorCollectionView.cellForItem(at: newIndexPath ) as! ColorfulCollectionViewCell
                cell.cellStatus = .selected
                return newIndexPath
            }
            if newIndexPath == oldIndexPath {
                let cell = self.colorCollectionView.cellForItem(at: newIndexPath ) as! ColorfulCollectionViewCell
                cell.cellStatus = .normal
            } else {
                let newCell = self.colorCollectionView.cellForItem(at: newIndexPath ) as! ColorfulCollectionViewCell
                newCell.cellStatus = .normal
                let oldCell = self.colorCollectionView.cellForItem(at: oldIndexPath ) as! ColorfulCollectionViewCell
                oldCell.cellStatus = .normal
                self.colorCollectionView.performBatchUpdates {
                    self.colorCollectionView.moveItemAtIndexPath(newIndexPath, to: oldIndexPath)
                    self.colorCollectionView.moveItemAtIndexPath(oldIndexPath, to: newIndexPath)
                }
            }
            return nil
        }.bind(to: selectedRelay).disposed(by: disposeBag)

    }
    
}
