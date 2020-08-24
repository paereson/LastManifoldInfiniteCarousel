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
    
    var slideWidth: CGFloat = 0
    var slideHeight: CGFloat = 0
    
    var firstSlidePositionX: CGFloat = 0
    var firstSlidePositionY: CGFloat = 0
    
    var firstSideSlidePositionX: CGFloat = 0
    var sideSlidePositionY: CGFloat = 0
    
    var secondSideSlidePositionX: CGFloat = 0
    
    var touchesStartPosition: CGFloat = 0
    
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
        
        let (firstSlide, secondSlide, thirdSlide) = prepareSlides()
        
        slideWidth = frame.width * CGFloat(widthPercent)
        slideHeight = frame.height * CGFloat(heightPercent)
        
        firstSlidePositionX = (frame.width - slideWidth) / 2
        firstSlidePositionY = (frame.height - slideHeight) / 2
        
        firstSlide.frame = CGRect(x: firstSlidePositionX, y: firstSlidePositionY, width: slideWidth, height: slideHeight)
        firstSlide.accessibilityIdentifier = "firstSlide"
        addSubview(firstSlide)
        
        let percentHeight = slideHeight * CGFloat(sideViewPercentSize)
        sideSlidePositionY = (frame.height - percentHeight) / 2
        
        firstSideSlidePositionX = firstSlide.frame.maxX + CGFloat(slidesOffset)
        secondSlide.frame.size.width = slideWidth
        secondSlide.frame.size.height = slideHeight
        secondSlide.transform = CGAffineTransform(scaleX: CGFloat(sideViewPercentSize), y: CGFloat(sideViewPercentSize))
        secondSlide.frame.origin.x = firstSideSlidePositionX
        secondSlide.frame.origin.y = sideSlidePositionY
        secondSlide.accessibilityIdentifier = "secondSlide"
        addSubview(secondSlide)
        
        let percentWidth = slideWidth * CGFloat(sideViewPercentSize)
        secondSideSlidePositionX = -percentWidth + (firstSlide.frame.origin.x - CGFloat(slidesOffset))
        
        thirdSlide.frame.size.width = slideWidth
        thirdSlide.frame.size.height = slideHeight
        thirdSlide.transform = CGAffineTransform(scaleX: CGFloat(sideViewPercentSize), y: CGFloat(sideViewPercentSize))
        thirdSlide.frame.origin.x = secondSideSlidePositionX
        thirdSlide.frame.origin.y = sideSlidePositionY
        thirdSlide.accessibilityIdentifier = "thirdSlide"
        addSubview(thirdSlide)
    }
    
    private func prepareSlides() -> (UIView, UIView, UIView) {
        switch slides.count {
        case 0:
            return (UIView(), UIView(), UIView())
        case 1:
            return prepareOneSlide()
        case 2:
            return prepareTwoSlides()
        default:
            return prepareMoreSlides()
        }
    }
    
    private func prepareOneSlide() -> (UIView, UIView, UIView) {
        guard let firstSlide = slides.first,
            let secondSlide = try? slides.first?.copyObject() as? UIView,
            let thirdSlide = try? slides.first?.copyObject() as? UIView else {
                return (UIView(), UIView(), UIView())
        }
        return (firstSlide, secondSlide, thirdSlide)
    }
    
    private func prepareTwoSlides() -> (UIView, UIView, UIView) {
        guard let firstSlide = slides.first,
            let secondSlide = slides.last,
            let thirdSlide = try? slides.last?.copyObject() as? UIView  else {
                return (UIView(), UIView(), UIView())
        }
        return (firstSlide, secondSlide, thirdSlide)
    }
    
    private func prepareMoreSlides() -> (UIView, UIView, UIView) {
        guard let firstSlide = slides.first,
            let secondSlide = slides[exist: 1],
            let thirdSlide = slides.last else {
                return (UIView(), UIView(), UIView())
        }
        return (firstSlide, secondSlide, thirdSlide)
    }
    
    public func getSlidesCount() -> Int {
        return self.slidesEndIndex + 1
    }
    
    public func getCurrentSlideIndex() -> Int {
        return self.currentSlide
    }
}
