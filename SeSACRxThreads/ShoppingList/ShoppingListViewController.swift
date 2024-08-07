//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa

struct ShoppingItem {
    var isDone : Bool
    let title : String
    var isLiked : Bool
}


final class ShoppingListViewController : UIViewController {
    private let viewManager = ShoppingListView()
    private let vm = ShoppingListViewModel()

    private let disposeBag = DisposeBag()
    
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewManager.tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.description())
        viewManager.collectionView.register(RecommendationItemCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationItemCollectionViewCell.description())
        
        bind()
    }
    
    private func bind() {
        //몇번쨰가 클릭되었는지 int에 대한 이벤트 발생
        let checkboxButtonTap = PublishSubject<String>()
        let isLikeButtonTap = PublishSubject<String>()
        
        
        let input = ShoppingListViewModel.Input(
            addButtonTap: viewManager.addButton.rx.tap
            .withLatestFrom(viewManager.textField.rx.text),
            searchBarText :  viewManager.searchbar.rx.text,
            
            checkboxButtonTap : checkboxButtonTap,
            isLikeButtonTap : isLikeButtonTap,
            selectedRecommendationItemTitle : viewManager.collectionView.rx.modelSelected(String.self)
        )
        let output = vm.transform(input: input)
        
        output.shoppingList
            .bind(to: viewManager.tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.description(), cellType: ShoppingListTableViewCell.self)) { (row, element, cell : ShoppingListTableViewCell) in
                
                
                cell.configureData(data: element)
                cell.checkBoxButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        checkboxButtonTap.onNext(element.title)
                    }
                    .disposed(by: cell.disposeBag)
                cell.isLikeButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        isLikeButtonTap.onNext(element.title)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
        output.recommendaionItemList
            .bind(to: viewManager.collectionView.rx.items(cellIdentifier: RecommendationItemCollectionViewCell.description(), cellType: RecommendationItemCollectionViewCell.self)) {row, element, cell in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
    }
    
    
}
