//
//  MainViewController.swift
//  DownwardSpiral
//
//  Created by Mike Silvers on 4/20/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    /// The main chart view used to duisplay the bars
    @IBOutlet weak var chartView    : BasicBarChartView!
    /// The segmented controller that allows different datasets to be displayed
    @IBOutlet weak var fileSelector : UISegmentedControl!
    
    // internal variables
    /// A working variable that contains the data points
    private var datapoints_work = [DataPoint]()
    /// The controller for the data points
    private var datapointset    = DataPointSet()
    /// The default selected file is file 0.  This vasriable is used to change the selected file
    private var selectedFile    = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        // determine the correct file to use
        fileSelector.selectedSegmentIndex = selectedFile
        // fill the datasource with the correct file data
        fillData(selectedFile)

    }

    /**
      This function processes the change to the UISegmented control.  When the user makes a selection,
       The file that contains the data is changed.  This function will change the file and update the
       BasicBarChartView.
     - parameter sender: The UISegmentedControl requesting the change.
    */
    @IBAction func fileSelectorChanged(_ sender: UISegmentedControl) {
        
        // change the file dependent upon the selection
        selectedFile = sender.selectedSegmentIndex
        
        // fill the data witht he file information
        fillData(selectedFile)
        
        // update the chart view itself
        chartView.setNeedsLayout()
        
    }
    
    /**
     This private function processes the change of files to update the data.  The data is read from the
      file and parsed appropriately.
     - parameter fileNumber: (Int) The file number to read.  All files are prepended with `DownwardSpiral-` and are json type files.
     */
    private func fillData(_ fileNumber: Int) {
        
        // make sure there are no entries in the array
        datapoints_work.removeAll()
        
        // fill the data array - only need to do this once as it is not changing
        let fm = FileManager()
        
        // lets make sure we can grab the path
        if let path = Bundle.main.path(forResource: "DownwardSpiral-\(fileNumber)", ofType: "json") {
            
            // make sure the file exists in the project
            if fm.fileExists(atPath: path) {
                
                // read the file and process it
                if let string = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8 ) {
                    
                    // there is an issue with the file and decoding (they add \n for newline)
                    let s = string.replacingOccurrences(of: "\n", with: "")
                    
                    // perform the data decoding
                    if let dps = try? JSONDecoder().decode([DataPoint].self, from: s.data(using: .utf8)!) {
                        // they were parsed - now it is ready to use
                        datapoints_work.append(contentsOf: dps)
                    }
                }
            }
        }
        
        // set the datapoints to the new value we just parsed
        datapointset.datapoints = datapoints_work
        datapointset.setBarWidths()
        
        // set the data to the chartview
        chartView.dataEntries = datapointset

    }
}

