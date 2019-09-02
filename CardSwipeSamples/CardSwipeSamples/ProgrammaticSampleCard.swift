//
//  SampleCard.swift
//  CardSwipeSamples
//
//  Created by Dillon McElhinney on 9/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import CardSwipe

class ProgrammaticSampleCard: SwipeableCard {
    let frontLabel: UILabel = {
        let label = UILabel()
        label.text = "Front"
        label.textAlignment = .center

        return label
    }()

    let backLabel: UILabel = {
        let label = UILabel()
        label.text = "Back"
        label.textAlignment = .center

        return label
    }()

    override func setupCard() {
        super.setupCard()

        frontLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(frontLabel)

        backLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backLabel)
        backLabel.isHidden = true

        NSLayoutConstraint.activate([
            frontLabel.topAnchor.constraint(equalTo: self.topAnchor),
            frontLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            frontLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backLabel.topAnchor.constraint(equalTo: self.topAnchor),
            backLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }

    override func handleTap() {
        super.handleTap()

        frontLabel.isHidden.toggle()
        backLabel.isHidden.toggle()
    }
}
