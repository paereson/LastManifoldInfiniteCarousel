//
//  LMInfiniteCarouselMoveViews.swift
//  LMInfiniteCarouselMoveViews
//
//  Created by Grzegorz Kurnatowski on 29/09/2019.
//  Copyright © 2019 Grzegorz Kurnatowski. All rights reserved.
//

import UIKit

extension LMInfiniteCarousel {
    func slideToLeft(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        
        if self.currentSlide >= self.slidesEndIndex {
            self.currentSlide = 0
        } else {
            self.currentSlide += 1
        }

        let newSlideIndex = self.currentSlide + 1
        
        let newSlide: UIView
        
        if slides.count < 3, currentSlide % 2 != 0, let fourthSlide = try? slides.first?.copyObject() as? UIView {
            newSlide = fourthSlide
        } else if slides.count < 3, let fourthSlide = try? slides.last?.copyObject() as? UIView {
            newSlide = fourthSlide
        } else if let fourthSlide = slides[exist: newSlideIndex] {
            newSlide = fourthSlide
        } else if let fourtSlide = slides.first {
            newSlide = fourtSlide
        } else {
            return
        }
                
        newSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        newSlide.frame.size.width = slideWidth
        newSlide.frame.size.height = slideHeight
        newSlide.transform = CGAffineTransform(scaleX: CGFloat(sideViewPercentSize), y: CGFloat(sideViewPercentSize))
        newSlide.frame.origin.x = secondSlide.frame.maxX + CGFloat(slidesOffset * 3)
        newSlide.frame.origin.y = sideSlidePositionY
        
        newSlide.accessibilityIdentifier = "newSlide"
        
        self.addSubview(newSlide)
        
        UIView.animate(withDuration: 0.7, animations: {
            secondSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            secondSlide.frame.origin.x = self.firstSlidePositionX
            secondSlide.frame.origin.y = self.firstSlidePositionY
            
            firstSlide.transform = CGAffineTransform(scaleX: CGFloat(self.sideViewPercentSize), y: CGFloat(self.sideViewPercentSize))
            firstSlide.frame.origin.y = self.sideSlidePositionY
            firstSlide.frame.origin.x = self.secondSideSlidePositionX
                
            newSlide.frame.origin.y = self.sideSlidePositionY
            newSlide.frame.origin.x = self.firstSideSlidePositionX
        })
        
        updateSlide(direction: .left)
        
        delegate?.pageChanged()
    }
    
    func slideToRight(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        
        if self.currentSlide == 0 {
            self.currentSlide = slidesEndIndex
        } else {
            self.currentSlide -= 1
        }
        
        let newSlideIndex = self.currentSlide - 1
        
        let newSlide: UIView
        
        if slides.count < 3, currentSlide % 2 == 0, let fourthSlide = try? slides.last?.copyObject() as? UIView {
            newSlide = fourthSlide
        } else if slides.count < 3, let fourthSlide = try? slides.first?.copyObject() as? UIView {
            newSlide = fourthSlide
        } else if let fourthSlide = slides[exist: newSlideIndex] {
            newSlide = fourthSlide
        } else if let fourthSlide = slides.last {
            newSlide = fourthSlide
        } else {
            return
        }
        
        newSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        newSlide.frame.size.width = slideWidth
        newSlide.frame.size.height = slideHeight
        newSlide.transform = CGAffineTransform(scaleX: CGFloat(sideViewPercentSize), y: CGFloat(sideViewPercentSize))
        newSlide.frame.origin.x = thirdSlide.frame.minX - CGFloat(self.slidesOffset) - thirdSlide.frame.width
        newSlide.frame.origin.y = self.sideSlidePositionY
        
        newSlide.accessibilityIdentifier = "newSlide"
        
        self.addSubview(newSlide)
        
        UIView.animate(withDuration: 0.7, animations: {
            thirdSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            thirdSlide.frame.origin.x = self.firstSlidePositionX
            thirdSlide.frame.origin.y = self.firstSlidePositionY
            
            firstSlide.transform = CGAffineTransform(scaleX: CGFloat(self.sideViewPercentSize), y: CGFloat(self.sideViewPercentSize))
            firstSlide.frame.origin.y = self.sideSlidePositionY
            firstSlide.frame.origin.x = self.firstSideSlidePositionX
            
            newSlide.frame.origin.y = self.sideSlidePositionY
            newSlide.frame.origin.x = self.secondSideSlidePositionX
        })
        
        updateSlide(direction: .right)
        
        delegate?.pageChanged()
    }
    
    func returnToCenter(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        
        let percentCGFloatSize = CGFloat(sideViewPercentSize)
        
        UIView.animate(withDuration: 0.7, animations: {
            firstSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            firstSlide.frame.origin.x = self.firstSlidePositionX
            firstSlide.frame.origin.y = self.firstSlidePositionY
            
            secondSlide.transform = CGAffineTransform(scaleX: percentCGFloatSize, y: percentCGFloatSize)
            secondSlide.frame.origin.x = self.firstSideSlidePositionX
            secondSlide.frame.origin.y = self.sideSlidePositionY
            
            thirdSlide.transform = CGAffineTransform(scaleX: percentCGFloatSize, y: percentCGFloatSize)
            thirdSlide.frame.origin.x = self.secondSideSlidePositionX
            thirdSlide.frame.origin.y = self.sideSlidePositionY
        })
        
    }
    
    func updateSlide(direction: SlideDirection) {
        guard let firstSlide = subviews.first(where: {$0.accessibilityIdentifier == "firstSlide"}),
            let newSlide = subviews.first(where: {$0.accessibilityIdentifier == "newSlide"}) else {
                return
        }
        touchesStartPosition = 0
        let secondSlide = subviews.first(where: {$0.accessibilityIdentifier == "secondSlide"})
        let thirdSlide = subviews.first(where: {$0.accessibilityIdentifier == "thirdSlide"})
        
        //it must be removed and add to update accessibilityIdentifier
        
        switch direction {
        case .left:
            if let secondSlide = secondSlide {
                secondSlide.removeFromSuperview()
                secondSlide.accessibilityIdentifier = "firstSlide"
                self.addSubview(secondSlide)
            }
            
            newSlide.removeFromSuperview()
            newSlide.accessibilityIdentifier = "secondSlide"
            self.addSubview(newSlide)
            
            firstSlide.removeFromSuperview()
            firstSlide.accessibilityIdentifier = "thirdSlide"
            self.addSubview(firstSlide)
            
            thirdSlide?.removeFromSuperview()
            
        case .right:
            if let thirdSlide = thirdSlide {
                thirdSlide.removeFromSuperview()
                thirdSlide.accessibilityIdentifier = "firstSlide"
                self.addSubview(thirdSlide)
            }
            
            firstSlide.removeFromSuperview()
            firstSlide.accessibilityIdentifier = "secondSlide"
            self.addSubview(firstSlide)
            
            newSlide.removeFromSuperview()
            newSlide.accessibilityIdentifier = "thirdSlide"
            self.addSubview(newSlide)
            
            secondSlide?.removeFromSuperview()
            
        case .center:
            return
        }
    }
}
