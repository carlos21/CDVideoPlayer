//
//  AppDelegate.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/13/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBAction func openDocument(_ sender: Any) {
        openVideo()
    }
    
    func openVideo() {
        let panel = NSOpenPanel()
        panel.title = "Choose a .MP4 file"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["mp4"]
        
        guard panel.runModal() == NSApplication.ModalResponse.OK else { return }
        guard let url = panel.url else { return }
        NotificationCenter.default.post(name: selectedVideoNotification, object: nil, userInfo: ["url": url])
    }
    
    func openSRT() {
        let panel = NSOpenPanel()
        panel.title = "Choose a .SRT file"
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["srt"]
        
        guard panel.runModal() == NSApplication.ModalResponse.OK else { return }
        guard let url = panel.url else { return }
        NotificationCenter.default.post(name: selectedSubtitlesNotification, object: nil, userInfo: ["url": url])
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

