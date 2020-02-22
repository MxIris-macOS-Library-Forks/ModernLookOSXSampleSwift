//
//  MLCalendarCell.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 20/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLCalendarCell: NSButton {
    
    var owner: MLCalendarView?
    var col = -1
    var row = -1
    
    var _representedDate: Date?
    var representedDate : Date? {
        get { return _representedDate }
        set {
            self._representedDate = newValue
            guard newValue != nil else  {
                self.title = ""
                return }
            
            var calendar = Calendar.current
            if let time = TimeZone(abbreviation: "UTC") {
                calendar.timeZone = time as TimeZone
            }
            let unitFlags: Set<Calendar.Component> = [.day]
            let components = calendar.dateComponents(unitFlags, from: newValue!)
            let day = components.day!
            self.title = String(format: "%ld", day)
        }
    }
    
    var _isSelected = false
    var isSelected : Bool {
        get { return _isSelected}
        set {
            self._isSelected = newValue
            needsDisplay = true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        isBordered = false
        representedDate = nil
    }
    
    func isToday() -> Bool {
        guard representedDate != nil else  { return false }
        return MLCalendarView.shared.isSameDate(representedDate, date: Date())
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        
        let bounds = self.bounds
        owner!.backgroundColor.set()
//        NSColor.white.set()
        bounds.fill()
        
        if representedDate != nil {
            //selection
            if isSelected == true {
                var circeRect = bounds.insetBy(dx: 3.5, dy: 3.5)
                circeRect.origin.y += 1
                let bzc = NSBezierPath(ovalIn: circeRect)
                owner?.selectionColor.set()
                bzc.fill()
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        //title
        let attrs : [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font!,
            .foregroundColor: owner?.textColor ?? .labelColor
        ]
        
        let size = title.size(withAttributes: attrs)
        let r = CGRect(x: bounds.origin.x,
                       y: bounds.origin.y + ((bounds.size.height - size.height) / 2.0) - 1,
                       width: bounds.size.width,
                       height: size.height)
        
        self.title.draw(in: r, withAttributes: attrs)
        
        //line
        let topLine = NSBezierPath()
        topLine.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        topLine.line(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        owner?.dayMarkerColor.set()
        topLine.lineWidth = 0.3
        topLine.stroke()
        if isToday() {
            owner?.todayMarkerColor.set()
            let bottomLine = NSBezierPath()
            bottomLine.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            bottomLine.line(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            bottomLine.lineWidth = 4.0
            bottomLine.stroke()
        }
        
        NSGraphicsContext.restoreGraphicsState()
    }

}
