//
//  ViewController.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/13/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class ViewController: NSViewController {
    
//    // MARK: - IBOutlets
//
//    @IBOutlet weak var subtitleLabel: NSTextField!
//
//    // MARK: - Properties
//
//    var direction: Direction = .forward
//    var readerState: ReaderState = .number
//    var number = 0
//    var text = ""
//    var time = ""
//
//    var subtitles = [Subtitle]()
//    var startDate: Date?
//    let displayLink = DisplayLink()
//    var currentSubtitleIndex = 0
//
//    // MARK: - Life cycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.layer?.backgroundColor = NSColor.darkGray.cgColor
//        subtitleLabel.backgroundColor = NSColor.darkGray
//        subtitleLabel.isEditable = false
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handleSelectedFile(notification:)),
//                                               name: selectedSubtitlesNotification,
//                                               object: nil)
//
//        // Test
//        let pathSRT = Bundle.main.path(forResource: "infinity-war", ofType: "srt") ?? ""
//        let url = URL(fileURLWithPath: pathSRT)
//        let result = processSubtitles(url: url)
//
//        switch result {
//        case .success(let subtitles):
//            self.subtitles = subtitles
//
//        default:
//            print("Couldn't read subtitles")
//        }
//
//        start()
//    }
//
//    override func viewDidAppear() {
//        super.viewDidAppear()
//        guard let window = view.window as? SVWindow else { return }
//        window.windowDelegate = self
//        view.window?.makeFirstResponder(self)
//    }
//
//    override var representedObject: Any? {
//        didSet {
//
//        }
//    }
//
//    // MARK: - Methods
//
//    func start() {
//        startDate = Date()
//        displayLink?.delegate = self
//        displayLink?.start()
//    }
//
//    @objc func handleSelectedFile(notification: Notification) {
//        guard let userInfo = notification.userInfo else { return }
//        guard let url = userInfo["url"] as? URL else { return }
//
//        let result = processSubtitles(url: url)
//        switch result {
//        case .success(let subtitles):
//            self.subtitles = subtitles
//
//        default:
//            print("Couldn't read subtitles")
//        }
//    }
//
//    @discardableResult
//    func processSubtitles(url: URL) -> Result<[Subtitle]> {
//
//        var subtitles = [Subtitle]()
//        let reader = StreamReader(url: url)
//        while let line = reader?.nextLine() {
//            switch readerState {
//            case .number:
//                number = Int(line.trimmed) ?? 0
//                text = ""
//                readerState = .time
//
//            case .time:
//                time = line.trimmed
//                readerState = .text
//
//            case .text:
//                guard line.trimmed == "" else {
//                    text = text + "\n" + line
//                    continue
//                }
//
//                let times = time.components(separatedBy: "-->")
//
//                // start time
//                guard let startDate = DateFormatter.default.date(from: times[0].trimmed) else { return .error }
//                let startDateNoTime = startDate.stripTime()
//                let startDateDiference = startDate.timeIntervalSince(startDateNoTime)
//
//
//                // end time
//                guard let endDate = DateFormatter.default.date(from: times[1].trimmed) else { return .error }
//                let endDateNoTime = endDate.stripTime()
//                let endDateDiference = endDate.timeIntervalSince(endDateNoTime)
//
//                let subtitle = Subtitle(number: number,
//                                        text: text,
//                                        time: time,
//                                        startMilliseconds: Int(round(startDateDiference * 1000)),
//                                        endMilliseconds: Int(round(endDateDiference * 1000)))
//                subtitles.append(subtitle)
//
//                readerState = .number
//            }
//        }
//
//        return .success(subtitles)
//    }
//
//    func handleSubtitle(range: StrideTo<Int>, difference: Int) -> Subtitle? {
//        var foundSubtitle: Subtitle?
//        for index in range {
//            let subtitle = subtitles[index]
//            if subtitle.startMilliseconds < difference && difference < subtitle.endMilliseconds {
//                foundSubtitle = subtitle
//                currentSubtitleIndex = index
//                subtitleLabel.isHidden = false
//                break
//            }
//        }
//        return foundSubtitle
//    }
//
//    func findSubtitle(difference: Int) -> Subtitle? {
//        var foundSubtitle: Subtitle?
//        for index in 0..<subtitles.count {
//            let subtitle = subtitles[index]
//            if subtitle.startMilliseconds < difference && difference < subtitle.endMilliseconds {
//                foundSubtitle = subtitle
//                currentSubtitleIndex = index
//                subtitleLabel.isHidden = false
//                break
//            }
//        }
//        return foundSubtitle
//    }
}

//extension ViewController: SVWindowDelegate {
//    
//    func keyDownPressed(event: NSEvent) {
//        guard var startDate = self.startDate else { return }
//        
//        switch event.keyCode {
//        case 123:
//            direction = .backward
//            startDate.add(milliseconds: 500)
//            self.startDate = startDate
//            
//        case 124:
//            direction = .forward
//            startDate.add(milliseconds: -500)
//            self.startDate = startDate
//            
//        default:
//            break
//        }
//    }
//}
//
//extension ViewController: DisplayLinkerDelegate {
//    
//    func displayWillUpdate(with deltaTime: Int) {
//        guard let startDate = self.startDate else { return }
//        
//        let currentDate = Date()
//        let millisecondsDifference = currentDate.millisecondsSince1970 - startDate.millisecondsSince1970
//        var foundSubtitle = findSubtitle(difference: millisecondsDifference)
//        
////        switch direction {
////        case .backward:
////            foundSubtitle = handleSubtitle(range: stride(from: currentSubtitleIndex, to: 0, by: -1), difference: millisecondsDifference)
////
////        case .forward:
////            foundSubtitle = handleSubtitle(range: stride(from: currentSubtitleIndex, to: subtitles.count-1, by: 1), difference: millisecondsDifference)
////        }
//
//        guard let currentSubtitle = foundSubtitle else {
////            subtitleLabel.isHidden = true
//            return
//        }
//
//        print("")
//        subtitleLabel.attributedStringValue = currentSubtitle.text.convertHtml()
//    }
//}
