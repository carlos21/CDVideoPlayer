//
//  Collection.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/21/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
