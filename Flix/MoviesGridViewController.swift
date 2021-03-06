//
//  MoviesGridViewController.swift
//  Flix
//
//  Created by Vishisht  Jain on 1/25/20.
//  Copyright © 2020 Vishisht  Jain. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var movies = [[String: Any]]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let cellsPerLine: CGFloat = 2;
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine;
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
                let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                    // This will run when the network request returns
                    if let error = error {
                      print(error.localizedDescription)
                    } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        // TODO: Get the array of movies
                        // TODO: Store the movies in a property to use elsewhere
                        // TODO: Reload your table view data
                        self.movies = dataDictionary["results"] as! [[String:Any]]
                        
                        self.collectionView.reloadData()
                   }
                }
                task.resume()
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]

        let baseURL = "https://image.tmdb.org/t/p/w185"
        let pathImage = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + pathImage)
        
        cell.postView.af_setImage(withURL: posterURL!)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
