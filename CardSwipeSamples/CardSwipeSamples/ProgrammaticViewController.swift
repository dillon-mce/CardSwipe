//
//  ProgrammaticViewController.swift
//  CardSwipeSamples
//
//  Created by Dillon McElhinney on 8/18/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import CardSwipe

class ProgrammaticViewController: UIViewController, SwipeableCardContainerDelegate, SwipeableCardContainerDataSource {

    let container = SwipeableCardContainer()

    override func viewDidLoad() {
        super.viewDidLoad()

        container.dataSource = self
        container.delegate = self

        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ])


    }

    override func viewDidAppear(_ animated: Bool) {
        container.reloadData()
    }

    func cardViewContainer(_ cardViewContainer: SwipeableCardContainer, didSelectCard card: SwipeableCard, atIndex index: Int) {

    }

    func card(_ card: SwipeableCard, didCommitSwipeInDirection direction: SwipeDirection) {

    }

    func cardViewContainer(_ cardViewContainer: SwipeableCardContainer, isEmpty: Bool) {

    }

    func numberOfCards() -> Int {
        return 4
    }

    func card(forItemAtIndex index: Int) -> SwipeableCard {
        return ProgrammaticSampleCard()
    }

    func viewForEmptyCards() -> UIView {
        let label = UILabel()
        label.text = "No more cards!"
        label.textAlignment = .center

        return label
    }


}

