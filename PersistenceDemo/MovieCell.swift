//
//  MovieCell.swift
//  PersistenceDemo
//
//  Created by Harley Trung on 4/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!

    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            let path = movie.posterPath
            let url = "https://image.tmdb.org/t/p/w342" + path
            let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                guard let data = data where error == nil else { return }
                dispatch_async(dispatch_get_main_queue(), {
                    self.posterView.image = UIImage(data: data)
                })
            }
            task.resume()
        }
    }
}
