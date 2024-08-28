//
//  GrabberView.swift
//  DAOBottomSheet
//
//  Created by DAO on 2022/1/11.
//

import UIKit

/// A grabber view for view like bottom sheet.
class GrabberView: UIView {
    // MARK: - UI
    lazy var grabberView: UIView = {
        let view = UIView()
        // TODO: Should be replace to DS color token
        view.backgroundColor = UIColor(red: 0.835, green: 0.839, blue: 0.859, alpha: 1)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .white
        addSubview(grabberView)
        
        let bottomConstraint = grabberView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        bottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            grabberView.heightAnchor.constraint(equalToConstant: 4),
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bottomConstraint,
            grabberView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
