//
//  DistributionGraph.swift
//  TrainingCamps
//
//  Created by Steven Lord on 17/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//

import Cocoa

class DistributionGraph: NSView{
    
    var numberOfNormalDistributionPoints: Int = 101
    var xAxisFormatter: (Double) -> String = {
        let timeFormatter: TransformerNSNumberToTimeFormat = TransformerNSNumberToTimeFormat()
        timeFormatter.includeHours = false
        return timeFormatter.transformedValue($0) as! String
    }
    
    private var normalData: [(x:Double, y:Double)] = []
    private var mean: Double = 0.0
    private var variance: Double = 1.0
    private var buckets: [Bucket] = []

    private var highlightedValues: [Double] = []
    
    private var maxX: Double = 0.0
    private var maxY: Double = 0.0
    
    private var minX: Double = 0.0
    private var minY: Double = 0.0
    
    private var paddingTop: CGFloat = 10.0
    private var paddingBottom: CGFloat = 30.0
    private var paddingRight: CGFloat = 10.0
    private var paddingLeft: CGFloat = 30.0
    private var labelHeight: CGFloat = 14.0
    private var timeLabelWidth: CGFloat = 75.0
    
    private var labels: [NSTextField] = []
    
    
    func set(buckets b: [Bucket], mean: Double, variance: Double){
        self.mean = mean
        self.variance = variance
        buckets = b
        updateLimits()
        normalData = createNormalData()
        needsDisplay = true
    }
    
    func setHighlighted(x: [Double]){
        highlightedValues = x
        needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if mean.isNaN || variance.isNaN { return }
        
        for l in labels{
            l.removeFromSuperview()
        }
        
        if let gradient = NSGradient(starting: .black, ending: .darkGray){
            gradient.draw(in: dirtyRect, angle: 90.0)
        }
        
        if normalData.count == 0 || buckets.count == 0 { return }
        
        for b in buckets{
            let bucketPath = NSBezierPath()

            bucketPath.move(to: coordinatesInGraph(b.from, 0.0, dirtyRect))
            bucketPath.line(to: coordinatesInGraph(b.from, b.size, dirtyRect))
            bucketPath.line(to: coordinatesInGraph(b.to, b.size, dirtyRect))
            bucketPath.line(to: coordinatesInGraph(b.to, 0.0, dirtyRect))
            bucketPath.line(to: coordinatesInGraph(b.from, 0.0, dirtyRect))
           
            if let gradient = NSGradient.init(starting: AppDelegate.edtPink, ending: AppDelegate.edtBlue){
                gradient.draw(in: bucketPath, angle: 90.0)
            }
            
            bucketPath.lineWidth = 1.0
            AppDelegate.edtBlue.setStroke()
            bucketPath.stroke()
        }
        
        let path = NSBezierPath()
        
        path.move(to: coordinatesInGraph(normalData[0].x, normalData[0].y, dirtyRect))
        
        for p in createNormalData(){
            path.line(to: coordinatesInGraph(p.x, p.y, dirtyRect))
        }
        
        
        path.lineWidth = 2.0
        NSColor.red.setStroke()
        path.stroke()
        
        let axisMarkersLine = NSBezierPath()
        
        //create markers for stdDevs - start 3 below to 3 above. So 7 lines.
        let stdDev: Double = sqrt(variance)
        let start: Double = mean - 3.0 * stdDev
        
        for i in 0...6{
            let x = start + stdDev * Double(i)
            axisMarkersLine.move(to: coordinatesInGraph(x, minY, dirtyRect))
            axisMarkersLine.line(to: coordinatesInGraph(x, maxY, dirtyRect))
            let coord = coordinatesInGraph(x, 0.0, dirtyRect)
            let labelName: String = xAxisFormatter(x)
            let label = createLabel(value: labelName, origin: CGPoint(x: coord.x - timeLabelWidth/2.0, y: paddingBottom - labelHeight - 2.0), width: timeLabelWidth, alignment: .center)
            labels.append(label)
            addSubview(label)
        }
        
        let interval = yAxisMarkInterval()
        var y = interval
        
        while y < maxY{
            axisMarkersLine.move(to: coordinatesInGraph(minX, y, dirtyRect))
            axisMarkersLine.line(to: coordinatesInGraph(maxX, y, dirtyRect))
            let coord = coordinatesInGraph(0.0, y, dirtyRect)
            let label = createLabel(value: String(Int(y)), origin: CGPoint(x: 0.0, y: coord.y - labelHeight/2.0), width: paddingLeft - 2.0, alignment: .right)
            addSubview(label)
            labels.append(label)
            y += interval
        }
        
        axisMarkersLine.lineWidth = 1.0
        let dash: [CGFloat] = [1.0,1.0]
        axisMarkersLine.setLineDash(dash, count: 2, phase: 0.0)
        NSColor.white.setStroke()
        axisMarkersLine.stroke()
        
        //create markers for
        
        for highlightedValue in highlightedValues{
            let highlight = NSBezierPath()
            let arrowWidth: CGFloat = 3.0
            let arrowHeight: CGFloat = 8.0
            let origin = coordinatesInGraph(highlightedValue, 0.0, dirtyRect)
            highlight.move(to: origin)
            highlight.line(to: coordinatesInGraph(highlightedValue, maxY / 5.0, dirtyRect))
            highlight.move(to: origin)
            highlight.line(to: NSPoint(x: origin.x - arrowWidth, y: origin.y + arrowHeight))
            highlight.move(to: origin)
            highlight.line(to: NSPoint(x: origin.x + arrowWidth, y: origin.y + arrowHeight))

            highlight.lineWidth = 2.0
            NSColor.green.setStroke()
            highlight.stroke()
        }
        
        drawAxes(dirtyRect)
        
        
    }
    
