//
//  StarRatingView.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class StarRatingView: UIView {
    let starImage: UIImage = UIImage(systemName: "star")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
    let starFilledImage: UIImage = UIImage(systemName: "star.fill")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
    
    var starLabel: UILabel = {
        let label = UILabel()
        label.text = "score: "
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.addArrangedSubview(starLabel)
        
        for _ in 0..<5 {
            let imageView = UIImageView(image: starFilledImage)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
