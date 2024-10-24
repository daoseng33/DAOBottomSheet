//
//  DAOBottomSheetNavigationController.swift
//  DAOBottomSheet
//
//  Created by DAO on 2022/1/10.
//

import UIKit

/// DAOBottomSheetNavigationController is a navigation container for bottom sheet, which make bottom sheet navigable.
open class DAOBottomSheetNavigationController: UINavigationController {
    // MARK: - Properties
    
    /// The root bottom sheet content view controller.
    public let rootVC: DAOBottomSheetViewController
    
    // MARK: - UI
    private lazy var grabberView: GrabberView = {
        let view = GrabberView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    
    /// Init navigation controller will also create a root bottom sheet controller.
    /// - Parameters:
    ///   - title: Header title. Default is nil.
    ///   - textLinkTitle: Pass a text link title will add a text link component to the right of header view. Default is nil.
    ///   - type: Default is `.flexible`.
    public init(with title: String? = nil, type: DAOBottomSheetViewController.BottomSheetType = .flexible) {
        rootVC = DAOBottomSheetViewController(title: title, type: type)
        
        super.init(rootViewController: rootVC)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        rootVC = DAOBottomSheetViewController()
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        setupUI()
        setupGrabberView()
        setupNavigationBar()
    }
    
    private func setupUI() {
        roundingTopCorner(with: view, radius: 16)
    }
    
    private func setupNavigationBar() {
        var attributes = DAOTypography.subtitleLg.attributes
        attributes[.foregroundColor] = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        navigationBar.titleTextAttributes = attributes
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
 
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupGrabberView() {
        let grabberViewHeight: CGFloat = 20
        additionalSafeAreaInsets.top = -grabberViewHeight
        view.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: view.topAnchor),
            grabberView.leftAnchor.constraint(equalTo: view.leftAnchor),
            grabberView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func roundingTopCorner(with view: UIView, radius: CGFloat) {
        let radius: CGFloat = radius
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}
