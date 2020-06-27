//
//  TutorialCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 27/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class InspirationCell: UICollectionViewCell {
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var imageCoverView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeAndRoomLabel: UILabel!
    @IBOutlet private weak var speakerLabel: UILabel!
  
  var inspiration: Inspiration? {
    didSet {
      if let inspiration = inspiration {
        imageView.image = inspiration.backgroundImage
        titleLabel.text = inspiration.title
        timeAndRoomLabel.text = inspiration.roomAndTime
        speakerLabel.text = inspiration.speaker
      }
    }
  }
  
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        let standarHeight = UltravisualLayoutConstants.Cell.standardHeight
        
        /*
         Vì height của cell thay đổi nên frame.height thay đổi
         standarHeight, featuredHeight is const
         delta phụ thuộc vào frame.height
         frame.height = {100, 280}
         featuredHeight - frame.height = {180, 0}
         featuredHeight - standarHeight = 180
         (featuredHeight - frame.height) / (featuredHeight - standarHeight) = {1, 0}
         delta = {0, 1}
         */
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standarHeight))
        
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        
        /*
         maxAlpha - minAlpha = 0.45
         delta * (maxAlpha - minAlpha) = { 0, 45 }
         maxAlpha - (delta * (maxAlpha - minAlpha)) = {0.75, 0.3}
         */
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        let scale = max(delta, 0.5)
        titleLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        timeAndRoomLabel.alpha = delta
        speakerLabel.alpha = delta
    }
}
