//
//  ViewController.swift
//  Project 6
//
//  Created by Loyi Hsu on 2022/2/11.
//

import UIKit

class ViewController : UIViewController {
    func createUILabel(backgroundColor: UIColor, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = backgroundColor
        label.text = text
        label.sizeToFit()
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label1 = createUILabel(backgroundColor: .red, text: "THESE")
        let label2 = createUILabel(backgroundColor: .cyan, text: "ARE")
        let label3 = createUILabel(backgroundColor: .yellow, text: "SOME")
        let label4 = createUILabel(backgroundColor: .green, text: "AWESOME")
        let label5 = createUILabel(backgroundColor: .orange, text: "LABELS")

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)

//        let viewsDictionary = ["label1": label1,
//                               "label2": label2,
//                               "label3": label3,
//                               "label4": label4,
//                               "label5": label5]
//
//        let metrics = ["labelHeight": 88]
//
//        for label in viewsDictionary.keys {
//            view.addConstraints(
//                NSLayoutConstraint.constraints(
//                    withVisualFormat: "H:|[\(label)]|",
//                    options: [],
//                    metrics: nil,
//                    views: viewsDictionary
//                )
//            )
//        }

//        view.addConstraints(
//            NSLayoutConstraint.constraints(
//                withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]-(>=10)-|",
//                options: [],
//                metrics: metrics,
//                views: viewsDictionary)
//        )

        var previous: UILabel?

        for label in [label1, label2, label3, label4, label5] {
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true

            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true

            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            previous = label
        }
    }
}
