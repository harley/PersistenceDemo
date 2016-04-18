//
//  Movie.swift
//  PersistenceDemo
//
//  Created by Harley Trung on 4/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import Foundation

class Movie: NSObject, NSCoding {
    var title = ""
    var posterPath = ""
    var overview = ""

    override init() {
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(posterPath, forKey: "posterPath")
        aCoder.encodeObject(overview, forKey: "overview")
    }
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObjectForKey("title") as! String
        overview = aDecoder.decodeObjectForKey("overview") as! String
        posterPath = aDecoder.decodeObjectForKey("posterPath") as! String
    }
}