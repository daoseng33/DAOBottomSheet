//
//  DAOBottomSheet.swift
//  DAOBottomSheet
//
//  Created by DAO on 2022/1/9.
//

import UIKit

public class DAOBottomSheet {
    // MARK: -  Properties
    // Public
    
    /// Bottom sheet navigation controller.
    public let navigation: DAOBottomSheetNavigationController
    
    /// Bottom sheet content view controller.
    public lazy var rootVC: DAOBottomSheetViewController = navigation.rootVC
    
    /// `DAOBottomSheetDelegate` provides setup and action handler function to let you customize the bottom sheet.
    ///
    /// For more information, see ``DAOBottomSheetDelegate``
    public var delegate: DAOBottomSheetDelegate? {
        didSet {
            rootVC.delegate = delegate
        }
    }
    
    /// If you have multiple bottom sheets in your page, you can use tag to get specific bottom sheet. Default is 0.
    public var tag: Int = 0 {
        didSet {
            rootVC.tag = tag
        }
    }
    
    // Private
    private var isDragging: Bool = false
    private var isReachTriggerPoint: Bool = false
    private var enablePanGesture = false {
        didSet {
            if enablePanGesture {
                rootVC.contentScrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
            } else {
                rootVC.contentScrollView.panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
            }
        }
    }
    
    private lazy var panGesture: UIPanGestureRecognizer = {
       let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        pan.maximumNumberOfTouches = 1
        
        return pan
    }()
    
    private weak var parentVC: UIViewController!
    private var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var scrollViewKVO: NSKeyValueObservation?
    
