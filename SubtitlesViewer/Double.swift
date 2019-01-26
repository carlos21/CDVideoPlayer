//
//  Double.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/23/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation

extension Double {
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
