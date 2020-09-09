//
//  LMInfiniteCarouselGestureEx.swift
//  LMInfiniteCarouselGestureEx
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
        
        let percentCGFloatSize = CGFloat(self.sideViewPercentSize)
        let mainSlidePositionDifference = firstSlide.frame.origin.x + (firstSlide.frame.width / 2)
        
        UIView.animate(withDuration: animationDuration, animations: {
            firstSlide.transform = CGAffineTransform(scaleX: percentCGFloatSize, y: percentCGFloatSize)
            firstSlide.frame.origin.x = -(firstSlide.frame.width / 2)
            firstSlide.frame.origin.y = self.sideSlidePositionY
                        
            secondSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            secondSlide.frame.origin.x = firstSlide.frame.maxX + CGFloat(self.slidesOffset)
            secondSlide.frame.origin.y = self.firstSlidePositionY

            thirdSlide.frame.origin.x -= mainSlidePositionDifference
        })
    }
    
    func partMoveToRight(firstSlide: UIView, secondSlide: UIView, thirdSlide: UIView) {
        
        let percentCGFloatSize = CGFloat(self.sideViewPercentSize)
        let mainSlidePositionDifference = firstSlide.frame.origin.x - (self.frame.width - (firstSlide.frame.width / 2))

        UIView.animate(withDuration: animationDuration, animations: {
            firstSlide.transform = CGAffineTransform(scaleX: percentCGFloatSize, y: percentCGFloatSize)
            firstSlide.frame.origin.x = self.frame.width - (firstSlide.frame.width / 2)
            firstSlide.frame.origin.y = self.sideSlidePositionY
            
            secondSlide.frame.origin.x -= mainSlidePositionDifference

            thirdSlide.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            thirdSlide.frame.origin.x = firstSlide.frame.minX - CGFloat(self.slidesOffset) - thirdSlide.frame.width
            thirdSlide.frame.origin.y = self.firstSlidePositionY
        })
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesStartPosition = 0
        guard let slideDirection = slideDirection, let firstSlide = subviews.first(where: {$0.accessibilityIdentifier == "firstSlide"}),
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
        self.slideDirection = nil
    }
}
