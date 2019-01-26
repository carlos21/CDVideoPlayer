//
//  Date.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/18/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation

extension Date {
    
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    mutating func add(milliseconds: Int) {
         self = Date(milliseconds: self.millisecondsSince1970 + milliseconds)
    }
}
