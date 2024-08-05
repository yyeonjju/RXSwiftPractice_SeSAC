//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 하연주 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa


final class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let selectedDate : ControlProperty<Date>
        let nextButtonTap : ControlEvent<Void>
    }
    struct Output{
        let yearSubject : BehaviorRelay<String>
        let monthSubject : BehaviorRelay<String>
        let daySubject : BehaviorRelay<String>
        let isAcceptableAge : BehaviorRelay<Bool>
        let pageTransition : ControlEvent<Void>
    }
    
    
    func transform (input : Input) -> Output {
        let yearSubject = BehaviorRelay(value: "")
        let monthSubject = BehaviorRelay(value: "")
        let daySubject = BehaviorRelay(value: "")
        let isAcceptableAge = BehaviorRelay(value: false)
        
        input.selectedDate
            .bind { date in
                let dateComponents =  Calendar.current.dateComponents([.year, .month,.day], from: date)
                yearSubject.accept("\(dateComponents.year?.description ?? "-") 년")
                monthSubject.accept("\(dateComponents.month?.description ?? "-") 월")
                daySubject.accept("\(dateComponents.day?.description ?? "-") 일")
                
                let ageComponents = Calendar.current.dateComponents([.year], from: date, to: Date())
                let age = ageComponents.year!
                isAcceptableAge.accept(age>=17)
                
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            yearSubject: yearSubject,
            monthSubject: monthSubject,
            daySubject: daySubject,
            isAcceptableAge: isAcceptableAge,
            pageTransition : input.nextButtonTap
        )
    }
    
}
