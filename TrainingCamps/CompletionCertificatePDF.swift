//
//  CompletionCertificatePDF.swift
//  TrainingCamps
//
//  Created by Steven Lord on 03/07/2018.
//  Copyright © 2018 Steven Lord. All rights reserved.
//


import Foundation
import Quartz

class CompletionCertificatePDF: PDFPage{
    
    var headerText = "EverydayTraining Camp Completion Certificate"
    var footerText = "Default Footer Text"
    
    let pdfHeight = CGFloat(595.0) //This is configurable
    let pdfWidth = CGFloat(842.0)   //This is configurable and is calculated based on the number of columns
    let topMargin = CGFloat(40.0)
    let leftMargin = CGFloat(20.0)
    let rightMargin = CGFloat(20.0)
    let bottomMargin = CGFloat (40.0)
    let edtBlue = NSColor(calibratedRed: CGFloat(26.0 / 255.0), green: CGFloat(120.0 / 255.0), blue: CGFloat(184.0 / 255.0), alpha: CGFloat(1.0))
    let edtPink = NSColor(calibratedRed: CGFloat(229.0 / 255.0), green: CGFloat(42.0 / 255.0), blue: CGFloat(119.0 / 255.0), alpha: CGFloat(1.0))
    let backgroundGrey = NSColor(calibratedRed: CGFloat(229.0 / 255.0), green: CGFloat(229.0 / 255.0), blue: CGFloat(229.0 / 255.0), alpha: CGFloat(1.0))
    let borderLineWidth = CGFloat(2.0)
    let footerFont = NSFont(name: "Helvetica", size: 12.0)
    let headerFont = NSFont(name: "Helvetica", size: 12.0)
    let titleFont = NSFont(name: "Helvetica", size: 20.0)
    let subTitleFont = NSFont(name: "Helvetica", size: 17.0)
    let descriptionFont = NSFont(name: "Helvetica", size: 15.0)


    
    var campParticipant: CampParticipant
    
    
    func drawHeader(){
        
        let headerParagraphStyle = NSMutableParagraphStyle()
        headerParagraphStyle.alignment = .right
        
        let headerFontAttributes = [
            NSAttributedStringKey.font: headerFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:headerParagraphStyle,
            NSAttributedStringKey.foregroundColor:NSColor.lightGray
        ]
        let headerRect = NSMakeRect(leftMargin, pdfHeight - topMargin * 0.9, pdfWidth - leftMargin - rightMargin, topMargin * 0.5)
        print(headerRect)
        self.headerText.draw(in: headerRect, withAttributes: headerFontAttributes)
        
    }
    
    func drawFooter(){
        
        
        let footerParagraphStyle = NSMutableParagraphStyle()
        footerParagraphStyle.alignment = .right
        
        let footerFontAttributes = [
            NSAttributedStringKey.font: footerFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:footerParagraphStyle,
            NSAttributedStringKey.foregroundColor:NSColor.lightGray
        ]
        
        let footerRect = NSMakeRect(leftMargin, bottomMargin * 0.4, pdfWidth - leftMargin - rightMargin, bottomMargin * 0.5)
        footerText.draw(in: footerRect, withAttributes: footerFontAttributes)
        
    }
    
    func drawMargins(){
        let borderLine = NSMakeRect(leftMargin, bottomMargin, self.pdfWidth - leftMargin - rightMargin, self.pdfHeight - topMargin - bottomMargin)
        let innerLine = NSMakeRect(borderLine.minX + 2 * borderLineWidth, borderLine.minY + 2 * borderLineWidth, borderLine.width - (4.0 * borderLineWidth), borderLine.height - (4.0 * borderLineWidth))
        
        
        let path: NSBezierPath = NSBezierPath.init(rect: borderLine)
        path.lineWidth = borderLineWidth
    
        edtBlue.set()
        path.stroke()
        
        let innerPath: NSBezierPath = NSBezierPath(rect: innerLine)
        innerPath.lineWidth = borderLineWidth
        edtPink.set()
        innerPath.stroke()
        backgroundGrey.setFill()
        

        innerPath.fill()
        
    }
    
