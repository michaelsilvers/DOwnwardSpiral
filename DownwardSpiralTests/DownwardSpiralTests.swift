//
//  DownwardSpiralTests.swift
//  DownwardSpiralTests
//
//  Created by Mike Silvers on 4/20/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import XCTest
@testable import DownwardSpiral

class DownwardSpiralTests: XCTestCase {

    func testDataModelForFileExistence() {

        // we sre testing for the existance of all three json files and that they have the correct number of entries.
        // lets make sure we can grab the path
        // FILE 1
        if let path = Bundle.main.path(forResource: "DownwardSpiral-0", ofType: "json") {
            let fm = FileManager()
            
            // make sure the file exists in the project
            XCTAssertTrue(fm.fileExists(atPath: path), "The file 'DownwardSpiral-0.json' does NOT exist.")
            if fm.fileExists(atPath: path) {
                
                if let string = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8 ) {
                    
                    let s = string.replacingOccurrences(of: "\n", with: "")
                    
                    do {
                        let them = try JSONDecoder().decode([DataPoint].self, from: s.data(using: .utf8)!)
                        XCTAssertTrue(them.count == 60, "Decoding failed.  Expecting 60, received \(them.count)")
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        XCTAssert(false, "Error: \(error.localizedDescription)")
                    }
                    
                } else {
                    XCTAssert(false, "There was a problem reading the file as data.")
                }
            }
            
        } else {
            XCTAssert(false, "We can not get the file path.")
        }

