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
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .leading
        // priority를 설정해서 priority 낮은 건 ... 으로 나오게 하기
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        
        addSubview(stackView)
        stackView.addArrangedSubview(starLabel)
        for _ in 0..<5 {
            let imageView = UIImageView(image: starFilledImage)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        // 여기서 trailing 지정해주면 starRatingView의 Constraint가 이상하게 잡힘
        // Anchor의 view 지정 안해주면 무조건 superView
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
