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
    var searchKeyword : String?
    let disposeBag = DisposeBag()
    lazy var outputListSubject = BehaviorSubject(value: shoppingData)
    
    
    struct Input {
        let addButtonTap :  Observable<ControlProperty<String?>.Element>
        let searchBarText : ControlProperty<String?>
        
        //셀의 체크박스 버튼, 좋아요 버튼 클릭했을 때 발생하는 이벤트
        //(title값 전달받음)
        let checkboxButtonTap : PublishSubject<String>
        let isLikeButtonTap : PublishSubject<String>
    }
    
    struct Output {
        let shoppingList : BehaviorSubject<[ShoppingItem]>
    }
    
    func transform(input : Input) -> Output {

       
        input.addButtonTap
            .bind(with: self) { owner, title in
                
                owner.shoppingData.insert(
                    ShoppingItem(isDone: false, title: title ?? "-", isLiked: false),
                    at: 0
                )
                
                guard let keyword = owner.searchKeyword else{return}
                owner.filterWithSearchKeyword(keyword)

            }
            .disposed(by: disposeBag)
        

        //실시간 검색
        input.searchBarText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                guard let keyword = text else{return}
                owner.searchKeyword = keyword
                owner.filterWithSearchKeyword(keyword)

            }
            .disposed(by: disposeBag)
        
        
        
        input.checkboxButtonTap
            .subscribe(with: self) { owner, title in
                let selectedIndex = owner.shoppingData.firstIndex(where: {$0.title == title})!
                owner.shoppingData[selectedIndex].isDone.toggle()
                guard let keyword = owner.searchKeyword else{return}
                owner.filterWithSearchKeyword(keyword)
            }.disposed(by: disposeBag)
        
        
        
        input.isLikeButtonTap
            .subscribe(with: self) { owner, title in
                let selectedIndex = owner.shoppingData.firstIndex(where: {$0.title == title})!
                owner.shoppingData[selectedIndex].isLiked.toggle()
                guard let keyword = owner.searchKeyword else{return}
                owner.filterWithSearchKeyword(keyword)
            }.disposed(by: disposeBag)
        
        
        return Output(shoppingList: outputListSubject)
    }
    
    
    
    private func filterWithSearchKeyword(_ keyword : String) {
        //검색 및 추가,체크박스버튼/좋아요버튼클릭 했을 때 지금 검색한 키워드가 있다면 필터링해서 보여주기

        if keyword.isEmpty {
            outputListSubject.onNext(shoppingData)
        } else {
            let filtered = shoppingData.filter{
                $0.title.contains(keyword)
            }
            outputListSubject.onNext(filtered)
        }
    }
    
    
}
