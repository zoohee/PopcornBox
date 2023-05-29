//
//  CustomModalView.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class CustomModalView: UIView {
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        // 모달 뷰 내부의 UI 요소들을 배치하고 제약 조건을 설정합니다.
        addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc private func closeButtonTapped() {
        // 닫기 버튼에 대한 액션을 처리합니다.
        // 모달을 닫는 등 필요한 동작을 수행합니다.
        if let viewController = findViewController() {
            viewController.dismiss(animated: false, completion: nil)
        }
    }
    
    // 현재 이 뷰가 속한 뷰컨트롤러를 찾아야 함
    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
    
}
