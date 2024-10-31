//
//  DAOBottomSheetViewController.swift
//  DAOBottomSheet
//
//  Created by DAO on 2022/1/7.
//

import UIKit

open class DAOBottomSheetViewController: UIViewController {
    
    /// `BottomSheetType` will effect the content height configuration.
    ///
    /// - fixed: Content height is always set to `maxHeight`.
    /// - flexible: Content height is depends on custom UI.
    public enum BottomSheetType {
        case fixed
        case flexible
    }
    
    // MARK: - Properties
    
    // Public
    
    /// `DAOBottomSheetDelegate` provides setup and action handler function to let you customize the bottom sheet.
    ///
    /// For more information, see ``DAOBottomSheetDelegate``
    public weak var delegate: DAOBottomSheetDelegate?
    
    /// If you have multiple bottom sheets in your page, you can use tag to get specific bottom sheet. Default is 0.
    public var tag: Int = 0
    
    /// `BottomSheetType` will effect the content height configuration.
    ///
    /// - fixed: Content height is always set to `maxHeight`.
    /// - flexible: Content height is depends on custom UI.
    public let type: BottomSheetType
    
    /// Handle bottom sheet dismiss action.
    public var dismissBottomSheet: (() -> Void)?
    
    /// Bottom sheet header title.
    public var headerTitle: String? {
        didSet {
            navigationItem.title = headerTitle
        }
    }
    
    // Private
    
    /// The top margin between bottom sheet component and screen top edge. Default is 16.
    private let topMargin: CGFloat = 16
    
    /// The bottom sheet minimum height. Default is 240.
    private let minHeight: CGFloat = 240
    
    private var maxHeight: CGFloat {
        return UIScreen.main.bounds.height - statusBarHeight - topMargin
    }
    
    private var statusBarHeight: CGFloat {
        let statusBarHeight = (UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.statusBarManager?.statusBarFrame.height ?? 0)
        
        return statusBarHeight
    }
    
    private var isNavigationRootVC: Bool {
        return navigationController?.viewControllers.first == self
    }
    
    // MARK: - UI
    
    /// Content view's container scroll view.
    ///
    /// The view hierarchy is:
    /// ```
    /// vc.view|contentScrollView|contentView
    /// ```
    ///
    /// You can use ``DAOBottomSheetDelegate/setupCustomContentScrollView(bottomSheet:)-8ec1`` to use your own scroll view such as UITableView, UICollectionView, UITextView, etc.
    lazy var contentScrollView: UIScrollView = UIScrollView()
    
    /// Header slot is a customizable view below navigation header view.
    ///
    /// You can setup headerSlotView via ``DAOBottomSheetDelegate/setupHeaderSlotContent(with:slotContentView:)-9mvla``
    private lazy var headerSlotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /// Put your custom UI on contentView.
    ///
    /// By default, you should implement ``DAOBottomSheetDelegate/setupDAOBottomSheetContentUI(bottomSheet:)`` to build custom UI on contentView, but if you have a custom scrollView, use ``DAOBottomSheetDelegate/setupCustomContentScrollView(bottomSheet:)-8ec1`` instead.
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    /// Bottom sheet footer view.
    ///
    /// For more information, see ``DAOBottomSheetFooterView``.
    private lazy var footerView: DAOBottomSheetFooterView = {
        let footerView = DAOBottomSheetFooterView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.delegate = self
        
        return footerView
    }()
    
    // MARK: - Init
    /// Init bottom sheet controller.
    /// - Parameters:
    ///   - title: Header title. Default is nil.
    ///   - textLinkTitle: Pass a text link title will add a text link component to the right of header view. Default is nil.
    ///   - type: Default is `.flexible`.
    public init(title: String? = nil, type: BottomSheetType = .flexible) {
        headerTitle = title
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        type = .flexible
        
        super.init(coder: coder)
    }
    
