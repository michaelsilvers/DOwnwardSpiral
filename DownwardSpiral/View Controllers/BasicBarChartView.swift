//
//  BasicBarChartView.swift
//  DownwardSpiral
//
//  Created by Mike Silvers on 4/20/19.
//  Copyright © 2019 Mike Silvers. All rights reserved.
//

import UIKit

@IBDesignable class BasicBarChartView: UIView {

    private let mainLayer: CALayer = CALayer()
    
    /// The data points for the display
    var dataEntries: DataPointSet? = nil {
        didSet {
            // after the data is set to the local variable, perform the setup for the bars
            setupBars()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // setup the basics of the view
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        // setup the basics of the view
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // setup the basics of the view
        setupView()
    }
    
    override func layoutSubviews() {
        
        // this is the main location where we reset the frame to the size of the view.  This is done here
        // so changes from landscape to portrait
        mainLayer.frame = CGRect(x: 0, y: 0, width:self.bounds.width , height: self.bounds.height)
        // run the functions to set everything up
        setupBars()
        drawHorizontalLines()
        drawMinuteLabelLayer()
    }
    
    /**
     This private function prepares the view for display.
    */
    private func setupView() {
        // we are adding the man layer and flipping it to make it the correct orientation
        self.layer.addSublayer(mainLayer)
        self.layer.sublayerTransform = CATransform3DMakeScale( CGFloat(1.0), CGFloat(CFloat(-1.0)), CGFloat(CFloat(1.0)) )
    }
    
    /**
     This private function prepares the bars for display as layers to the views main layer.
    */
    private func setupBars() {
        
        // remove all of the sublayers - starting from a base layer with no sublayers
        mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        // make sure the variable is not nil
        if let dataEntries = dataEntries {
            
            // we are getting the max width and height to make the calculations for each bar
            let widthAndHeight = dataEntries.getMaxOverallWidthAndHeight()
            // set the datappoints we read to the view
            let datapoints = dataEntries.datapoints
            
            // lets look at what we need to do as a multiplier
            var widthmultiplier : CGFloat = 0.0
            if CGFloat(widthAndHeight.width) > self.bounds.width {
                widthmultiplier = self.bounds.width / CGFloat(widthAndHeight.width)
            } else {
                widthmultiplier = CGFloat(widthAndHeight.width) / self.bounds.width
            }
            
            // lets look at what we need to do as a multiplier
            var heightmultiplier : CGFloat = 0.0
            if CGFloat(widthAndHeight.height) > self.bounds.height {
                heightmultiplier = CGFloat(widthAndHeight.height) / self.bounds.height
            } else {
                heightmultiplier = self.bounds.height / CGFloat(widthAndHeight.height)
            }
            
            // set the main layer frame to the size of the view
            mainLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            
            // process all of the datapoints to add the bars to the main layer
            for i in 0..<datapoints.count {
                let dp = datapoints[i]
                // add the bar layer
                addBarLayer(dp, (Double(widthmultiplier), Double(heightmultiplier)))
            }
        }

    }
    
    /**
     This private function adds a sublayer to the main layr and defined the bar for that layer.
     - parameter point: (DataPoint) The DataPoint object used for the sublayer.
     - parameter multipliers: (Double,Double) A tuple that encapsulates the width multiplier and the height multiplier for the display.  The width multiplier adjusts the width of the bar according to the main view width.  The height multiplier adjusts the height of the bar according to the overall height of the display.
    */
    private func addBarLayer(_ point : DataPoint, _ multipliers: (widthMultiplier: Double, heightMultiplier: Double)) {
        
        // adjust the start point with the multiplier
        let start = Double(point.start) * multipliers.widthMultiplier
        
        // The starting x position of the bar
        let xPos : CGFloat = CGFloat(start)
        
        // Set the starting point of the y position - we are starting from the
        let yPos = CGFloat(0.0)
        
        // draw the actual bar itself
        drawBar(xPos: xPos, yPos: yPos, dp: point, multipliers)
        
    }
    
    /**
     This private function will perform the process to add the sublayer representing the bar.
     - parameter xPos: (CGFloat) The 'x' axis position of the bar.
     - parameter yPos: (CGFloat) The 'y' axis position of the bar.
     - parameter dp: (DataPoint) The datapont object to be displayed.
     - parameter multipliers: (Double,Double) A tuple that encapsulates the width multiplier and the height multiplier for the display.  The width multiplier adjusts the width of the bar according to the main view width.  The height multiplier adjusts the height of the bar according to the overall height of the display.  The default is (0.0,0.0).
    */
    private func drawBar(xPos: CGFloat, yPos: CGFloat, dp: DataPoint, _ multipliers: (widthMultiplier: Double, heightMultiplier: Double) = (0.0,0.0)) {
        
        // set the correct width and height according to the relationship for this bar abd the overall size
        let width = Double(dp.barwidth) * multipliers.widthMultiplier
        let height = Double(dp.barheight) * multipliers.heightMultiplier
        
        // setup the bar for drawing
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: xPos, y: yPos, width: CGFloat(width), height: CGFloat(height))
        barLayer.contentsScale = 2.0
        barLayer.backgroundColor = dp.color.cgColor
        mainLayer.addSublayer(barLayer)
    }
    
