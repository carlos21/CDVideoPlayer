//
//  VideoPlayerView.swift
//  SubtitlesViewer
//
//  Created by Carlos Duclos on 1/25/19.
//  Copyright © 2019 Carlos Duclos. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

final class VideoPlayerView: NSView {
    
    private struct Settings {
        static let defaultRate: Float = 1
        static let defaultVolume: Float = 1
        static let defaultProgress: Float = 0
        
        static let shadowRadius: CGFloat = 0
        static let shadowOpacity: Float = 1.0
        static let shadowOffset: CGSize = CGSize(width: 5, height: -5)
        
        static let cornerRadius: CGFloat = 0
        static let borderWidth: CGFloat = 0
        static let borderColor: NSColor = .black
    }
    
    // MARK: - Private Properties
    private let rootLayer = CALayer()
    private let shadowLayer = CALayer()
    private let playerLayer = AVPlayerLayer()
    
    private var player: AVPlayer? {
        return playerLayer.player
    }
    
    // MARK: - Public Properties
    @objc dynamic var isPlaying: Bool = false
    
    @objc dynamic var currentDuration: Double {
        guard let player = self.player else { return 0 }
        return CMTimeGetSeconds(player.currentTime())
    }
    
    @objc dynamic var totalDuration: Double {
        guard let player = self.player else { return 0 }
        return CMTimeGetSeconds(player.currentItem?.asset.duration ?? .zero)
    }
    
    @objc dynamic var progress: Double {
        get {
            return currentDuration / totalDuration
        }
        set {
            isPlaying = false
            player?.pause()
            
            let seconds = newValue * totalDuration
            player?.seek(to: CMTime(seconds: seconds, preferredTimescale: 600))
        }
    }
    @objc dynamic var volume: Float {
        get {
            return player?.volume ?? 100
        }
        set {
            player?.volume = newValue
        }
    }
    
    var rate: Float = Settings.defaultRate {
        didSet { updateRate() }
    }
    
    // MARK: - Initializers
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
    
    private func commonInit() {
        wantsLayer = true
        layer = rootLayer
        
        setupRootLayer()
        setupShadowLayer()
        setupPlayerLayer()
        
        rootLayer.addSublayer(shadowLayer)
        shadowLayer.addSublayer(playerLayer)
    }
    
    // MARK: - Actions
    func playPauseAction() {
        _ = isPlaying ? player?.pause() : playWithCurrentRate()
        isPlaying = !isPlaying
    }
    
    func stopAction() {
        isPlaying = false
        
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
}

// MARK: - Setup Layer
private extension VideoPlayerView {
    
    func setupRootLayer() {
        rootLayer.masksToBounds = false
    }
    
    func setupShadowLayer() {
        shadowLayer.frame = bounds
        shadowLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        shadowLayer.shadowRadius = Settings.shadowRadius
        shadowLayer.shadowOpacity = Settings.shadowOpacity
        shadowLayer.shadowOffset = Settings.shadowOffset
    }
    
    func setupPlayerLayer() {
        playerLayer.frame = bounds
        playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        playerLayer.cornerRadius = Settings.cornerRadius
        playerLayer.masksToBounds = true
        playerLayer.borderWidth = Settings.borderWidth
        playerLayer.borderColor = Settings.borderColor.cgColor
        playerLayer.videoGravity = .resizeAspect
    }
}

extension VideoPlayerView {
    
    func playVideo(url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        
        player.play()
        
        // setup video loop
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            self.playWithCurrentRate()
        }
    }
    
    func playWithCurrentRate() {
        player?.play()
        updateRate()
    }
    
    func updateRate() {
        player?.rate = rate
    }
}
