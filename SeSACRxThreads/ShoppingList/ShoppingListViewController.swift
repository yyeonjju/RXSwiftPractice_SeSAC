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
    
    private var shoppingData = [
        ShoppingItem(isDone: true, title: "그립톡 구매하기", isLiked: false),
        ShoppingItem(isDone: false, title: "사이다 구매", isLiked: true),
        ShoppingItem(isDone: false, title: "옷", isLiked: false)
    ]
    private lazy var shoppingList = BehaviorSubject(value: shoppingData)
    
    private let disposeBag = DisposeBag()
    
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
    }
    
    private func bind() {
        viewManager.tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.description())
        
        shoppingList
            .bind(to: viewManager.tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.description(), cellType: ShoppingListTableViewCell.self)) { (row, element, cell) in
                
                
                cell.configureData(data: element)
                cell.checkBoxButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.shoppingData[row].isDone.toggle()
                        owner.shoppingList.onNext(owner.shoppingData)
                    }
                    .disposed(by: cell.disposeBag)
                cell.isLikeButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.shoppingData[row].isLiked.toggle()
                        owner.shoppingList.onNext(owner.shoppingData)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        viewManager.addButton.rx.tap
            .bind(with: self) { owner, _ in
                //테이블뷰 데이터에 추가
                owner.shoppingData.insert(
                    ShoppingItem(isDone: false, title: owner.viewManager.textField.text ?? "-", isLiked: false),
                    at: 0
                )
                owner.shoppingList.onNext(owner.shoppingData)
                
                //텍스트필드 초기화
                owner.viewManager.textField.text = ""
            }
            .disposed(by: disposeBag)
        
        /*
         //검색 버튼 클릭했을 때 검색
         viewManager.searchbar.rx.searchButtonClicked
             .bind(with: self) { owner, _ in
                 let filtered = owner.shoppingData.filter{
                     $0.title.contains(owner.viewManager.searchbar.text ?? "")
                 }
                 owner.shoppingList.onNext(filtered)
             }
             .disposed(by: disposeBag)
         */

        
        //실시간 검색
        viewManager.searchbar.rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                guard let keyword = text else{return}
                
                if keyword.isEmpty {
                    owner.shoppingList.onNext(owner.shoppingData)
                } else {
                    let filtered = owner.shoppingData.filter{
                        $0.title.contains(keyword)
                    }
                    owner.shoppingList.onNext(filtered)
                }

            }
            .disposed(by: disposeBag)
        
        
    }
    
    
}
