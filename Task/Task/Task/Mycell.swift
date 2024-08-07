//
//  Mycell.swift
//  Task
//
//  Created by on 04/08/24.
//

import UIKit
import AVKit

import UIKit
import AVKit

class MyCell: UICollectionViewCell {
    private var videos: [Arr] = []
    private var videoPlayers: [AVPlayer] = []
    
    private var playerViewController: AVPlayerViewController!
        private var player: AVPlayer!

    private var videoPlayerLayers: [AVPlayerLayer] = []
    private var currentVideoIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
 


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        for _ in 0..<4 {
            let player = AVPlayer()
            player.rate = 2.0
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            contentView.layer.addSublayer(playerLayer)
            videoPlayers.append(player)
            videoPlayerLayers.append(playerLayer)
        }
    }

   override func layoutSubviews() {
        super.layoutSubviews()
        let gridWidth = contentView.bounds.width / 2
        let gridHeight = contentView.bounds.height / 2
        for (index, layer) in videoPlayerLayers.enumerated() {
            let row = index / 2
            let col = index % 2
         layer.frame = CGRect(x: CGFloat(col) * gridWidth, y: CGFloat(row) * gridHeight, width: gridWidth, height: gridHeight)
        //  let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
           // flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
          // layer.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width / 2 - 120, height: 600)
           // let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            
        }
    }

    func configure(with reel: [Arr]) {
        videos = reel
        for (index, video) in videos.enumerated() {
            if let url = URL(string: video.thumbnail ?? "" ), index < videoPlayerLayers.count {
                let playerLayer = videoPlayerLayers[index]
                playerLayer.player?.replaceCurrentItem(with: nil)
                loadImage(from: url) { image in
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFill
                    imageView.frame = playerLayer.frame
                    self.contentView.addSubview(imageView)
                }
            }
        }
        currentVideoIndex = 0
    }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(UIImage(named: "placeholder"))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(UIImage(named: "placeholder"))
                }
            }
        }
    }

    func startPlayback() {
        playNextVideo()
    }

    private func playNextVideo() {
        guard currentVideoIndex < videos.count else { return }
        let video = videos[currentVideoIndex]
        guard let url = URL(string: video.video ?? "" ) else { return }
        let player = videoPlayers[currentVideoIndex]
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        player.seek(to: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    @objc private func playerDidFinishPlaying() {
        currentVideoIndex += 1
        if currentVideoIndex < videos.count {
            playNextVideo()
        } else {
            currentVideoIndex = 0
        }
    }

    func stopPlayback() {
        videoPlayers.forEach { $0.pause() }
        NotificationCenter.default.removeObserver(self)
    }
}
