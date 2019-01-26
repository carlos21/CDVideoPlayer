//
//  SVWindow.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/13/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation
import Cocoa

protocol SVWindowDelegate: class {
    
    func keyDownPressed(event: NSEvent)
}

class SVWindow: NSWindow {
    
    weak var windowDelegate: SVWindowDelegate?
    
    override var acceptsFirstResponder: Bool { return true }
    
    override init(contentRect: NSRect,
                  styleMask style: NSWindow.StyleMask,
                  backing backingStoreType: NSWindow.BackingStoreType,
                  defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
//        isOpaque = false
//        hasShadow = false
//        backgroundColor = .clear
    }
    
    override func keyDown(with event: NSEvent) {
        windowDelegate?.keyDownPressed(event: event)
    }
}
