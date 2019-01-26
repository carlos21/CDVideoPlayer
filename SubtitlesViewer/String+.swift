//
//  String+.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/14/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation

extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