        // FILE 2
        // lets make sure we can grab the path
        if let path = Bundle.main.path(forResource: "DownwardSpiral-1", ofType: "json") {
            let fm = FileManager()
            
            // make sure the file exists in the project
            XCTAssertTrue(fm.fileExists(atPath: path), "The file 'DownwardSpiral-1.json' does NOT exist.")
            if fm.fileExists(atPath: path) {
                
                if let string = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8 ) {
                    
                    let s = string.replacingOccurrences(of: "\n", with: "")
                    
                    do {
                        let them = try JSONDecoder().decode([DataPoint].self, from: s.data(using: .utf8)!)
                        XCTAssertTrue(them.count == 60, "Decoding failed.  Expecting 60, received \(them.count)")
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        XCTAssert(false, "Error: \(error.localizedDescription)")
                    }
                    
                } else {
                    XCTAssert(false, "There was a problem reading the file as data.")
                }
            }
            
        } else {
            XCTAssert(false, "We can not get the file path.")
        }
        
        // FILE 3
        // lets make sure we can grab the path
        if let path = Bundle.main.path(forResource: "DownwardSpiral-2", ofType: "json") {
            let fm = FileManager()
            
            // make sure the file exists in the project
            XCTAssertTrue(fm.fileExists(atPath: path), "The file 'DownwardSpiral-2.json' does NOT exist.")
            if fm.fileExists(atPath: path) {
                
                if let string = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8 ) {
                    
                    let s = string.replacingOccurrences(of: "\n", with: "")
                    
                    do {
                        let them = try JSONDecoder().decode([DataPoint].self, from: s.data(using: .utf8)!)
                        XCTAssertTrue(them.count == 60, "Decoding failed.  Expecting 60, received \(them.count)")
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        XCTAssert(false, "Error: \(error.localizedDescription)")
                    }
                    
                } else {
                    XCTAssert(false, "There was a problem reading the file as data.")
                }
            }
            
        } else {
            XCTAssert(false, "We can not get the file path.")
        }
    }
    
    func testForFileNotExisting() {
        
        if let path = Bundle.main.path(forResource: "DownwardSpiral", ofType: "json") {
            let fm = FileManager()
            
            // make sure the file exists in the project
            XCTAssertFalse(fm.fileExists(atPath: path), "The file 'DownwardSpiral.json' does NOT exist.")
            
        }
    }
    
    func testAddSingleDataPointToTheDataPointSet() {
        
        // prepare the base DataPoints:
        var dps = DataPointSet()
        
        if let path = Bundle.main.path(forResource: "DownwardSpiral-1", ofType: "json") {
            let fm = FileManager()
            
            // make sure the file exists in the project
            XCTAssertTrue(fm.fileExists(atPath: path), "The file 'DownwardSpiral-1.json' does NOT exist.")
            if fm.fileExists(atPath: path) {
                
                if let string = try? String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8 ) {
                    
                    let s = string.replacingOccurrences(of: "\n", with: "")
                    
                    do {
                        let them = try JSONDecoder().decode([DataPoint].self, from: s.data(using: .utf8)!)
                        
                        // set the datappoint array to the set
                        dps.datapoints = them
                        
                        // lets look at the specifics of the data points:
                        let firstsize = dps.getMaxOverallWidthAndHeight()
                        
                        // pull out a DataPoint to adjust it:
                        let dp_adj = dps.datapoints.last
                        if dp_adj != nil {
                            
                            // add 100 to the width
                            var dp_adj_plus = dp_adj!
                            dp_adj_plus.start     = dp_adj_plus.start + 100
                            dp_adj_plus.barheight = dp_adj_plus.barheight + 3.5
                            
                            // now add the new point to the set
                            dps.appendDataPoint(dp_adj_plus)
                            
                            // grab the new specs
                            let secondsize = dps.getMaxOverallWidthAndHeight()
                            
                            // now for the testing - first the seconds
                            XCTAssertTrue((firstsize.totalSeconds + 100) == secondsize.totalSeconds, "The total seconds should be a difference of 100.  If is not.  The difference is \(secondsize.totalSeconds - firstsize.totalSeconds)" )

                            // Now test for the height (FTP)
                            XCTAssertTrue(firstsize.height + 1.0 == secondsize.height, "The FTP should be increased by 1.  If is not.  The difference is \(secondsize.height - firstsize.height)" )
                            
                            // make sure the width of the second from ast was updated correctly (to 100)
                            let secondfromlast = dps.datapoints[(dps.datapoints.count - 2)]
                            XCTAssertTrue(secondfromlast.barwidth == 100, "The barwidth is incorrect - expecting 100 and received \(secondfromlast.barwidth)")

                        }
                        
                    } catch {
                        print("Error: \(error.localizedDescription)")
                        XCTAssert(false, "Error: \(error.localizedDescription)")
                    }
                    
                } else {
                    XCTAssert(false, "There was a problem reading the file as data.")
                }
            }
            
        } else {
            XCTAssert(false, "We can not get the file path.")
        }
    }
    
    func testDataPointColorsVsFTP() {
        
        let blue = UIColor.init(displayP3Red: 80.0/255, green: 185.0/255, blue: 229.0/255, alpha: 1.0)
        let yellow = UIColor.init(displayP3Red: 249.0/255, green: 210.0/255, blue: 71.0/255, alpha: 1.0)
        let orange = UIColor.init(displayP3Red: 241.0/255, green: 144.0/255, blue: 53.0/255, alpha: 1.0)
        let red = UIColor.init(displayP3Red: 219.0/255, green: 57.0/255, blue: 111.0/255, alpha: 1.0)

        // Test for the FTP expecting blue
        var dp_test_1 = DataPoint(name: "point", start: 0, barheight: 1.0, barwidth: 0)
        XCTAssertTrue(dp_test_1.color == blue, "The coor is incorrect for \(dp_test_1.barheight)  Expecting \(blue) but received \(dp_test_1.color)")

        var dp_test_2 = DataPoint(name: "point", start: 0, barheight: 0.9, barwidth: 0)
        XCTAssertTrue(dp_test_2.color == blue, "The coor is incorrect for \(dp_test_2.barheight)  Expecting \(blue) but received \(dp_test_2.color)")

        // test for an FTP expecting yellow
        dp_test_1 = DataPoint(name: "point", start: 0, barheight: 1.1, barwidth: 0)
        XCTAssertTrue(dp_test_1.color == yellow, "The coor is incorrect for \(dp_test_1.barheight)  Expecting \(yellow) but received \(dp_test_1.color)")
        
        dp_test_2 = DataPoint(name: "point", start: 0, barheight: 1.26, barwidth: 0)
        XCTAssertTrue(dp_test_2.color == yellow, "The coor is incorrect for \(dp_test_2.barheight)  Expecting \(yellow) but received \(dp_test_2.color)")

        // test for an FTP expecting orange
        dp_test_1 = DataPoint(name: "point", start: 0, barheight: 1.27, barwidth: 0)
        XCTAssertTrue(dp_test_1.color == orange, "The coor is incorrect for \(dp_test_1.barheight)  Expecting \(orange) but received \(dp_test_1.color)")
        
        dp_test_2 = DataPoint(name: "point", start: 0, barheight: 1.64, barwidth: 0)
        XCTAssertTrue(dp_test_2.color == orange, "The coor is incorrect for \(dp_test_2.barheight)  Expecting \(orange) but received \(dp_test_2.color)")

        // test for an FTP expecting red
        dp_test_1 = DataPoint(name: "point", start: 0, barheight: 1.65, barwidth: 0)
        XCTAssertTrue(dp_test_1.color == red, "The coor is incorrect for \(dp_test_1.barheight)  Expecting \(red) but received \(dp_test_1.color)")
        
        dp_test_2 = DataPoint(name: "point", start: 0, barheight: 3.09, barwidth: 0)
        XCTAssertTrue(dp_test_2.color == red, "The coor is incorrect for \(dp_test_2.barheight)  Expecting \(red) but received \(dp_test_2.color)")

        let dp_test_3 = DataPoint(name: "point", start: 0, barheight: 3.20, barwidth: 0)
        XCTAssertTrue(dp_test_3.color == red, "The coor is incorrect for \(dp_test_3.barheight)  Expecting \(red) but received \(dp_test_3.color)")

    }

}
