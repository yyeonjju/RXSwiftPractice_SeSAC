//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa


final class ShoppingListViewModel {
    var shoppingData = [
        ShoppingItem(isDone: true, title: "그립톡 구매하기", isLiked: false),
        ShoppingItem(isDone: false, title: "사이다 구매", isLiked: true),
        ShoppingItem(isDone: false, title: "옷", isLiked: false)
    ]
    let disposeBag = DisposeBag()
    
    
    struct Input {
        let addButtonTap :  Observable<ControlProperty<String?>.Element>
        let search : ControlProperty<String?>
    }
    
    struct Output {
        let shoppingList : BehaviorSubject<[ShoppingItem]>
    }
    
    func transform(input : Input) -> Output {
        let totalDataSubject = BehaviorSubject(value: shoppingData)
       
        input.addButtonTap
            .bind(with: self) { owner, title in
                owner.shoppingData.insert(
                    ShoppingItem(isDone: false, title: title ?? "-", isLiked: false),
                    at: 0
                )
                
                totalDataSubject.onNext(owner.shoppingData)
            }
            .disposed(by: disposeBag)
        

        input.search
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                guard let keyword = text else{return}

                if keyword.isEmpty {
                    totalDataSubject.onNext(owner.shoppingData)
                } else {
                    let filtered = owner.shoppingData.filter{
                        $0.title.contains(keyword)
                    }
                    totalDataSubject.onNext(filtered)
                }

            }
            .disposed(by: disposeBag)
        
        return Output(shoppingList: totalDataSubject)
    }
    
    
}