    /**
     This private function will draw the layer containing the horizontal line at the FTP of 1.0.  The line is drawn to be used as a reference comparing the overall height and FTP value for the chat.
    */
    private func drawHorizontalLines() {
        
        // remove all horizontal lines before adding any new ones
        self.layer.sublayers?.forEach({ if $0 is CAShapeLayer { $0.removeFromSuperlayer() } })
        
        let xPos = CGFloat(0.0)
        // figure out the 1.0 FTP line
        var yPos = CGFloat(0.0)
        // grab the sizes and details for this line
        if let thesizes = dataEntries?.getMaxOverallWidthAndHeight() {
            yPos = CGFloat(1 / thesizes.height)
        }
        
        // the height was set to the percentage of the height above - now set the correct height
        // this is the 1.0 FTP point for the data
        yPos *= self.bounds.height
        
        // draw the dashed horizontal line at the 1.0 FTP point
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xPos, y: yPos))
        path.addLine(to: CGPoint(x: self.bounds.width, y: yPos))
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = 1.0
        lineLayer.lineDashPattern = [4, 4]
        lineLayer.strokeColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.7511828785).cgColor
        self.layer.sublayers?.append(lineLayer)
    }
    
    /**
     This private function draws the layer with the total time for the workout in minutes.
    */
    private func drawMinuteLabelLayer() {
        
        // remove any of the text layers before adding another text layer
        self.layer.sublayers?.forEach({ if $0 is CATextLayer { $0.removeFromSuperlayer() } })

        // grab the duration of the ride (in secnds)
        var seconds = 0
        if let thesizes = dataEntries?.getMaxOverallWidthAndHeight() {
            seconds = thesizes.totalSeconds
        }
        
        // round the seconds to the closest minute
        let minute : Int = seconds / 60
        
        // setup the text layer
        let minutesLabel = CATextLayer()
        // we are using different font sizes depending upon the orientation of the device
        var theheight = 30
        var thefont : UIFont = UIFont(name: "HelveticaNeue-Bold", size: 26.0)!
        if (UIDevice.current.orientation == UIDeviceOrientation.portrait) ||
            (UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown) {
            thefont = UIFont(name: "HelveticaNeue-Bold", size: 20.0)!
            theheight = 25
        }
        
        // prepare the minute label layer itself
        minutesLabel.frame = CGRect(x: 0, y: 0, width: 120, height: theheight)
        
        minutesLabel.backgroundColor = UIColor.clear.cgColor
        minutesLabel.alignmentMode = CATextLayerAlignmentMode.left
        minutesLabel.contentsScale = UIScreen.main.scale
        minutesLabel.masksToBounds = true

        // setup the text color schemen with outline border
        let attributes = [
            NSAttributedString.Key.font : thefont as Any,
            NSAttributedString.Key.strokeWidth : -3.0,
            kCTForegroundColorAttributeName : UIColor.white,
            kCTStrokeColorAttributeName : UIColor.black] as [AnyHashable : Any]
        let string = NSAttributedString(string: "\(minute) MIN", attributes: (attributes as! [NSAttributedString.Key : Any]))
        minutesLabel.string = string

        // spin around to the correct non-mrror image
        minutesLabel.transform = CATransform3DMakeScale( CGFloat(1.0), CGFloat(CFloat(-1.0)), CGFloat(CFloat(1.0)) )
        
        self.layer.sublayers?.append(minutesLabel)
        
    }
}
