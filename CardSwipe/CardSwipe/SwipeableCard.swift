//
//  SwipeableCard.swift
//  StudySwipe
//
//  Created by Dillon McElhinney on 7/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

open class SwipeableCard: SwipeableView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Init from coder not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 24
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 4, height: 10)
    }
}
