//
//  SwipeableCardContainer.swift
//  StudySwipe
//
//  Created by Dillon McElhinney on 7/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

public class SwipeableCardContainer: UIView, SwipeableViewDelegate {

    // TODO: - Clean these up
    static let distanceScale: CGFloat = 0.05
    static let verticalInset: CGFloat = 12.0
    static var preferredWidth: CGFloat = 300.0
    static let numberOfVisibleCards: Int = 3

    public var shouldFlipCards = true

    public var dataSource: SwipeableCardContainerDataSource? {
        didSet {
            reloadData()
        }
    }

    public var delegate: SwipeableCardContainerDelegate?

    private var cardViews: [SwipeableCard] = []

    private var visibleCardViews: [SwipeableCard] {
        return containerView.subviews.compactMap { $0 as? SwipeableCard }
    }

    private var remainingCards: Int = 0

    private let backgroundView = UIView()
    private let containerView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    public func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else {
            return
        }
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, SwipeableCardContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
        
        resetEmptyView()
        setNeedsLayout()
    }

    private func resetEmptyView() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }

        let emptyView = dataSource?.viewForEmptyCards() ?? UIView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
            ])
    }
    
    private func addCardView(cardView: SwipeableCard, atIndex index: Int) {
        cardView.delegate = self
        cardView.frame = calculateFrame()
        cardView.transform = transform(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        containerView.insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func removeAllCardViews() {
        visibleCardViews.forEach { $0.removeFromSuperview() }
        
        cardViews = []
    }
    
    private func calculateFrame() -> CGRect {
        let x = bounds.origin.x
        let y = bounds.origin.y + 2 * SwipeableCardContainer.verticalInset
        let width = bounds.size.width
        let height = bounds.size.height - 2 * SwipeableCardContainer.verticalInset
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func transform(forCardView cardView: SwipeableCard, atIndex index: Int) -> CGAffineTransform {
        let verticalInset = CGFloat(index) * SwipeableCardContainer.verticalInset * 2
        let scale = 1 - (SwipeableCardContainer.distanceScale * CGFloat(index))
        
        return CGAffineTransform.identity.translatedBy(x: 0, y: -verticalInset).scaledBy(x: scale, y: scale)
    }
    
}

// MARK: - SwipeableViewDelegate

extension SwipeableCardContainer {
    
    func didTap(view: SwipeableView) {
        let flipDuration = 0.35
        if let cardView = view as? SwipeableCard,
            let index = cardViews.firstIndex(of: cardView) {
            delegate?.cardViewContainer(self, didSelectCard: cardView, atIndex: index)

            if shouldFlipCards {
                // Perform first half of flip
                UIView.animate(withDuration: flipDuration/2, delay: 0, options: [.curveEaseIn], animations: {
                    cardView.transform = cardView.transform.scaledBy(x: 0.001, y: 0.96)
                }) { _ in
                    // Call the card's handleTap method
                    cardView.handleTap()
                    // Finish the second half of the flip
                    UIView.animate(withDuration: flipDuration/2, delay: 0, options: [.curveEaseOut], animations: {
                        cardView.transform = self.transform(forCardView: cardView, atIndex: 0)
                    })
                }
            } else {
                cardView.handleTap()
            }
        }
    }

    func didBeginSwipe(onView view: SwipeableView) {
        // React to swipe starting?
    }
    
    func didEndSwipe(onView view: SwipeableView, in direction: SwipeDirection) {
        guard let dataSource = dataSource else {
            return
        }
        
        if let card = view as? SwipeableCard {
            delegate?.card(card, didCommitSwipeInDirection: direction)
        }
        
        // Remove swiped card
        view.removeFromSuperview()
        if visibleCardViews.count == 0 {
            delegate?.cardViewContainer(self, isEmpty: true)
        }
        
        // Only add a new card if there are cards remaining
        if remainingCards > 0 {
            
            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards
            
            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
            
        }
        
        // Update all existing card's transform based on new indexes, animate transform
        // to reveal new card from underneath the stack of existing cards.
        for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                cardView.transform = self.transform(forCardView: cardView, atIndex: cardIndex)
                self.layoutIfNeeded()
            })
        }
    }
    
}

