//
//  SeparatorView.swift
//  DAOBottomSheet
//
//  Created by DAO on 2022/1/18.
//

import UIKit

class SeparatorView: UIView {
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
        backgroundColor = UIColor(red: 0.835, green: 0.839, blue: 0.859, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
