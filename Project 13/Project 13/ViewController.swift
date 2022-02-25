//
//  ViewController.swift
//  Project 13
//
//  Created by Yu-Sung Loyi Hsu on 2022/2/25.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var intensityLabel: UILabel!
    var slider: UISlider!
    var changeFilterButton: UIButton!
    var saveButton: UIButton!

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        view.addSubview(imageView)

        intensityLabel = UILabel()
        intensityLabel.text = "Intensity: "
        view.addSubview(intensityLabel)

        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        view.addSubview(slider)

        changeFilterButton = UIButton()
        changeFilterButton.setTitle("Change Filter", for: .normal)
        changeFilterButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(changeFilterButton)

        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(saveButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        changeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 450),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            intensityLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            intensityLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            slider.leftAnchor.constraint(equalTo: intensityLabel.rightAnchor, constant: 10),
            slider.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            slider.widthAnchor.constraint(equalToConstant: 262),
            changeFilterButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            changeFilterButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 10),
            saveButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            saveButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 10)
        ])

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