    private func yAxisMarkInterval() -> Double{
        switch maxY{
        case 0...7.0: return 1.0
        case 7.0...14.0: return 2.0
        case 14.0...21.0: return 3.0
        case 21.0...28.0: return 4.0
        case 28.0...40.0: return 5.0
        case 40.0...100.0: return 10.0
        case 100.0...250.0: return 25.0
        case 250.0...500.0: return 50.0
        default: return 100.0
        }
    }
    
    private func coordinatesInGraph(_ x: Double, _ y: Double, _ dirtyRect: NSRect) -> NSPoint{
        let xRange: CGFloat = CGFloat(maxX - minX)
        let yRange: CGFloat = CGFloat(maxY - minY)
        
        if xRange == 0.0 || yRange == 0.0{
            return NSPoint(x: 0, y: 0)
        }
        
        let xInView = paddingLeft + (dirtyRect.maxX - (paddingLeft + paddingRight)) * CGFloat(x - minX) / xRange
        let yInView = paddingBottom + (dirtyRect.maxY - (paddingBottom + paddingTop)) * CGFloat(y - minY) / yRange
        
        return NSPoint(x: xInView, y: yInView)
    }
    
    private func drawAxes(_ dirtyRect: NSRect){
        let xAxis = NSBezierPath()
        let yAxis = NSBezierPath()
        let origin: NSPoint = NSPoint(x: paddingLeft, y: paddingBottom)
        
        xAxis.move(to: origin)
        yAxis.move(to: origin)
        
        xAxis.line(to: NSPoint(x: dirtyRect.maxX - paddingRight, y: origin.y ))
        yAxis.line(to: NSPoint(x: origin.x, y: dirtyRect.maxY - paddingTop))
        
        xAxis.lineWidth = 2.0
        yAxis.lineWidth = 2.0
        
        NSColor.white.setStroke()
        
        xAxis.stroke()
        yAxis.stroke()
        
    }
    
    private func createNormalData() -> [(x:Double, y:Double)]{
        let xIncrement: Double = (maxX - minX) / Double(numberOfNormalDistributionPoints - 1)
        let xStart: Double = minX
        let calculator: Maths = Maths()
        let scale: Double = buckets.reduce(0.0, {max($0, $1.size)}) / calculator.normalDensityFunction(x: mean, mean: mean, variance: variance)
        var result: [(x:Double, y:Double)] = []
        for i in 0...numberOfNormalDistributionPoints{
            let x: Double = xStart + Double(i) * xIncrement
            let y: Double = calculator.normalDensityFunction(x: x, mean: mean, variance: variance) * scale
            result.append((x,y))
        }

        return result
    }
    
    private func createLabel(value: String, origin: CGPoint, width: CGFloat, alignment: NSTextAlignment) -> NSTextField {
        let label = NSTextField(frame: NSRect(x: origin.x, y: origin.y, width: width, height: labelHeight))
        label.stringValue = value
        label.textColor = .white
        label.backgroundColor = NSColor.clear
        label.alignment = alignment
        label.isBordered = false
    
        return label
    }
    
    
    private func updateLimits(){
        //cover at least +- 3 standard deviations
        maxX = mean + sqrt(variance) * 3.0
        minX = mean - sqrt(variance) * 3.0
        
        let maxBucketX = buckets.filter({$0.size > 0.0}).reduce(0.0, {max($0, $1.to)})
        let minBucketX = buckets.filter({$0.size > 0.0}).reduce(1000000.0, {min($0, $1.from)})
        
        maxX = max(maxX, maxBucketX)
        minX = min(minX, minBucketX)
                
        maxY = buckets.reduce(0.0,{max($0,$1.size)})
    }
    
}
