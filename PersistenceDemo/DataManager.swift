//
//  DataManager.swift
//  PersistenceDemo
//
//  Created by Harley Trung on 4/18/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import Foundation

class DataManager {
    // class vs static methods:
    // http://stackoverflow.com/questions/29636633/static-vs-class-functions-variables-in-swift-classes
    static func saveToNSUserDefaults(movies: [Movie]?) {
        guard let movies = movies else {
            print("saving nothing")
            return
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(movies)
        defaults.setObject(data, forKey: "movies")
        defaults.synchronize()
    }

    static func loadFromNSUserDefaults() -> [Movie]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = defaults.objectForKey("movies") as? NSData
        return NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [Movie]
    }

    static func dataFile() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsPath.stringByAppendingString("data.archive")
    }

    static func saveToFile(movies: [Movie]?) {
        NSKeyedArchiver.archiveRootObject(movies!, toFile: dataFile())
    }

    static func loadFromFile() -> [Movie]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(dataFile()) as? [Movie]
    }
}
