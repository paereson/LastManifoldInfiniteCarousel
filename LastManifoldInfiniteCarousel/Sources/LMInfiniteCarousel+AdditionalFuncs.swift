//
//  LMInfiniteCarousel+AdditionalFuncs.swift
//  LastManifoldInfiniteCarousel
//
//  Created by James on 05/11/2019.
//  Copyright © 2019 LastManifold. All rights reserved.
//

extension LMInfiniteCarousel {
    public func clearView() {
        subviews.forEach({$0.removeFromSuperview()})
    }
}
