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

    var movie: NSDictionary! {
        didSet {
            titleLabel.text = movie.valueForKey("original_title") as? String
            overviewLabel.text = movie.valueForKey("overview") as? String
            // implement posterView here
        }
    }
}
