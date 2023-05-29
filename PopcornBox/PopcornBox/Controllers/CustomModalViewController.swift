//
//  CustomModalViewController.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class CustomModalViewController: UIViewController {
    private let modalView = CustomModalView()
    
    var didDismissModal: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModalView()
    }
    
    private func setupModalView() {

        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        
        modalView.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 100, height: 200)
        modalView.center = view.center
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 10
        
        view.addSubview(modalView)
    }
    
    @objc private func backgroundTapped() {
        dismiss(animated: false, completion: nil)
    }
    
}
