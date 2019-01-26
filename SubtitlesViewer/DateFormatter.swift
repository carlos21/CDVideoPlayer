//
//  DateFormatter.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/18/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    public static let `default`: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss,SSS"
        formatter.locale = Locale.current
        return formatter
    }()
}
