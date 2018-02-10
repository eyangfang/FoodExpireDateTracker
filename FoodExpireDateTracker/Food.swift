//
//  Food.swift
//  FoodExpireDateTracker
//
//  Created by Fang Yang on 3/2/18.
//  Copyright © 2018 Yang Fang. All rights reserved.
//

import UIKit
import os.log

class Food: NSObject, NSCoding{
    
    var name: String = ""
    var date: String = ""
    var photo: UIImage?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("foodexpiredate")
    
    //MARK: Type
    struct PropertyKey{
        static let name = "name"
        static let date = "date"
        static let photo = "photo"
    }
    
    init?(name: String, date: String, photo: UIImage?){
        guard !name.isEmpty else{
            return nil
        }
        
        guard !date.isEmpty else{
            return nil
        }
        self.name = name
        self.date = date
        self.photo = photo
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode the name for a Food object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String else{
            os_log("Unable to decode the date for a Food object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(name: name, date: date, photo: photo)
    }
    
    
    
}
