//
//  testViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 9/27/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    
    
    var genresView: UIStackView!
    var isFirstGenreLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNewRowStackView() -> UIStackView{
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.alignment = .center
        rowStackView.distribution = .equalSpacing
        rowStackView.spacing = 2
        return rowStackView
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
