//
//  SwipeableCard.swift
//  CardSwipe
//
//  Created by Dillon McElhinney on 7/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

open class SwipeableCard: SwipeableView {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupCard()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupCard()
    }

    /// Sets up the appearance of the card. Override this to change its appearance.
    open func setupCard() {
        backgroundColor = .white
        layer.cornerRadius = 24
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 4, height: 10)
    }

    /// This function is called when the card is tapped. If `shouldFlipCards` is set to true, this will be called in the middle of the animation, otherwise it is just called when the card is tapped. Handle any updates to the view here.
    open func handleTap() {
        
    }
}
