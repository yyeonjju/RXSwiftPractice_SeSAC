//
//  ShoppingListView.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/4/24.
//

import UIKit
import SnapKit

final class ShoppingListView : UIView {
    // MARK: - UI
    
    let searchbar = {
        let sb = UISearchBar()
        sb.placeholder = "검색하세요"
        return sb
    }()
    
    let textField = {
       let tf = UITextField()
        tf.placeholder = "무엇을 구매하실건가요?"
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    let addButton = {
        let btn = UIButton()
        btn.setTitle(" 추가 ", for: .normal)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    let tableView = {
        let tv = UITableView()
//        tv.rowHeight = UITableView.automaticDimension
        tv.rowHeight = 60
        return tv
    }()
    

    
    // MARK: - Initializer
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        configureSubView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ConfigureUI
    
    private func configureSubView() {
        [searchbar, textField, addButton, tableView]
            .forEach{
                addSubview($0)
            }
    }
    
    private func configureLayout() {
        searchbar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(searchbar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalTo(textField.snp.trailing).offset(-10)
            make.verticalEdges.equalTo(textField).inset(10)
//            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }

}
