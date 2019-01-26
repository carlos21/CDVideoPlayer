//
//  TransparentWindowController.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/13/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation
import Cocoa

class TransparentWindowController: NSWindowController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
//        window?.backgroundColor = NSColor.clear
//        window?.isOpaque = false
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
