//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let validationNoticeText = BehaviorSubject(value: "")
    let defaultPrefixText = Observable.just("010")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    private func bind() {
        //010 기본적으로 쓰여있음
        defaultPrefixText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        validationNoticeText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        phoneTextField.rx.text.orEmpty
            .map(digitsOnly) //작성된 text에서 숫자값만 나올 수 있도록
            .bind(with: self) { owner, text in
                print("text --> ", text)
                owner.phoneTextField.text = text
                //이렇게 하면 이벤트 또 불려서 무한 루프에 갇힐 줄 알았는데
                //📍https://stackoverflow.com/questions/50558613/rxswift-replacement-shouldchangecharactersinrange#comment95908346_51814368 : `textField.text = newText` will not cause an event of rx.text controlProperty. If you want to force a text event you need to manually send valueChanged eventtextField.sendActions(for: .valueChanged)
                //즉, owner.phoneTextField.sendActions(for: .valueChanged) 해주지 않는 이상 무한 루프가 될 일이 없다!
                
                
                let isValid = text.count >= 10
                owner.nextButton.backgroundColor = isValid ? .systemPink : .lightGray
                owner.nextButton.isEnabled = isValid
                
                //❓숫자에 대한 판별이 우선 -> 숫자에 대한 유효성을 통과했다면 그 다음에 글자 길이 판별해주고 싶다면?
                //❓ 이 코드에서는 digitsOnly 메서드에서 유효성에 대해 validationNoticeText를 업데이트해주었어도 이 과정에서 덮어쓰여진다.
                //ex. textFielsDelegate에서의 replacement 메서드를 이용해서 작성한 문자에 대해 판별하고 -> addTarget의 editingChanged 이벤트로 문자 길이에 대한 유효성을 판별해주는 것 처럼
            }
            .disposed(by: disposeBag)
        
    }
    
    
    //숫자가 아닌 다른 문자가 있다면 숫자만 있도록 문자열 구성해서 리턴
    private func digitsOnly(_ text: String) -> String {
        if Int(text) == nil {
            validationNoticeText.onNext("숫자만 입력이 가능합니다.")
        }else {
            validationNoticeText.onNext("")
        }
        
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.textColor = .red
    }

}
