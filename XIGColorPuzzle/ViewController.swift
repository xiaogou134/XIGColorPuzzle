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

enum Result: Int {
    case right = 1
    case wrong = -1
    case begin = 0
}

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
    
    let resultJudgement: BehaviorRelay<Result> = BehaviorRelay<Result>(value: .begin)
    
    var row: Int = 2
    var column: Int = 2
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionOfColorData> {
        return RxCollectionViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)){ [weak self]
                (source, collection, indexPath, item) -> UICollectionViewCell in
                let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorfulCollectionViewCell
                cell.backgroundColor = item.color
            cell.originLoc = item.originLoc
            if item.freeze == true {
                cell.cellStatus = .freeze
                self?.resultJudgement.accept(.right)
            } else {
                cell.cellStatus = .normal
                if cell.originLoc == indexPath {
                    self?.resultJudgement.accept(.right)
                }
            }
            
            return cell
        }
    }
    
    let disposeBag = DisposeBag()
    let selectedRelay: BehaviorRelay<IndexPath?> = BehaviorRelay(value: nil)
    var colorModelRelay: BehaviorRelay<[ColorData]?> = BehaviorRelay(value: nil)
    var total: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.register(ColorfulCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        colorCollectionView.allowsSelection = true
        view.addSubview(colorCollectionView)
        colorCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        colorModelRelay.accept(ColorLocation(row: row, column: column).colorData)
        colorModelRelay
            .map{ [SectionOfColorData(items: $0!)] }
            .bind(to: colorCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        colorCollectionView.rx.itemSelected.map{[weak self] newIndexPath -> IndexPath? in
            guard let self = self else { return nil}
            let cell = self.colorCollectionView.cellForItem(at: newIndexPath ) as! ColorfulCollectionViewCell
            if cell.cellStatus == .freeze {
                return nil
            }
            guard let oldIndexPath = self.selectedRelay.value else {
                cell.cellStatus = .selected
                return newIndexPath
            }
            if newIndexPath == oldIndexPath {
                cell.cellStatus = .normal
            } else {
                cell.cellStatus = .normal
                let oldCell = self.colorCollectionView.cellForItem(at: oldIndexPath ) as! ColorfulCollectionViewCell
                oldCell.cellStatus = .normal
                
                if cell.originLoc == oldIndexPath {
                    self.resultJudgement.accept(.right)
                }
                if cell.originLoc == newIndexPath {
                    self.resultJudgement.accept(.wrong)
                }
                if oldCell.originLoc == newIndexPath{
                    self.resultJudgement.accept(.right)
                }
                if oldCell.originLoc == oldIndexPath {
                    self.resultJudgement.accept(.wrong)
                }
                self.colorCollectionView.performBatchUpdates {
                    self.colorCollectionView.moveItemAtIndexPath(newIndexPath, to: oldIndexPath)
                    self.colorCollectionView.moveItemAtIndexPath(oldIndexPath, to: newIndexPath)
                }
            }
            return nil
        }.bind(to: selectedRelay).disposed(by: disposeBag)
        
        
        resultJudgement.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.total += result.rawValue
            if self.total == self.row * self.column - 1{
                let alert = UIAlertController(title: "🎉🎉Congratulation🎉🎉", message: "You have finished it", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: {[weak self] _ in
                    guard let self = self else { return }
                    self.row += 1
                    self.column += 1
                    self.total = 0
                    self.colorModelRelay.accept(ColorLocation(row: self.row, column: self.column).colorData)
                    self.colorCollectionView.setCollectionViewLayout(ColorfulCollectionViewLayout(row: self.row, column: self.column), animated: true)
                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            print(self.total)
        }).disposed(by: disposeBag)
    }
    
}
