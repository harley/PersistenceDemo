//
//  ViewController.swift
//  PersistenceDemo
//
//  Created by Harley Trung on 4/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var movies: [NSDictionary]?
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
        fetchMovies()
    }

    func saveDataWithNSUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        // http://stackoverflow.com/questions/1249634/wheres-the-difference-between-setobjectforkey-and-setvalueforkey-in-nsmutab
        defaults.setObject(movies, forKey: "movies")
        defaults.synchronize()
    }

    func loadDataWithNSUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        movies = defaults.objectForKey("movies") as? [NSDictionary]
    }

    func fetchMovies() {
        let clientId = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(clientId)")!
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 2)
//        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil else {
                print("Error: ", error?.description)
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadDataWithNSUserDefaults()
                    self.tableView.reloadData()
                }
                return
            }

            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            self.movies = json["results"] as? [NSDictionary]
//            print("data and response", self.movies)
            dispatch_async(dispatch_get_main_queue()) {
                self.saveDataWithNSUserDefaults()
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
