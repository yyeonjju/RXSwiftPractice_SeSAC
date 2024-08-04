//
//  ShoppingListTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift

final class ShoppingListTableViewCell : UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    //⭐️
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    // MARK: - UI
    private let contentsBackground : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    let checkBoxButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        btn.tintColor = .systemGreen
        return btn
    }()
    
    private let label = {
        let label = UILabel()
        label.text = "--gkgk-"
        label.numberOfLines = 0
        return label
    }()
    
    
    let isLikeButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        btn.tintColor = .systemYellow
        return btn
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubView()
        configureLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureData (data : ShoppingItem) {
        checkBoxButton.setImage(UIImage(systemName: "checkmark.square\(data.isDone ? ".fill" : "")"), for: .normal)
        
        label.text = data.title
        isLikeButton.setImage(UIImage(systemName: "star\(data.isLiked ? ".fill" : "")"), for: .normal)
    }
    
    // MARK: - ConfigureUI
    
    private func configureSubView() {
        [contentsBackground, checkBoxButton, label, isLikeButton]
            .forEach{
                contentView.addSubview($0)
            }
    }
    
    private func configureLayout() {
        contentsBackground.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(1)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(25)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(10)
            make.trailing.equalTo(isLikeButton.snp.leading).offset(-10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        isLikeButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }

}
