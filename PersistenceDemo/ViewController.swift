//
//  ViewController.swift
//  PersistenceDemo
//
//  Created by Harley Trung on 4/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var movies: [Movie]?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Option 1
        let documentsPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print("documentsPaths: ", documentsPaths)

        // Option 2:
//        let documentDirectoryURL = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .AllDomainsMask, appropriateForURL: nil, create: true)
//        print("documentDirectoryURL", documentDirectoryURL)
        fetchMovies("NSUserDefaults")
    }

    func saveData(method: String) {
        switch method {
        case "NSUserDefaults":
            DataManager.saveToNSUserDefaults(movies)
        case "File":
            DataManager.saveToFile(movies)
        default:
            print("ERROR: unknown saveData \(method)")
        }
    }

    func loadData(method: String) {
        switch method {
        case "NSUserDefaults":
            movies = DataManager.loadFromNSUserDefaults()
        case "File":
            movies = DataManager.loadFromFile()
        default:
            print("ERROR: unknown loadData \(method)")
        }
    }

    func fetchMovies(method: String) {
        let clientId = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")!
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 2)
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil else {
//                print("Error: ", error?.description)
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadData(method)
                    self.tableView.reloadData()
                }
                return
            }

            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            let moviesArray = json["results"] as? [NSDictionary]
            self.movies = []
            for m in moviesArray! {
                let movie = Movie()
                movie.title = m.valueForKey("original_title") as! String
                movie.overview = m.valueForKey("overview") as! String
                movie.posterPath = m.valueForKey("poster_path") as! String
                self.movies?.append(movie)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.saveData(method)
                self.tableView.reloadData()
            }
        }

        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        if let movies = movies {
            cell.movie = movies[indexPath.row]
        }
        return cell
    }
}
