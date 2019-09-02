////
////  QuestionCard.swift
////  StudySwipe
////
////  Created by Dillon McElhinney on 7/7/19.
////  Copyright © 2019 Dillon McElhinney. All rights reserved.
////
//
//import UIKit
//import CardSwipe
//
//class QuestionCard: SwipeableCard {
//
//    //    var question: Question? {
//    //        didSet {
//    //            updateViews()
//    //        }
//    //    }
//    var answerTextView: UITextView!
//    var instructionLabel: UILabel!
//
//    private var questionContainer: UIView!
//    private var answerContainer: UIView!
//    private var isAnswerHidden = true
//
//    func updateViews() {
//        guard let question = question,
//            let categoryString = question.category,
//            let cardColor = Category(rawValue: categoryString)?.color() else { return }
//
//        backgroundColor = cardColor
//        let borderSpacing: CGFloat = 6
//        let borderView = UIView()
//        borderView.layer.borderColor = UIColor.white.cgColor
//        borderView.layer.borderWidth = 1
//        borderView.layer.cornerRadius = layer.cornerRadius - 4
//        borderView.constrainToSuperView(self, top: borderSpacing, bottom: borderSpacing, leading: borderSpacing, trailing: borderSpacing)
//
//        questionContainer = UIView()
//        questionContainer.constrainToSuperView(self, top: 20, bottom: 48, leading: 0, trailing: 0)
//
//        let downView = try? DownView(frame: .zero, markdownString: "### \(question.question ?? sampleText)")
//        downView?.backgroundColor = .clear
//        downView?.scrollView.backgroundColor = .clear
//        downView?.scrollView.bounces = false
//        downView?.isOpaque = false
//        downView?.constrainToFill(questionContainer)
//
//        answerContainer = UIView()
//        answerContainer.isHidden = true
//
//        answerContainer.constrainToSuperView(self, top: 20, bottom: 48, leading: 0, trailing: 0)
//
//        let answerView = try? DownView(frame: .zero, markdownString: "\(question.answer ?? sampleText)")
//        answerView?.backgroundColor = .clear
//        answerView?.scrollView.backgroundColor = .clear
//        answerView?.scrollView.bounces = false
//        answerView?.isOpaque = false
//        answerView?.constrainToFill(answerContainer)
//
//        instructionLabel = UILabel()
//        instructionLabel.textAlignment = .center
//        instructionLabel.text = "Tap to flip"
//        instructionLabel.textColor = .white
//
//        instructionLabel.constrainToSuperView(self, bottom: 20, leading: 20, trailing: 20)
//
//        self.layoutSubviews()
//
//    }
//
//    func handleTap() {
//        toggleAnswerTextLabel()
//    }
//
//    private func toggleAnswerTextLabel() {
//        isAnswerHidden.toggle()
//        questionContainer.isHidden = !isAnswerHidden
//        answerContainer.isHidden = isAnswerHidden
//    }
//
//    let sampleText = """
//```swift
//class SomeClass {
//    let constant = "constant"
//    print(constant.count)
//    // This is a comment... Looks like we should try to keep lines relatively short.
//    // You can scroll side to side, but it's not great.
//}
//```
//"""
//
//}