    private lazy var maskView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0, alpha: 0.48)
        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMaskViewTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    // MARK: - Init
    
    /// Create a bottom sheet composite component and add it as child view controller to parent view controller.
    /// - Parameters:
    ///   - parentVC: The bottom sheet will be added as parent view controller's sub view controller when called `bottomSheet.show()`.
    ///   - title: Header title. Default is nil.
    ///   - textLinkTitle: Pass a text link title will add a text link component to the right of header view. Default is nil.
    ///   - type: Default is `.flexible`.
    public init(parentVC: UIViewController, title: String? = nil, type: DAOBottomSheetViewController.BottomSheetType = .flexible) {
        if let navigationController = parentVC.navigationController {
            self.parentVC = navigationController
        } else if let tabBarController = parentVC.tabBarController {
            self.parentVC = tabBarController
        } else {
            self.parentVC = parentVC
        }
        
        navigation = DAOBottomSheetNavigationController(with: title, type: type)
        
        setup()
    }
    
    deinit {
        scrollViewKVO = nil
    }
    
    // MARK: - Setup
    private func setup() {
        setupPanGesture()
    }
    
    private func setupPanGesture() {
        navigation.view.addGestureRecognizer(panGesture)
        navigation.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handlePopGesture(_:)))
    }
    
    private func setupContentVC() {
        enablePanGesture = true
        
        rootVC.dismissBottomSheet = { [weak self] in
            guard let self = self else { return }
            self.dismiss()
        }
        
        scrollViewKVO = rootVC.contentScrollView.observe(\UIScrollView.contentOffset, options: [.old, .new], changeHandler: { [weak self] scrollView, change in
            guard let self = self, let oldY = change.oldValue?.y, let newY = change.newValue?.y else { return }
            
            self.handleScroll(with: oldY, newY: newY, scrollView: scrollView)
        })
    }
    
    private func handleScroll(with oldY: CGFloat, newY: CGFloat, scrollView: UIScrollView) {
        if enablePanGesture {
            if newY <= 0 || isDragging {
                if scrollView.contentOffset.y != 0 {
                    scrollView.contentOffset.y = 0
                }
            } else {
                enablePanGesture = false
            }
        } else {
            if newY == 0 && oldY < 0 && !enablePanGesture {
                enablePanGesture = true
            }
        }
    }
    
    // MARK: - Public behavior
    
    /// Animate and add bottom sheet to parent view controller as sub view controller.
    /// - Parameter completion: Handle completion behavior here.
    public func show(completion: (() -> Void)? = nil) {
        if let parentVC = parentVC as? UINavigationController {
            parentVC.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        addBottomSheetToChild()
        
        animateBottomSheet(isShow: true, completion: { [weak self] in
            guard let self = self else { return }
            self.setupContentVC()
            completion?()
        })
    }
    
    /// Animate and remove bottom sheet from parent view controller.
    /// - Parameter completion: Handle completion behavior here.
    public func dismiss(completion: (() -> Void)? = nil) {
        dismiss(with: 0.3, completion: completion)
    }
    
    private func dismiss(with duration: CGFloat = 0.3, completion: (() -> Void)? = nil) {
        delegate?.bottomSheetWillDismiss(bottomSheet: rootVC)
        
        animateBottomSheet(isShow: false, duration: duration, completion: { [weak self, weak parentVC] in
            guard let self = self, let parentVC = parentVC else { return }
            
            if let parentVC = parentVC as? UINavigationController {
                parentVC.interactivePopGestureRecognizer?.isEnabled = true
            }
            
            completion?()
            self.removeBottomSheetFromParent()
        })
    }
    
    // MARK: - Private behavior
    private func animateBottomSheet(isShow: Bool, duration: CGFloat = 0.5, completion: (() -> Void)? = nil) {
        bottomConstraint.constant = isShow ? 0 : rootVC.getTotalHeight()
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            self.maskView.alpha = isShow ? 1.0 : 0.0
            self.parentVC.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    private func addBottomSheetToChild() {
        if !parentVC.children.contains(navigation) {
            parentVC.view.addSubview(maskView)
            
            bottomConstraint = navigation.view.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor, constant: rootVC.getTotalHeight())
            
            parentVC.addChild(navigation)
            // This line will call child vc's viewWillAppear().
            navigation.beginAppearanceTransition(true, animated: true)
            parentVC.view.addSubview(navigation.view)
            navigation.didMove(toParent: parentVC)
            // This line will call child vc's viewDidAppear().
            navigation.endAppearanceTransition()
            
            navigation.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                navigation.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                navigation.view.heightAnchor.constraint(equalToConstant: rootVC.getTotalHeight()),
                navigation.view.leftAnchor.constraint(equalTo: parentVC.view.leftAnchor),
                navigation.view.rightAnchor.constraint(equalTo: parentVC.view.rightAnchor),
                bottomConstraint
            ])

            parentVC.view.layoutIfNeeded()
        }
    }
    
    private func removeBottomSheetFromParent() {
        maskView.removeFromSuperview()
        // This line will call child vc's viewWillDisappear().
        navigation.beginAppearanceTransition(false, animated: true)
        navigation.willMove(toParent: nil)
        navigation.view.removeFromSuperview()
        // This line will call child vc's viewDidDisappear().
        navigation.endAppearanceTransition()
        navigation.removeFromParent()
    }
    
    @objc private func handleMaskViewTapped() {
        dismiss()
    }
    
    /// Disable pan gesture when user is dragging view horizontally
    @objc private func handlePopGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            panGesture.isEnabled = false

        case .ended:
            panGesture.isEnabled = true

        default:
            break
        }
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        // offset of pan gesture
        let panOffsetY = sender.translation(in: navigation.view).y
        let velocityY = sender.velocity(in: navigation.view).y
        let swipeVelocity: CGFloat = 1500
        
        let isSwipeDown = velocityY > swipeVelocity
        let containerHeight: CGFloat = navigation.view.bounds.height
        let oneThirdOfHeight: CGFloat = containerHeight / 4
        
        switch sender.state {
        case .began, .changed:
            isDragging = true
            
            guard panOffsetY >= 0 else {
                return
            }
            
            bottomConstraint.constant = panOffsetY
            
            let alpha = 1.0 - (panOffsetY / containerHeight)
            maskView.alpha = alpha
            
            if !isSwipeDown {
                if panOffsetY > oneThirdOfHeight {
                    if !isReachTriggerPoint {
                        isReachTriggerPoint = true
                        impactHapticFeedback()
                    }
                } else {
                    if isReachTriggerPoint {
                        isReachTriggerPoint = false
                        impactHapticFeedback()
                    }
                }
            }
            
        case .ended:
            isDragging = false
            isReachTriggerPoint = false
            
            let duration = TimeInterval((containerHeight / UIScreen.main.bounds.size.height) * 0.5)
            
            // If pan offset more than half height, bottom sheet should be dismissed.
            if panOffsetY > oneThirdOfHeight {
                dismiss(with: duration)
            } else {
                if isSwipeDown {
                    dismiss(with: duration)
                } else {
                    animateBottomSheet(isShow: true)
                }
            }
            
        default:
            break
        }
    }
    
    private func impactHapticFeedback() {
        DispatchQueue.main.async {
            var feedback: UIImpactFeedbackGenerator
            if #available(iOS 13.0, *) {
                feedback = UIImpactFeedbackGenerator(style: .rigid)
            } else {
                feedback = UIImpactFeedbackGenerator(style: .medium)
            }
            
            feedback.impactOccurred()
        }
    }
}
