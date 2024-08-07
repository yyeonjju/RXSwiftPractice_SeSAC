//
//  RecommendationItemCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/7/24.
//

import UIKit
import SnapKit

final class RecommendationItemCollectionViewCell : UICollectionViewCell {
    let label = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(label)
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
