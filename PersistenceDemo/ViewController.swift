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

        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                return
            }

            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            self.movies = json["results"] as? [NSDictionary]
            print("data and response", self.movies)
            dispatch_async(dispatch_get_main_queue()) {
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
