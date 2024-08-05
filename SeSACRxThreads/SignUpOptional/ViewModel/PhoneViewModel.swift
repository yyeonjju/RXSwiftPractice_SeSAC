//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    let minimumTextCount = 10
    
    let validationNoticeText = BehaviorSubject(value: "")
    let disposeBag = DisposeBag()
    
    
    struct Input {
        let phoneInputValue : ControlProperty<String?>
        let nextButtonTap : ControlEvent<Void>
    }
    
    struct Output {
        let defaultPrefixText : Observable<String>
        let validationNoticeText : BehaviorSubject<String>
        //validation
        let digitsOnlyText : Observable<String>
        let isValid : Observable<Bool>
        //화면전환
        let pushToNextPage : ControlEvent<Void>
    }
    
    
    
    func transform(input : Input) -> Output {
        let defaultPrefixText = Observable.just("010")

        
        let digitsOnly = input.phoneInputValue.orEmpty
            .map(digitsOnly)
            .share()
        
        let isValid = digitsOnly
            .withUnretained(self)
            .map { owner,text in
                return text.count >= owner.minimumTextCount
            }
        
        
        return Output(
            defaultPrefixText: defaultPrefixText,
            validationNoticeText: validationNoticeText,
            digitsOnlyText : digitsOnly,
            isValid : isValid,
            pushToNextPage : input.nextButtonTap
        )
    }
    
    //숫자가 아닌 다른 문자가 있다면 숫자만 있도록 문자열 구성해서 리턴
    private func digitsOnly(_ text: String) -> String {
        let digitsOnlyText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if Int(text) == nil {
            validationNoticeText.onNext("숫자만 입력이 가능합니다.")
        } else if digitsOnlyText.count < minimumTextCount {
            validationNoticeText.onNext("10글자 이상으로 입력해주세요")
        } else {
            validationNoticeText.onNext("")
        }

        return digitsOnlyText
    }
    

    
}
