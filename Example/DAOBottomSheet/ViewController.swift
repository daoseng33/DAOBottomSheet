//
//  ViewController.swift
//  DAOBottomSheet
//
//  Created by daoseng33 on 08/28/2024.
//  Copyright (c) 2024 daoseng33. All rights reserved.
//

import UIKit
import DAOBottomSheet
import SnapKit

class ViewController: UITableViewController {

    enum CellType: Int, CaseIterable {
        case fixedHeight300
        case fixedHeight1000
        case flexibleHeight100
        case flexibleHeight500
        case flexibleHeight1000
        case customList
        
        var title: String {
            switch self {
            case .fixedHeight300:
                return "fixed height 300"
                
            case .fixedHeight1000:
                return "fixed height 1000"
                
            case .flexibleHeight100:
                return "flexible height 100"
                
            case .flexibleHeight500:
                return "flexible height 500"
                
            case .flexibleHeight1000:
                return "flexible height 1000"
                
            case .customList:
                return "custom list"
            }
        }
    }
    
    var bottomSheet: DAOBottomSheet?
    
    lazy var customTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return CellType.allCases.count
            
        case customTableView:
            return 20
            
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tableView:
            let type = CellType(rawValue: indexPath.row)!
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = type.title
            
            return cell
            
        case customTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = "row \(indexPath.row)"
            
            return cell
            
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            let type = CellType(rawValue: indexPath.row)!
            let bottomSheetType: DAOBottomSheetViewController.BottomSheetType
            let tag: Int
            
            switch type {
            case .fixedHeight300:
                bottomSheetType = .fixed
                tag = 0
                
            case .fixedHeight1000:
                bottomSheetType = .fixed
                tag = 1
                
            case .flexibleHeight100:
                bottomSheetType = .flexible
                tag = 2
                
            case .flexibleHeight500:
                bottomSheetType = .flexible
                tag = 3
                
            case .flexibleHeight1000:
                bottomSheetType = .flexible
                tag = 4
                
            case .customList:
                bottomSheetType = .fixed
                tag = 5
            }
            
            bottomSheet = DAOBottomSheet(parentVC: self, title: "Title", type: bottomSheetType)
            bottomSheet?.tag = tag
            bottomSheet?.delegate = self
            bottomSheet?.show()
            
        case customTableView:
            let vc = DAOBottomSheetViewController()
            vc.view.backgroundColor = .white
            bottomSheet?.navigation.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
    }
}

extension ViewController: DAOBottomSheetDelegate {
    func setupDAOBottomSheetContentUI(bottomSheet: DAOBottomSheetViewController) -> UIView? {
        let type = CellType(rawValue: bottomSheet.tag)!
        
        switch type {
        case .fixedHeight300:
            let button = UIButton()
            button.setTitle("fixed 300", for: .normal)
            button.setTitleColor(UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1), for: .normal)
            
            button.snp.makeConstraints {
                $0.height.equalTo(300)
            }
            
            button.addTarget(self, action: #selector(fixed300ButtonTapped), for: .touchUpInside)
            
            return button
            
        case .fixedHeight1000:
            let button = UIButton()
            button.setTitle("fixed 1000", for: .normal)
            button.setTitleColor(UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1), for: .normal)
            
            button.snp.makeConstraints {
                $0.height.equalTo(1000)
            }
            
            button.addTarget(self, action: #selector(fixed1000ButtonTapped), for: .touchUpInside)
            
            return button
            
        case .flexibleHeight100:
            let label = UILabel()
            label.attributedText = NSMutableAttributedString(string: "flexible 100").typography(.bodyLg)
            
            label.textAlignment = .center
            
            label.snp.makeConstraints {
                $0.height.equalTo(100)
            }
            
            return label
            
        case .flexibleHeight500:
            let label = UILabel()
            label.attributedText = NSMutableAttributedString(string: "flexible 500").typography(.bodyLg)

            label.textAlignment = .center
            
            label.snp.makeConstraints {
                $0.height.equalTo(500)
            }
            
            return label
            
        case .flexibleHeight1000:
            let label = UILabel()
            label.attributedText = NSMutableAttributedString(string: "flexible 1000").typography(.bodyLg)

            label.textAlignment = .center
            
            label.snp.makeConstraints {
                $0.height.equalTo(1000)
            }
            
            return label
            
        default:
            return nil
        }
    }
    
    func setupCustomContentScrollView(bottomSheet: DAOBottomSheetViewController) -> UIScrollView? {
        let type = CellType(rawValue: bottomSheet.tag)!
        
        switch type {
        case .customList:
            return customTableView
            
        default:
            return nil
        }
    }
    
    func setupHeaderSlotContent(with bottomSheet: DAOBottomSheetViewController) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "header slot"
        
        label.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        return label
    }
    
    func setupFooterContentView(with bottomSheet: DAOBottomSheetViewController) -> UIView? {
        let button: UIButton = {
           let button = UIButton()
            button.setTitle("Footer action >", for: .normal)
            button.setTitleColor(UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1), for: .normal)
            button.layer.borderWidth = 1
            
            return button
        }()
        
        button.addTarget(self, action: #selector(footerBottomTapped), for: .touchUpInside)

        return button
    }
    
    func setupFooterSlotContent(with bottomSheet: DAOBottomSheetViewController) -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "footer slot"
        
        label.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        return label
    }

    @objc func fixed300ButtonTapped() {
        let vc = DAOBottomSheetViewController()
        vc.view.backgroundColor = .white
        bottomSheet?.navigation.pushViewController(vc, animated: true)
    }
    
    @objc func fixed1000ButtonTapped() {
        let vc = DAOBottomSheetViewController()
        vc.view.backgroundColor = .white
        bottomSheet?.navigation.pushViewController(vc, animated: true)
    }
    
    @objc func footerBottomTapped() {
        let alert = UIAlertController(title: "footer action", message: "tapped", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(confirm)
        bottomSheet?.rootVC.present(alert, animated: true, completion: nil)
    }
}

