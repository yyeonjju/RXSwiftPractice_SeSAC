//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let validText = Observable.just("8자 이상 입력해주세요")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bind()
    }
    
    private func bind() {
        validText
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        passwordTextField.rx.text.orEmpty
            .map{$0.count > 8}
            .bind(with: self) { owner, isValid in
                //📍isValid가 true 일 경우
                //=> nextButton Pink & 클릭할 수 있다, descriptionLabel가 사라진다.
                //📍isValid가 false일 경우
                //=> nextButton lightGray & 클릭할 수 없다, descriptionLabel로 상태를 알려준다

                owner.nextButton.backgroundColor = isValid ? .systemPink : .lightGray
                owner.nextButton.isEnabled = isValid
                owner.descriptionLabel.isHidden = isValid
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
        
        descriptionLabel.textColor = .red
    }

}
