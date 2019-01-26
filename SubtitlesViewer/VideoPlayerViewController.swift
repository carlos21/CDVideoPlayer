//
//  VideoPlayerViewController.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/25/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation


class VideoPlayerViewController: NSViewController {
    
    private struct Settings {
        static let roundPlace: Int = 1
        static let timerInterval: TimeInterval = 0.1
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var actionButton: NSButton!
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var progressSlider: NSSlider!
    @IBOutlet weak var timelineLabel: NSTextField!
    @IBOutlet weak var subtitleLabel: NSTextField!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    // MARK: - Properties
    
    private var timer: Timer?
    
    var direction: Direction = .forward
    var readerState: ReaderState = .number
    var number = 0
    var text = ""
    var time = ""
    
    var subtitles = [Subtitle]()
    var startDate: Date?
    let displayLink = DisplayLink()
    var currentSubtitleIndex = 0
    var showControls: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTimer()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleVideoFile(notification:)),
                                               name: selectedVideoNotification,
                                               object: nil)
    }
    
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let window = view.window as? SVWindow else { return }
        window.windowDelegate = self
        view.window?.makeFirstResponder(videoPlayerView)
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonClicked(_ sender: AnyObject?) {
        videoPlayerView.playPauseAction()
    }
    
    @IBAction func stopButtonClicked(_ sender: AnyObject?) {
        videoPlayerView.stopAction()
    }
    
    @IBAction func segmentedControlChangedValue(_ sender: NSSegmentedControl) {
        videoPlayerView.rate = rate(forSelectedSegment: sender.selectedSegment)
    }
    
    @IBAction func sliderChangedValue(_ sender: NSSlider) {
        videoPlayerView.volume = sender.floatValue
    }
}

// MARK: - Setup Methods

private extension VideoPlayerViewController {
    
    func startDisplayLink() {
        startDate = Date()
        displayLink?.delegate = self
        displayLink?.start()
    }
    
    func setupViews() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        subtitleLabel.backgroundColor = NSColor.black
        subtitleLabel.isEditable = false
        
