//
//  DataPoint.swift
//  DownwardSpiral
//
//  Created by Mike Silvers on 4/20/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import Foundation

/**
 This structure defines the DataPoint object and its attributes.
 */
struct DataPoint: Codable, Equatable {
    
    /// Tha type of the datapoint.
    var name      : String
    /// The start of the data point
    var start     : Int
    /// The hieght of the bar.  Calculated using functions in the DataPointSet
    var barheight : Double
    /// The width of the datappoint.  Calculated in the DataPointSet
    var barwidth  : Int = 0
    /// The color of the bar as displayed.  The color os dependent upon the height of the bar (the FTP)
    var color     : UIColor {
        
        // set the color of the bar dependent upon the bar height in relation to the FTP
        switch barheight {
            
        case barheight where barheight <= DataPointSet.FTPPercent.blue.rawValue:
            return DataPointSet.FTPPercent.blue.color
        case barheight where barheight <= DataPointSet.FTPPercent.yellow.rawValue:
            return DataPointSet.FTPPercent.yellow.color
        case barheight where barheight <= DataPointSet.FTPPercent.orange.rawValue:
            return DataPointSet.FTPPercent.orange.color
        case barheight where barheight > DataPointSet.FTPPercent.orange.rawValue:
            return DataPointSet.FTPPercent.red.color
        default:
            return DataPointSet.FTPPercent.blue.color
        }
        
    }
    
    // the list of coding keys - associating the json to the variables in this struct
    enum CodingKeys: String, CodingKey {
        
        case name      = "type"
        case start     = "start"
        case barheight = "ftp"
        
    }
    
}
