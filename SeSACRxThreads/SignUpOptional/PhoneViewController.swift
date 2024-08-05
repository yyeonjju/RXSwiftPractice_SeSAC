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
    
    
    let vm = PhoneViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()        
        bind()
    }
    
    private func bind() {
        let input = PhoneViewModel.Input(
            phoneInputValue: phoneTextField.rx.text,
            nextButtonTap: nextButton.rx.tap
        )
        let output = vm.transform(input: input)
        
        
        //010 기본적으로 쓰여있음
        output.defaultPrefixText
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        //유효성 만족하지 못할 때의 안내 문구
        output.validationNoticeText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        //입력 문자 중 숫자만 필터링한 텍스트로 텍스트 필드 채우기
        output.digitsOnlyText
            .bind(with: self) { owner, text in
                print("text --> ", text)
                owner.phoneTextField.text = text
            }
            .disposed(by: disposeBag)
        
        //10글자 이상인지 판별
        output.isValid
            .bind(with: self) { owner, isValid in
                owner.nextButton.backgroundColor = isValid ? .systemPink : .lightGray
                owner.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
       //화면전환
        output.pushToNextPage
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
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
