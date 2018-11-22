//
//  MyTabBar.swift
//  PalCine
//
//  Created by Oscar Santos on 11/22/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class MyTabBar: UITabBar {

    private var cachedSafeAreaInsets = UIEdgeInsets.zero
    
    override var safeAreaInsets: UIEdgeInsets {
        let insets = super.safeAreaInsets
        
        if insets.bottom < bounds.height {
            cachedSafeAreaInsets = insets
        }
        
        return cachedSafeAreaInsets
    }

}