    func drawTitle(){
        let titleRect = titleRectangle()
        let titleText = campParticipant.participant?.displayName ?? "NOT SET"
        let campText = campParticipant.camp?.campName ?? "NOT SET"
        
        drawAndFillStandard(rect: titleRect)
        
        if let url = Bundle.main.url(forResource: "et_final_Transparent", withExtension: "jpg"){
            if let logo = NSImage(contentsOf: url){
                let logoRect = NSMakeRect(titleRect.minX + titleRect.width * 0.5 + 1.0, titleRect.minY + 1.0, titleRect.width * 0.5 - 2.0, titleRect.height - 2.0)
                logo.draw(in: logoRect)
            }
        }
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .left
        
        let titleFontAttributes = [
            NSAttributedStringKey.font: titleFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:titleParagraphStyle,
            NSAttributedStringKey.foregroundColor:NSColor.darkGray
        ]
        
        let nameRect = NSMakeRect(titleRect.minX + 5.0, titleRect.minY + titleRect.height * 0.5 - 5.0, titleRect.width * 0.6, titleRect.height * 0.35)
        titleText.draw(in: nameRect, withAttributes: titleFontAttributes)
        
        let subTitleFontAttributes = [
            NSAttributedStringKey.font: subTitleFont ?? NSFont.labelFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle:titleParagraphStyle,
            NSAttributedStringKey.foregroundColor:NSColor.darkGray
        ]
        
        let campRect = NSMakeRect(nameRect.minX, titleRect.minY + titleRect.height * 0.2, nameRect.width, nameRect.height)
        campText.draw(in: campRect, withAttributes: subTitleFontAttributes)
    
    }
    
    func drawDescription(){
        let rect = descriptionRectangle()
        let text = "Congratulations on completing an EverydayTraining training camp. Here are how your camp totals ranked:"
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        text.draw(in: rect, withAttributes: [
                NSAttributedStringKey.font: descriptionFont ?? NSFont.labelFont(ofSize: 12),
                NSAttributedStringKey.paragraphStyle:titleParagraphStyle,
                NSAttributedStringKey.foregroundColor:NSColor.darkGray
                ])
        
    }

    
    override func bounds(for box: PDFDisplayBox) -> NSRect
    {
        return NSMakeRect(0, 0, pdfWidth, pdfHeight)
    }
    
    override func draw(with box: PDFDisplayBox) {
        drawMargins()
        drawHeader()
        drawFooter()
        drawTitle()
        drawDescription()
    }
    
    init(_ cp: CampParticipant){
        campParticipant = cp
        
        if let camp = cp.camp{
            footerText = camp.campName!
            let df = DateFormatter()
            df.dateFormat = "dd-MMM-yy"
            footerText += " ("
            footerText += df.string(from: camp.campStart!)
            footerText += " --> "
            footerText += df.string(from: camp.campEnd!)
            footerText += ")"
            
        }
        super.init()
        
    }
    
    private func drawAndFillStandard(rect: NSRect){
        var path = NSBezierPath(rect: rect)
        NSColor.white.setFill()
        path.fill()
        

        path = NSBezierPath()
        path.move(to: NSPoint(x: rect.minX, y: rect.minY))
        path.line(to: NSPoint(x: rect.maxX, y: rect.minY))
        path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        NSColor.darkGray.setStroke()
        path.stroke()
        
        path = NSBezierPath()
        path.move(to: NSPoint(x: rect.minX, y: rect.minY))
        path.line(to: NSPoint(x: rect.minX, y: rect.maxY))
        path.line(to: NSPoint(x: rect.maxX, y: rect.maxY))
        NSColor.lightGray.setStroke()
        path.stroke()
    }
    
    private func titleRectangle() -> NSRect{
        let width = CGFloat(pdfWidth * 0.45)
        let height = CGFloat(width * 0.25)
        let x = rightMargin + (borderLineWidth * 5.0)
        let y = pdfHeight - (topMargin + (borderLineWidth * 5.0) + height)
        return NSRect(x: x, y: y, width: width, height: height)
    
    }
    
    private func descriptionRectangle() -> NSRect{
        let tr = titleRectangle()
        let width = tr.width * 0.75
        let height = tr.height * 0.75
        let x = tr.minX + tr.width * 0.25 / 2.0
        let y = tr.minY - (height + 5.0)
        return NSRect(x: x, y: y, width: width, height: height)
    }
    

    
}
