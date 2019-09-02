//
//  StoryboardViewController.swift
//  CardSwipeSamples
//
//  Created by Dillon McElhinney on 9/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import CardSwipe

class StoryboardViewController: UIViewController, SwipeableCardContainerDelegate, SwipeableCardContainerDataSource {

    @IBOutlet var swipeableContainer: SwipeableCardContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipeableContainer.delegate = self
        swipeableContainer.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        swipeableContainer.reloadData()
    }

    // MARK: - Swipeable Card Container Data Source
    func numberOfCards() -> Int {
        return 4
    }

    func card(forItemAtIndex index: Int) -> SwipeableCard {
        return SwipeableCard()
    }

    func viewForEmptyCards() -> UIView {
        let label = UILabel()
        label.text = "No more cards!"
        label.textAlignment = .center

        return label
    }

}
