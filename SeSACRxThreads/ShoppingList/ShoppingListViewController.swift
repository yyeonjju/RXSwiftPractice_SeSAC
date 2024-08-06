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
        
        bind()
    }
    
    private func bind() {
        let input = ShoppingListViewModel.Input(
            addButtonTap: viewManager.addButton.rx.tap
            .withLatestFrom(viewManager.textField.rx.text),
            search :  viewManager.searchbar.rx.text
        )
        let output = vm.transform(input: input)
        
        output.shoppingList
            .bind(to: viewManager.tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.description(), cellType: ShoppingListTableViewCell.self)) { (row, element, cell : ShoppingListTableViewCell) in
                
                
                cell.configureData(data: element)
//                cell.checkBoxButton.rx.tap
//                    .subscribe(with: self) { owner, _ in
//                        owner.shoppingData[row].isDone.toggle()
//                        owner.shoppingList.onNext(owner.shoppingData)
//                    }
//                    .disposed(by: cell.disposeBag)
//                cell.isLikeButton.rx.tap
//                    .subscribe(with: self) { owner, _ in
//                        owner.shoppingData[row].isLiked.toggle()
//                        owner.shoppingList.onNext(owner.shoppingData)
//                    }
//                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
    }
    
    
}