        // setup sliders
        volumeSlider.minValue = 0
        volumeSlider.maxValue = 1
        volumeSlider.bind(.value, to: videoPlayerView, withKeyPath: #keyPath(VideoPlayerView.volume), options: nil)
        
        progressSlider.minValue = 0
        progressSlider.maxValue = 1
        progressSlider.bind(.value, to: videoPlayerView, withKeyPath: #keyPath(VideoPlayerView.progress), options: nil)
        
        // setup action button image
        actionButton.bind(.image, to: videoPlayerView, withKeyPath: #keyPath(VideoPlayerView.isPlaying), options: [.valueTransformer: ActionButtonImageValueTransformer()])
        
        // setup timeline label
        updateTimelineLabel()
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: Settings.timerInterval,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func handleVideoFile(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard var url = userInfo["url"] as? URL else { return }
        let videoUrl = url
        
        url.deletePathExtension()
        let subtitleFilename = url.lastPathComponent + ".srt"
        let subtitleURL = url.deletingLastPathComponent().appendingPathComponent(subtitleFilename)
        let result = processSubtitles(url: subtitleURL)
        
        switch result {
        case .success(let subtitles):
            self.subtitles = subtitles
            
        default:
            print("Couldn't read subtitles")
        }
        
        videoPlayerView.playVideo(url: videoUrl)
        startDisplayLink()
    }
    
    @discardableResult
    func processSubtitles(url: URL) -> Result<[Subtitle]> {
        
        var subtitles = [Subtitle]()
        let reader = StreamReader(url: url)
        while let line = reader?.nextLine() {
            switch readerState {
            case .number:
                number = Int(line.trimmed) ?? 0
                text = ""
                readerState = .time
                
            case .time:
                time = line.trimmed
                readerState = .text
                
            case .text:
                guard line.trimmed == "" else {
                    text = text + "\n" + line
                    continue
                }
                
                let times = time.components(separatedBy: "-->")
                
                // start time
                guard let startDate = DateFormatter.default.date(from: times[0].trimmed) else { return .error }
                let startDateNoTime = startDate.stripTime()
                let startDateDiference = startDate.timeIntervalSince(startDateNoTime)
                
                
                // end time
                guard let endDate = DateFormatter.default.date(from: times[1].trimmed) else { return .error }
                let endDateNoTime = endDate.stripTime()
                let endDateDiference = endDate.timeIntervalSince(endDateNoTime)
                
                let subtitle = Subtitle(number: number,
                                        text: text,
                                        time: time,
                                        startMilliseconds: Int(round(startDateDiference * 1000)),
                                        endMilliseconds: Int(round(endDateDiference * 1000)))
                subtitles.append(subtitle)
                
                readerState = .number
            }
        }
        
        return .success(subtitles)
    }
    
    func findSubtitle(difference: Int) -> Subtitle? {
        var foundSubtitle: Subtitle?
        for index in 0..<subtitles.count {
            let subtitle = subtitles[index]
            if subtitle.startMilliseconds < difference && difference < subtitle.endMilliseconds {
                foundSubtitle = subtitle
                currentSubtitleIndex = index
                subtitleLabel.isHidden = false
                break
            }
        }
        return foundSubtitle
    }
}

// MARK: - Update Methods
private extension VideoPlayerViewController {
    
    @objc func updateTimer() {
        updateTimelineLabel()
        updateProgressSlider()
    }
    
    func updateTimelineLabel() {
        let totalTime = videoPlayerView.totalDuration.rounded(toPlaces: Settings.roundPlace)
        let currentTime = videoPlayerView.currentDuration.rounded(toPlaces: Settings.roundPlace)
        timelineLabel.stringValue = "\(currentTime) / \(totalTime)"
    }
    
    func updateProgressSlider() {
        progressSlider.doubleValue = videoPlayerView.progress
    }
}

// MARK: - Private Methods

private extension VideoPlayerViewController {
    
    func rate(forSelectedSegment selectedSegment: Int) -> Float {
        let defaultRate: Float = 1
        
        switch selectedSegment {
        case 0: return 0.5
        case 1: return defaultRate
        case 2: return 2
        default: return defaultRate
        }
    }
}

extension VideoPlayerViewController: SVWindowDelegate {
    
    func keyDownPressed(event: NSEvent) {
//        print(event.keyCode)
        switch event.keyCode {
        case 123:
            guard var startDate = self.startDate else { return }
            direction = .backward
            startDate.add(milliseconds: 500)
            self.startDate = startDate
            
        case 124:
            guard var startDate = self.startDate else { return }
            direction = .forward
            startDate.add(milliseconds: -500)
            self.startDate = startDate
            
        case 1:
            showControls = !showControls
            
            actionButton.isHidden = !showControls
            progressSlider.isHidden = !showControls
            timelineLabel.isHidden = !showControls
            volumeSlider.isHidden = !showControls
            
        default:
            break
        }
    }
}

extension VideoPlayerViewController: DisplayLinkerDelegate {
    
    func displayWillUpdate(with deltaTime: Int) {
        guard let startDate = self.startDate else { return }
        
        let currentDate = Date()
        let millisecondsDifference = currentDate.millisecondsSince1970 - startDate.millisecondsSince1970
        var foundSubtitle = findSubtitle(difference: millisecondsDifference)
        
        //        switch direction {
        //        case .backward:
        //            foundSubtitle = handleSubtitle(range: stride(from: currentSubtitleIndex, to: 0, by: -1), difference: millisecondsDifference)
        //
        //        case .forward:
        //            foundSubtitle = handleSubtitle(range: stride(from: currentSubtitleIndex, to: subtitles.count-1, by: 1), difference: millisecondsDifference)
        //        }
        
        guard let currentSubtitle = foundSubtitle else {
            //            subtitleLabel.isHidden = true
            return
        }
        
        print("")
        subtitleLabel.attributedStringValue = currentSubtitle.text.convertHtml()
    }
}

// MARK: - Transformers
final class ActionButtonImageValueTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let isPlaying = value as? Bool else { return nil }
        let image: NSImage = isPlaying ? NSImage(named: "pause")! : NSImage(named: "play-button")!
        return image
    }
}

// MARK: - Extensions
extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

enum ReaderState {
    case number
    case time
    case text
}

enum Direction {
    case forward
    case backward
}

enum Result<T> {
    case success(T)
    case error
}
