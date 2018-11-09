//
//  MyCollectionViewDataSource.swift
//  PalCine
//
//  Created by Oscar Santos on 10/1/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import Foundation
import UIKit

class MyCollectionViewDataSource<Cell :UICollectionViewCell,ViewModel> : NSObject, UICollectionViewDataSource {
    
    private var cellIdentifier :String!
    private var items :[ViewModel]!
    var configureCell :(Cell,ViewModel) -> ()
    
    init(cellIdentifier :String, items :[ViewModel], configureCell: @escaping (Cell,ViewModel) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.items.isEmpty{
            return 0
        }else{
            return self.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        let item = self.items[indexPath.row]
        self.configureCell(cell,item)
        cell.layoutSubviews()
        return cell
    }
    
}
