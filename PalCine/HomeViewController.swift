//
//  HomeViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 10/31/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var moviesByCategoryTableView: UITableView!
    
    var moviesCategoriesArr:Array<moviesCategories> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesByCategoryTableView.dataSource = self
        moviesByCategoryTableView.delegate = self
        moviesCategoriesArr = [.Popular, .Upcoming]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCategoriesArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      
        let cell =  tableView.dequeueReusableCell(withIdentifier: "movieCategoryCell", for: indexPath) as! MovieCategoryTableViewCell
        cell.setup(movieCategory: moviesCategoriesArr[indexPath.row])
        return cell
       
        
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 280
    }

    @IBAction func refreshFunc(_ sender: Any) {
        let movieManager = MovieManager.sharedInstance
        print("popular movies count: \(movieManager.popularMovies.count)")
        print("upcoming movies count: \(movieManager.upComingMovies.count)")
        
        //moviesByCategoryTableView.reloadData()
        moviesByCategoryTableView.beginUpdates()
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
