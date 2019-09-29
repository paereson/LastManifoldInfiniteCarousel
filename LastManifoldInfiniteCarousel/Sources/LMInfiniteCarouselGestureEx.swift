//
//  LMInfiniteCarouselGestureEx.swift
//  InfiniteCarousel
//
//  Created by Grzegorz Kurnatowski on 29/09/2019.
//  Copyright © 2019 Grzegorz Kurnatowski. All rights reserved.
//

import UIKit

extension LMInfiniteCarousel: UIGestureRecognizerDelegate {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: self).x {
            touchesStartPosition = position
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position = touches.first?.location(in: self).x {
            
            guard let firstSlide = subviews.first(where: {$0.accessibilityIdentifier == "firstSlide"}),
                let secondSlide = subviews.first(where: {$0.accessibilityIdentifier == "secondSlide"}),
                let thirdSlide = subviews.first(where: {$0.accessibilityIdentifier == "thirdSlide"}) else {
                    return
            }
            
            if position - touchesStartPosition > 10 {
                partMoveToRight(firstSlide: firstSlide, secondSlide: secondSlide, thirdSlide: thirdSlide)
            } else if position - touchesStartPosition < -10 {
                partMoveToLeft(firstSlide: firstSlide, secondSlide: secondSlide, thirdSlide: thirdSlide)
            }
            
            if position - touchesStartPosition > 100 {
                slideDirection = .right
            } else if position - touchesStartPosition < -100 {
                slideDirection = .left
            } else {
                slideDirection = .center
            }
        }
    }
    
    func partMoveToLeft(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        
        UIView.animate(withDuration: 0.7, animations: {
            let mainSlidePositionDifference = firstSlide.frame.origin.x + (firstSlide.frame.width / 2)
            firstSlide.frame.origin.x = -(firstSlide.frame.width / 2)
            firstSlide.frame.origin.y = self.sideSlidePositionY
            firstSlide.frame.size.width = self.sideSlideWidth
            firstSlide.frame.size.height = self.sideSlideHeight
            
            thirdSlide.frame.origin.x -= mainSlidePositionDifference
            
            secondSlide.frame.origin.x = firstSlide.frame.maxX + CGFloat(self.slidesOffset)
            secondSlide.frame.size.width = self.firstSlideWidth
            secondSlide.frame.size.height = self.firstSlideHeight
            secondSlide.frame.origin.y = self.firstSlidePositionY
        })
    }
    
    func partMoveToRight(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        UIView.animate(withDuration: 0.7, animations: {
            let mainSlidePositionDifference = firstSlide.frame.origin.x - (self.frame.width - (firstSlide.frame.width / 2))
            firstSlide.frame.origin.x = self.frame.width - (firstSlide.frame.width / 2)
            firstSlide.frame.origin.y = self.sideSlidePositionY
            firstSlide.frame.size.width = self.sideSlideWidth
            firstSlide.frame.size.height = self.sideSlideHeight
            
            secondSlide.frame.origin.x -= mainSlidePositionDifference
            
            thirdSlide.frame.origin.x = firstSlide.frame.minX - CGFloat(self.slidesOffset) - thirdSlide.frame.width
            thirdSlide.frame.size.width = self.firstSlideWidth
            thirdSlide.frame.size.height = self.firstSlideHeight
            thirdSlide.frame.origin.y = self.firstSlidePositionY
        })
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstSlide = subviews.first(where: {$0.accessibilityIdentifier == "firstSlide"}),
            let secondSlide = subviews.first(where: {$0.accessibilityIdentifier == "secondSlide"}),
            let thirdSlide = subviews.first(where: {$0.accessibilityIdentifier == "thirdSlide"}) else {
                return
        }
        switch slideDirection {
        case .left:
            slideToLeft(firstSlide: firstSlide, secondSlide: secondSlide, thirdSlide: thirdSlide)
        case .right:
            slideToRight(firstSlide: firstSlide, secondSlide: secondSlide, thirdSlide: thirdSlide)
        case .center:
            returnToCenter(firstSlide: firstSlide, secondSlide: secondSlide, thirdSlide: thirdSlide)
        }
    }
}
