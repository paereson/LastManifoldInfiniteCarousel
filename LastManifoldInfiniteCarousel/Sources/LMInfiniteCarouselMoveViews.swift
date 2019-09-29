//
//  LMInfiniteCarouselMoveViews.swift
//  LMInfiniteCarousel
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
        
        if let fourthSlide = slides[exist: newSlideIndex] {
            newSlide = fourthSlide
        } else if let fourtSlide = slides.first {
            newSlide = fourtSlide
        } else {
            return
        }
        
        newSlide.frame.origin.x = secondSlide.frame.maxX + CGFloat(self.slidesOffset)
        newSlide.frame.origin.y = self.sideSlidePositionY
        newSlide.frame.size.width = self.sideSlideWidth
        newSlide.frame.size.height = self.sideSlideHeight
        
        newSlide.accessibilityIdentifier = "newSlide"
        
        self.addSubview(newSlide)
        
        UIView.animate(withDuration: 0.7, animations: {
            secondSlide.frame = CGRect(x: self.firstSlidePositionX, y: self.firstSlidePositionY, width: self.firstSlideWidth, height: self.firstSlideHeight)
            
            firstSlide.frame.origin.y = self.sideSlidePositionY
            firstSlide.frame.origin.x = self.secondSideSlidePositionX
            firstSlide.frame.size.width = self.sideSlideWidth
            firstSlide.frame.size.height = self.sideSlideHeight
            
            newSlide.frame.origin.y = self.sideSlidePositionY
            newSlide.frame.origin.x = self.firstSideSlidePositionX
            newSlide.frame.size.width = self.sideSlideWidth
            newSlide.frame.size.height = self.sideSlideHeight
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
        
        if let fourthSlide = slides[exist: newSlideIndex] {
            newSlide = fourthSlide
        } else if let fourthSlide = slides.last {
            newSlide = fourthSlide
        } else {
            return
        }
        
        newSlide.frame.origin.x = thirdSlide.frame.minX - CGFloat(self.slidesOffset) - thirdSlide.frame.width
        newSlide.frame.origin.y = self.sideSlidePositionY
        newSlide.frame.size.width = self.sideSlideWidth
        newSlide.frame.size.height = self.sideSlideHeight
        
        newSlide.accessibilityIdentifier = "newSlide"
        
        self.addSubview(newSlide)
        
        UIView.animate(withDuration: 0.7, animations: {
            thirdSlide.frame = CGRect(x: self.firstSlidePositionX, y: self.firstSlidePositionY, width: self.firstSlideWidth, height: self.firstSlideHeight)
            
            firstSlide.frame.origin.y = self.sideSlidePositionY
            firstSlide.frame.origin.x = self.firstSideSlidePositionX
            firstSlide.frame.size.width = self.sideSlideWidth
            firstSlide.frame.size.height = self.sideSlideHeight
            
            newSlide.frame.origin.y = self.sideSlidePositionY
            newSlide.frame.origin.x = self.secondSideSlidePositionX
            newSlide.frame.size.width = self.sideSlideWidth
            newSlide.frame.size.height = self.sideSlideHeight
        })
        
        updateSlide(direction: .right)
        
        delegate?.pageChanged()
    }
    
    func returnToCenter(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        UIView.animate(withDuration: 0.7, animations: {
            firstSlide.frame = CGRect(x: self.firstSlidePositionX, y: self.firstSlidePositionY, width: self.firstSlideWidth, height: self.firstSlideHeight)
            
            secondSlide.frame.origin.x = self.firstSideSlidePositionX
            secondSlide.frame.size.width = self.sideSlideWidth
            secondSlide.frame.size.height = self.sideSlideHeight
            secondSlide.frame.origin.y = self.sideSlidePositionY
            
            thirdSlide.frame.origin.x = self.secondSideSlidePositionX
            thirdSlide.frame.size.width = self.sideSlideWidth
            thirdSlide.frame.size.height = self.sideSlideHeight
            thirdSlide.frame.origin.y = self.sideSlidePositionY
        })
    }
    
    func updateSlide(direction: SlideDirection) {
        guard let firstSlide = subviews.first(where: {$0.accessibilityIdentifier == "firstSlide"}),
            let newSlide = subviews.first(where: {$0.accessibilityIdentifier == "newSlide"}) else {
                return
        }
        
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
