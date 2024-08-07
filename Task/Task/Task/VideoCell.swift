//
//  VideoCell.swift
//  Task
//
//  Created by  on 04/08/24.
//

import UIKit
import AVKit

class VideoCell: UICollectionViewCell {
    let thumbnailImageView = UIImageView()
    var playerLayer = AVPlayerLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.frame = contentView.bounds
        contentView.addSubview(thumbnailImageView)

        playerLayer.frame = contentView.bounds
        contentView.layer.addSublayer(playerLayer)
    }

}

