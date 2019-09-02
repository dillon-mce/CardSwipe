//
//  SwipeableCardContainerDataSource.swift
//  StudySwipe
//
//  Created by Dillon McElhinney on 7/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

/// A DataSource for providing all of the information required
/// for SwipeableCardContainer to layout a series of cards.
public protocol SwipeableCardContainerDataSource: class {
    
    /// Determines the number of cards to be added into the
    /// SwipeableCardContainer. Not all cards will initially
    /// be visible, but as cards are swiped away new cards will
    /// appear until this number of cards is reached.
    ///
    /// - Returns: total number of cards to be shown
    func numberOfCards() -> Int
    
    /// Provides the Card View to be displayed within the
    /// SwipeableCardContainer. This view's frame will
    /// be updated depending on its current index within the stack.
    ///
    /// - Parameter index: index of the card to be displayed
    /// - Returns: card view to display
    func card(forItemAtIndex index: Int) -> SwipeableCard
    
    /// Provides a View to be displayed underneath all of the
    /// cards when all cards have been swiped away.
    ///
    /// - Returns: view to be displayed underneath all cards
    func viewForEmptyCards() -> UIView
    
}

public extension SwipeableCardContainerDataSource {
    func viewForEmptyCards() -> UIView {
        return UIView()
    }
}
