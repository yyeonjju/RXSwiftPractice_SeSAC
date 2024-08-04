//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    
    //1️⃣ 이벤트를 방출하고 받는 두 가지 역할이 모두 필요함 => Subject
    //Subject는 onNext, OnComplete, OnError 이벤트 종류 모두 받지만
    //2️⃣ 이벤트 처리할 때 error나 complete이 발생하지 않는 작업. ex. UI의 업데이트
    //-> BehaviorRelay
    let yearSubject = BehaviorRelay(value: "")
    let monthSubject = BehaviorRelay(value: "")
    let daySubject = BehaviorRelay(value: "")
    
    
    //가입 가능한 나이인지
    //1️⃣ 이벤트 방출하고 처리하는 역할이 모두 필요
    //2️⃣ 이벤트 처리 시 UI 업데이트이기 때문에 error, complete 일어날 일 없음
    let isAcceptableAge = BehaviorRelay(value: false)
    
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
//        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
//        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
//        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
//        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    private func bind() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let dateComponents =  Calendar.current.dateComponents([.year, .month,.day], from: date)
                owner.yearSubject.accept("\(dateComponents.year?.description ?? "-") 년")
                owner.monthSubject.accept("\(dateComponents.month?.description ?? "-") 월")
                owner.daySubject.accept("\(dateComponents.day?.description ?? "-") 일")
                
                
                let ageComponents = Calendar.current.dateComponents([.year], from: date, to: Date())
                let age = ageComponents.year!
                owner.isAcceptableAge.accept(age>=17)
                
            }
            .disposed(by: disposeBag)
        
        
        //label의 text 없데이트
        yearSubject
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        monthSubject
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        daySubject
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        //유효성에 따른 UI 변화
        isAcceptableAge
            .bind(with: self) { owner, isAcceptable in
                //infoLabel 업데이트
                owner.infoLabel.textColor = isAcceptable ? .lightGray : .red
                owner.infoLabel.text = isAcceptable ? "가입가능한 나이입니다." : "17세 이상만 가입 가능합니다"
                
                //nextButton 업데이트
                owner.nextButton.backgroundColor = isAcceptable ? .systemPink : .lightGray
                owner.nextButton.isEnabled = isAcceptable
            }
            .disposed(by: disposeBag)
        
        
        
        //가입하기 버튼 눌렀을 때
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                //1. 얼럿 컨트롤러
                let alert = UIAlertController(title: "가입을 완료하시겠습니까?", message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title: "열기", style: .default){_ in 
                    
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.changeRootVCToSearch()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(confirm)
                alert.addAction(cancel)

                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(SearchViewController(), animated: true)
//    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
