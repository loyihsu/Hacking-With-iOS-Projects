//
//  PersonCell.swift
//  Project 12v2
//
//  Created by Yu-Sung Loyi Hsu on 2022/2/24.
//

import UIKit

class PersonCell: UICollectionViewCell {
    var nameLabel: UILabel!
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        layer.cornerRadius = 7

        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Marker Felt", size: 16)
        nameLabel.text = "Label"
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center

        imageView = UIImageView()
        imageView.backgroundColor = .black

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(nameLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leftAnchor
                .constraint(equalTo: leftAnchor, constant: 10),
            imageView.topAnchor
                .constraint(equalTo: topAnchor, constant: 10),
            imageView.widthAnchor
                .constraint(equalToConstant: 120),
            imageView.heightAnchor
                .constraint(equalToConstant: 120),
            nameLabel.leftAnchor
                .constraint(equalTo: leftAnchor, constant: 10),
            nameLabel.topAnchor
                .constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.widthAnchor
                .constraint(equalToConstant: 120),
            nameLabel.heightAnchor
                .constraint(equalToConstant: 40)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