    // MARK: - View lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addInteractivePopGestureRecognizer()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeInteractivePopGestureRecognizer()
    }
    
    // MARK: - Setup
    private func setup() {
        setupNavigationItem()
        setupContnet()
    }
    
    private func setupUI(isCustomScrollView: Bool) {
        view.backgroundColor = .systemBackground
        
        let contentScrollViewTopConstraint: NSLayoutConstraint
        let contentScrollViewBottomConstraint: NSLayoutConstraint
        
        // Header view
        if let headerView = delegate?.setupHeaderSlotContent(with: self) {
            headerView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(headerSlotView)
            headerSlotView.addSubview(headerView)
            
            NSLayoutConstraint.activate([
                headerView.leftAnchor.constraint(equalTo: headerSlotView.leftAnchor),
                headerView.rightAnchor.constraint(equalTo: headerSlotView.rightAnchor),
                headerView.topAnchor.constraint(equalTo: headerSlotView.topAnchor),
                headerView.bottomAnchor.constraint(equalTo: headerSlotView.bottomAnchor)
            ])
            
            let topConstraint: NSLayoutConstraint = headerSlotView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            
            NSLayoutConstraint.activate([
                topConstraint,
                headerSlotView.leftAnchor.constraint(equalTo: view.leftAnchor),
                headerSlotView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
            
            contentScrollViewTopConstraint = contentScrollView.topAnchor.constraint(equalTo: headerSlotView.bottomAnchor)
        } else {
            contentScrollViewTopConstraint = contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        }
        
        // Footer view
        if let footerContentView = delegate?.setupFooterContentView(with: self) {
            footerContentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(footerView)
            
            NSLayoutConstraint.activate([
                footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            contentScrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        } else {
            contentScrollViewBottomConstraint = contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        
        // Content scroll view
        view.addSubview(contentScrollView)
        NSLayoutConstraint.activate([
            contentScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentScrollViewTopConstraint,
            contentScrollViewBottomConstraint
        ])
        
        if !isCustomScrollView {
            // Content view
            contentScrollView.addSubview(contentView)
            
            NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: contentScrollView.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: contentScrollView.rightAnchor),
                contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
                contentView.centerXAnchor.constraint(equalTo: contentScrollView.centerXAnchor),
                contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            
            if let contentChildView = delegate?.setupDAOBottomSheetContentUI(bottomSheet: self) {
                contentView.addSubview(contentChildView)
                
                contentChildView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    contentChildView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                    contentChildView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                    contentChildView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    contentChildView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
            }
        }
    }
    
    private func setupNavigationItem() {
        navigationItem.title = headerTitle
        
        if !isNavigationRootVC {
            setupBackItem()
        }
    }
    
    private func setupBackItem() {
        let bundle = try? DAOResources.bundle()
        let backImage = UIImage(named: "ic_arrowLeft_line", in: bundle, with: nil)
        let backButton = UIButton()
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        let backItem = UIBarButtonItem(customView: backButton)
        let leftSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        navigationItem.leftBarButtonItems = [leftSpaceItem, backItem]
    }
    
    private func setupContnet() {
        if let customScrollView = delegate?.setupCustomContentScrollView(bottomSheet: self) {
            contentScrollView = customScrollView
            setupUI(isCustomScrollView: true)
        } else {
            setupUI(isCustomScrollView: false)
        }
        
        setupContentScrollView()
    }
    
    private func setupContentScrollView() {
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        contentScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - Utilites
    func getTotalHeight() -> CGFloat {
        guard type != .fixed else {
            return maxHeight
        }
        
        view.layoutIfNeeded()

        let grabberHeight: CGFloat = 22
        let topMargin: CGFloat = (navigationController?.navigationBar.bounds.height ?? 0) + grabberHeight
        let total = topMargin + headerSlotView.bounds.height + contentScrollView.contentSize.height + footerView.bounds.height
        
        guard total > minHeight else {
            return minHeight
        }
        
        guard total < maxHeight else {
            return maxHeight
        }
        
        return total
    }
    
    // MARK: - Actoin handler
    @objc private func handleBackButtonTapped() {
        if self.isNavigationRootVC {
            self.dismissBottomSheet?()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Gesture handler
    private func addInteractivePopGestureRecognizer() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !isNavigationRootVC
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func removeInteractivePopGestureRecognizer() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    /// Enable interactive pop gesture and pan down gesture at the same time.
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - DAOBottomSheetFooterViewDelegate
extension DAOBottomSheetViewController: DAOBottomSheetFooterViewDelegate {
    public func setupContentView() -> UIView? {
        return delegate?.setupFooterContentView(with: self)
    }
    
    public func setupSlotContent() -> UIView? {
        return delegate?.setupFooterSlotContent(with: self)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DAOBottomSheetViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigation = navigationController else {
            return false
        }
        
        return navigation.viewControllers.count > 1
    }
}
