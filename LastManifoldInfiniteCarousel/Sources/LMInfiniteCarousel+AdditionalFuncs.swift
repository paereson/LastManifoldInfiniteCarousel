//
//  LMInfiniteCarousel+AdditionalFuncs.swift
//  LastManifoldInfiniteCarousel
//
//  Created by Grzeogrz Kurnatowski on 05/11/2019.
//  Copyright © 2019 LastManifold. All rights reserved.
//

extension LMInfiniteCarousel {
    public func clearView() {
        subviews.forEach({$0.removeFromSuperview()})
        
        widthPercent *= 100
        heightPercent *= 100
        sideViewPercentSize *= 100
        currentSlide = 0
    }
}
