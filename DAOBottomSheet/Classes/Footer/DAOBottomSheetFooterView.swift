//
//  DAOBottomSheetFooterView.swift
//  DAOBottomSheet
//
//  Created by DAO on 2021/12/14.
//

import UIKit

/// Bottom sheet footer view contains a main content view and an additional slot view above content view. Footer view is an optional view for ``DAOBottomSheet``.
open class DAOBottomSheetFooterView: UIView {
    // MARK: - Properties
    
    /// Implement ``DAOBottomSheetFooterViewDelegate`` to setup footer content view and slot content view.
    ///
    /// For more information, see ``DAOBottomSheetFooterViewDelegate``
    public weak var delegate: DAOBottomSheetFooterViewDelegate? {
        didSet {
            updateSlotContentView()
        }
    }
    
    private let safeAreaBottomInset: CGFloat = {
        if let windowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first,
           let window = windowScene.windows.first {
            let safeAreaBottomInset = window.safeAreaInsets.bottom
            return safeAreaBottomInset
        } else {
            return 0
        }
    }()
    
    // MARK: - UI
    
    /// A separator view above footer view.
    public lazy var separatorView: UIView = SeparatorView()
    
    /// A customizable slot view above contentView.
    ///
    /// Your can setup slotContentView via ``DAOBottomSheetFooterViewDelegate/setupSlotContent()-6ha8z``
    public lazy var slotContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    /// A customizable contentView at the very bottom of footer view.
    ///
    /// You can setup contentView via ``DAOBottomSheetFooterViewDelegate/setupContentView()-78t4r``
    public lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [separatorView, slotContentView, contentContainerView])
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupUI()
        updateSlotContentView()
    }
    
    private func setupUI() {
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leftAnchor.constraint(equalTo: leftAnchor),
            containerStackView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        contentContainerView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16 - safeAreaBottomInset),
            contentView.leftAnchor.constraint(equalTo: contentContainerView.leftAnchor, constant: 24),
            contentView.rightAnchor.constraint(equalTo: contentContainerView.rightAnchor, constant: -24),
            contentView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Update
    public func updateSlotContentView() {
        if contentView.subviews.isEmpty, let contentChildView = delegate?.setupContentView() {
            contentChildView.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(contentChildView)
            
            NSLayoutConstraint.activate([
                contentChildView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                contentChildView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                contentChildView.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentChildView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        if slotContentView.subviews.isEmpty, let slotContentChildView = delegate?.setupSlotContent() {
            slotContentChildView.translatesAutoresizingMaskIntoConstraints = false
            
            slotContentView.addSubview(slotContentChildView)
            
            NSLayoutConstraint.activate([
                slotContentChildView.leftAnchor.constraint(equalTo: slotContentView.leftAnchor),
                slotContentChildView.rightAnchor.constraint(equalTo: slotContentView.rightAnchor),
                slotContentChildView.topAnchor.constraint(equalTo: slotContentView.topAnchor),
                slotContentChildView.bottomAnchor.constraint(equalTo: slotContentView.bottomAnchor)
            ])
        }
        
        let isContentChildEmpty = delegate?.setupContentView() == nil
        let isSlotContentChildEmpty = delegate?.setupSlotContent() == nil
        slotContentView.isHidden = isContentChildEmpty || isSlotContentChildEmpty
    }
}
