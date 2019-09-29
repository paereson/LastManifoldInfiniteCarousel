//
//  LMInfiniteCarousel.swift
//  LMInfiniteCarousel
//
//  Created by Grzegorz Kurnatowski on 29/09/2019.
//  Copyright © 2019 Grzegorz Kurnatowski. All rights reserved.
//

import UIKit

public protocol LMInfiniteCarouselDelegate: class {
    func pageChanged()
}

enum SlideDirection {
    case left
    case right
    case center
}

@IBDesignable public class LMInfiniteCarousel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var widthPercent: Float = 70.0
    @IBInspectable var heightPercent: Float = 70.0
    @IBInspectable var sideViewPercentSize: Float = 70.0
    @IBInspectable var slidesOffset: Float = 10.0
    
    public weak var delegate: LMInfiniteCarouselDelegate?
    
    var currentSlide = 0
    var slidesEndIndex = 0
    
    public var slides: [UIView] = [] {
        didSet {
            setup()
        }
    }
    
    var firstSlideWidth = CGFloat(0)
    var firstSlideHeight = CGFloat(0)
    var sideSlideWidth = CGFloat(0)
    var sideSlideHeight = CGFloat(0)
    
    var firstSlidePositionX = CGFloat(0)
    var firstSlidePositionY = CGFloat(0)
    
    var firstSideSlidePositionX = CGFloat(0)
    var sideSlidePositionY = CGFloat(0)
    
    var secondSideSlidePositionX = CGFloat(0)
    
    var touchesStartPosition = CGFloat(0)
    
    var slideDirection: SlideDirection = .left
    
    private func setup() {
        slidesEndIndex = slides.count - 1
        
        widthPercent /= 100
        heightPercent /= 100
        sideViewPercentSize /= 100
        
        
        firstLoadSlides()
    }
    
    private func addGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        addGestureRecognizer(gestureRecognizer)
    }
    
    private func firstLoadSlides() {

        guard let firstSlide = slides[exist: 0],
            let secondSlide = slides[exist: 1],
            let thirdSlide = slides[exist: 2] else {
                return
        }
        
        firstSlideWidth = frame.width * CGFloat(widthPercent)
        firstSlideHeight = frame.height * CGFloat(heightPercent)
        sideSlideWidth = firstSlideWidth * CGFloat(sideViewPercentSize)
        sideSlideHeight = firstSlideHeight * CGFloat(sideViewPercentSize)
        
        firstSlidePositionX = (frame.width - firstSlideWidth) / 2
        firstSlidePositionY = (frame.height - firstSlideHeight) / 2
        
        firstSlide.frame = CGRect(x: firstSlidePositionX, y: firstSlidePositionY, width: firstSlideWidth, height: firstSlideHeight)
        firstSlide.accessibilityIdentifier = "firstSlide"
        addSubview(firstSlide)
        
        sideSlidePositionY = (frame.height - sideSlideHeight) / 2
        
        firstSideSlidePositionX = firstSlide.frame.maxX + CGFloat(slidesOffset)
        secondSlide.frame = CGRect(x: firstSideSlidePositionX, y: sideSlidePositionY, width: sideSlideWidth, height: sideSlideHeight)
        secondSlide.accessibilityIdentifier = "secondSlide"
        addSubview(secondSlide)
        
        secondSideSlidePositionX = -sideSlideWidth + (firstSlide.frame.origin.x - CGFloat(slidesOffset))
        
        thirdSlide.frame = CGRect(x: secondSideSlidePositionX, y: sideSlidePositionY, width: sideSlideWidth, height: sideSlideHeight)
        thirdSlide.accessibilityIdentifier = "thirdSlide"
        addSubview(thirdSlide)
    }
    
    public func getSlidesCount() -> Int {
        return self.slidesEndIndex + 1
    }
    
    public func getCurrentSlideIndex() -> Int {
        return self.currentSlide
    }
}
