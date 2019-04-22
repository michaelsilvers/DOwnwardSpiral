//
//  DataPointSet.swift
//  DownwardSpiral
//
//  Created by Mike Silvers on 4/20/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit
import Foundation

/// The size information to assist with the display of the bar.  This structure contains
/// the width, height and total seconds for the display
struct sizes {
    var width        : Double = 0.0
    var height       : Double = 0.0
    var totalSeconds : Int    = 0
}

/**
  This structure defines the controller for the DataPoint array.  Several functions are performed when specific varables are changed.  When the DataPoints are added to the DataPointSet, the width, color and other attributes are are updated in all DataPoints contained witin the array of DataPoints.
*/
struct DataPointSet {

    /// This allows the FTP number to be associated with a color
    enum FTPPercent: Double {
        
        // set the correct colors for the bars
        var color : UIColor {
            switch self {
            case .blue:
                return UIColor.init(displayP3Red: 80.0/255, green: 185.0/255, blue: 229.0/255, alpha: 1.0)
            case .yellow:
                return UIColor.init(displayP3Red: 249.0/255, green: 210.0/255, blue: 71.0/255, alpha: 1.0)
            case .orange:
                return UIColor.init(displayP3Red: 241.0/255, green: 144.0/255, blue: 53.0/255, alpha: 1.0)
            case .red:
                return UIColor.init(displayP3Red: 219.0/255, green: 57.0/255, blue: 111.0/255, alpha: 1.0)
            }
        }
        
        // and these are the FTP percentages related to the colors
        case blue   = 1.0  // 1.0 and below
        case yellow = 1.26 // > 1.0 and <= 1.26
        case orange = 1.64 // > 1.26 and <= 1.64
        case red    = 3.09 // > 1.64
    }

    private var _datapoints = [DataPoint]()
    /// The datapoints maintained and processed by this set of datapoints
    var datapoints : [DataPoint] {
        get {
            // we are always making sure the array is sorted correctly based on the start time
            return _datapoints.sorted { $0.start < $1.start }
        }
        set (newItem) {
            _datapoints = newItem 
        }
    }
    
    /**
     This function will calculate the size information for all DataPoints and return the information.
     - returns: (sizes) The sizes structure containing the width, height and total seconds for the overall DataPoints.  This is for all DataPoints combined, not for individual DataPoints.
     */
    func getMaxOverallWidthAndHeight() -> sizes {
        
        var thesizes = sizes()
        
        // grab the last datapoint and determine the overall width
        if let last = datapoints.last {
            thesizes.width = Double(last.start) + Double(last.barwidth)
        }
        
        // grab the max bar height - this allows us to round the FTP up to the next whole number
        // By rounding up, we are sure that the bars do not extend over and beyond the
        // top of the heights.  It also allows us to determine the positioning for the
        // FTP 1.0 horizonastl line
        if let max = ((_datapoints.sorted { $0.barheight < $1.barheight }).last)?.barheight {
            // round max up to the next whole number
            thesizes.height = max.rounded(.awayFromZero)
        }
        
        // determine the total number of seconds - again - round it up
        thesizes.totalSeconds = Int(thesizes.width.rounded(.toNearestOrAwayFromZero))
        
        return thesizes
    }
    
    /**
     This function sets the bar widths for the individual bars for each DataPoint in the array.  This will update all DataPoints in the DataPoint array.
    */
    mutating func setBarWidths() {
        
        var barset = self.datapoints
        var last_dp : DataPoint?
        // loop thru to update the data points with the width of
        // the bar nased on theoverall width of all bars
        for (index,bar) in barset.enumerated() {
            
            let bar_changed = bar
            
            if last_dp == nil {
                last_dp = bar_changed
            } else {
                last_dp!.barwidth = bar_changed.start - last_dp!.start
                barset[(index-1)] = last_dp!
                last_dp = bar_changed
            }
            
        }
        
        // set the newly updated widths to the barset
        _datapoints = barset
        
    }
    
    /**
     This function will append a single DataPoint to the existing DataPoint array.  The defining characteristics of each DataPoint (such as the width) are also updated.
     - parameter newPoint: (DataPoint)  The new single DataPoint to be added to the DataPoint array.
    */
    mutating func appendDataPoint(_ newPoint: DataPoint) {
        
        // if there are others in the dataset, calculate the bar width
        var dp_a = datapoints
        if dp_a.count > 0 {
            // get the last entry to calculate the width
            if let last_entry = dp_a.last {
                var last_entry_w = last_entry
                last_entry_w.barwidth = newPoint.start - last_entry_w.start
                
                // save both of them
                dp_a.removeLast()
                dp_a.append(last_entry_w)
                dp_a.append(newPoint)
                self.datapoints = dp_a
            }
            
        } else {
            // this is the first data point of the set
            dp_a.append(newPoint)
            self.datapoints = dp_a
        }
    }
}
