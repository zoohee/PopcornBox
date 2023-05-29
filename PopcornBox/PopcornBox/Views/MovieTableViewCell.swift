//
//  MovieTableViewCell.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    var roundedRectangle: UIView = {
        let roundedRectangle = UIView()
        roundedRectangle.translatesAutoresizingMaskIntoConstraints = false
        roundedRectangle.layer.cornerRadius = 10
        roundedRectangle.backgroundColor = UIColor(red: 253 / 255, green: 239 / 255, blue: 228 / 255, alpha: 1.00)
        return roundedRectangle
    }()
    
    var movieImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
        return labelStackView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var directorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var actorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var starRatingView = StarRatingView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        contentView.addSubview(roundedRectangle)
        contentView.addSubview(movieImage)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(directorLabel)
        labelStackView.addArrangedSubview(actorLabel)
        labelStackView.addArrangedSubview(starRatingView)
    }
    
    private func setAutoLayout() {
        
        roundedRectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        roundedRectangle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        roundedRectangle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        roundedRectangle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        movieImage.leadingAnchor.constraint(equalTo: roundedRectangle.leadingAnchor, constant: 5).isActive = true
        movieImage.topAnchor.constraint(equalTo: roundedRectangle.topAnchor, constant: 5).isActive = true
        movieImage.bottomAnchor.constraint(equalTo: roundedRectangle.bottomAnchor, constant: -5).isActive = true
        movieImage.heightAnchor.constraint(equalTo: movieImage.widthAnchor, multiplier: 1.25).isActive = true
        
        labelStackView.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 10).isActive = true
        labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        // labelStacView의 trailing을 건드리면 별이 자꾸 오른쪽으로 쏟아짐
        titleLabel.trailingAnchor.constraint(equalTo: roundedRectangle.trailingAnchor, constant: -30).isActive = true
        starRatingView.trailingAnchor.constraint(equalTo: roundedRectangle.trailingAnchor, constant: -100).isActive = true
    }
}
