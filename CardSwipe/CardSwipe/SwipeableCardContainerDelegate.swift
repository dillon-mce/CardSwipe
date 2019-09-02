//
//  SwipeableCardViewDelegate.swift
//  StudySwipe
//
//  Created by Dillon McElhinney on 7/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

/// A Delegate that is notified when actions are taken
/// in a SwipeableCardContainer.
public protocol SwipeableCardContainerDelegate: class {
    
    func cardViewContainer(_ cardViewContainer: SwipeableCardContainer, didSelectCard card: SwipeableCard, atIndex index: Int)
    
    func card(_ card: SwipeableCard, didCommitSwipeInDirection direction: SwipeDirection)
    
    func cardViewContainer(_ cardViewContainer: SwipeableCardContainer, isEmpty: Bool)
}

public extension SwipeableCardContainerDelegate {
    func cardViewContainer(_ cardView: SwipeableCardContainer, didSelectCard card: SwipeableCard, atIndex index: Int) {
        return
    }
    
    func card(_ card: SwipeableCard, didCommitSwipeInDirection direction: SwipeDirection) {
        return
    }
    
    func cardViewContainer(_ cardViewContainer: SwipeableCardContainer, isEmpty: Bool) {
        return
    }
}
