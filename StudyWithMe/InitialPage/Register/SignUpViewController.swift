//
//  SignUpViewController.swift
//  StudyWithMe
//
//  Created by 배한결 on 2021/11/02.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var idTextField: InputTextField!
    @IBOutlet weak var passwordTextField: InputTextField!
    @IBOutlet weak var passwordCheckTextField: InputTextField!
    
    @IBOutlet weak var nameTextField: InputTextField!
    @IBOutlet weak var emailTextField: InputTextField!
    
    @IBOutlet weak var signUpButton: ShadowingButton!
    
    @IBOutlet weak var signUpFailLabel: UILabel!
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        input()
        output()
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SignUpViewController {
    func input(){

        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.input.nameTextField)
            .disposed(by: disposeBag)
        
        idTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.idTextField)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.pwTextField)
            .disposed(by: disposeBag)
        
        passwordCheckTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.pwCheckTextField)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.emailTextField)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.register)
            .disposed(by: disposeBag)
        
        nameTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.clearInputName()
            }).disposed(by: disposeBag)
        
        idTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext:  {[weak self] _ in
                self?.clearInputId()
            }).disposed(by: disposeBag)
        
        passwordTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: {[weak self] _ in
                self?.clearInputPw()
            }).disposed(by: disposeBag)
        
        passwordCheckTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext: {[weak self] _ in
                self?.clearInputPwCheck()
            }).disposed(by: disposeBag)
        
        emailTextField.clearButton.rx.tap
            .asObservable()
            .subscribe(onNext:{[weak self] _ in
                self?.clearInputEmail()
            }).disposed(by: disposeBag)
    }
    
    func output(){
        viewModel.output.register
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{[weak self] result in
                self?.handleRegisterResult(result: result)
            }).disposed(by: disposeBag)
    }
}



extension SignUpViewController {
    
    func createView(){
        view.backgroundColor = UIColor.white
        createNameInputTextField()
        createIdInputTextField()
        createPasswordInputTextField()
        createCheckPasswordInputTextField()
        createSignUpButton()
        createEmailTextField()
        configureViews()
    }
    
    func createNameInputTextField(){
        nameTextField.setPlaceHolder("이름")
        nameTextField.keyboardType = .default
        nameTextField.configureBorderColor(UIColor.Service.borderGray.value)
    }
    
    
    func createIdInputTextField(){
        idTextField.setPlaceHolder("아이디 (영문,숫자)")
        idTextField.keyboardType = .alphabet
        idTextField.configureBorderColor(UIColor.Service.borderGray.value)
    }
    
    func createPasswordInputTextField(){
        passwordTextField.setPlaceHolder("비밀번호 (6자리 이상)")
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.configureBorderColor(UIColor.Service.borderGray.value)
    }
    
    func createCheckPasswordInputTextField(){
        passwordCheckTextField.setPlaceHolder("비밀번호 확인")
        passwordCheckTextField.keyboardType = .default
        passwordCheckTextField.isSecureTextEntry = true
        passwordCheckTextField.configureBorderColor(UIColor.Service.borderGray.value)
    }
    
    func createSignUpButton(){
        signUpButton.layer.backgroundColor = UIColor.Service.yellow.value.cgColor
        signUpButton.titleLabel?.textColor = UIColor.Service.mainDarkBlue.value
        signUpButton.configureShadowColor(UIColor.Service.shadowGray.value)
    }
    
    func createEmailTextField(){
        emailTextField.setPlaceHolder("이메일")
        emailTextField.keyboardType = .default
        emailTextField.configureBorderColor(UIColor.Service.borderGray.value)
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2.0
        idTextField.initView()
        passwordTextField.initView()
        nameTextField.initView()
        passwordCheckTextField.initView()
        emailTextField.initView()
    }
}

extension SignUpViewController {
    
    func handleRegisterResult(result : SignUpViewModel.SignUpResult){
        switch result{
        case .success :
            // 로그인 성공 처리 -> 메인 페이지로 이동
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let main = mainStoryboard.instantiateViewController(identifier: "MainNavigationVC") as! UINavigationController
            
            main.modalTransitionStyle = .crossDissolve
            main.modalPresentationStyle = .overFullScreen
            
            self.present(main, animated: true) { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            }
        case .failure :
            break
        case.invalidName :
            self.nameTextField.configureView(isWrong: true)
        case .validName :
            self.nameTextField.configureView(isWrong: false)
        case .invalidId :
            self.idTextField.configureView(isWrong: true)
        case .validId :
            self.idTextField.configureView(isWrong: false)
        case .alreadyExists :
            self.idTextField.configureView(isWrong: true)
            self.signUpFailLabel.text = "이미 존재하는 아이디 입니다."
        case .invalidPassword :
            self.passwordTextField.configureView(isWrong: true)
        case .validPassword :
            self.passwordTextField.configureView(isWrong: false)
        case .invalidCheckPassword :
            self.passwordCheckTextField.configureView(isWrong: true)
        case .validCheckPassword :
            self.passwordCheckTextField.configureView(isWrong: false)
        case .invalidEmail:
            self.emailTextField.configureView(isWrong: true)
        case .validEmail:
            self.emailTextField.configureView(isWrong: false)
        case let .invalidInputRegister(term) :
            self.signUpFailLabel.text = term
        }
    }
    
    func clearInputId(){
        self.idTextField.text = ""
        self.viewModel.input.idTextField.accept("")
    }
    
    func clearInputName(){
        self.nameTextField.text = ""
        self.viewModel.input.nameTextField.accept("")
    }
    func clearInputPw(){
        self.passwordTextField.text = ""
        self.viewModel.input.pwTextField.accept("")
    }
    
    func clearInputPwCheck(){
        self.passwordCheckTextField.text = ""
        self.viewModel.input.pwCheckTextField.accept("")
    }
    
    func clearInputEmail(){
        self.emailTextField.text = ""
        self.viewModel.input.emailTextField.accept("")
    }
}

extension SignUpViewController {
    //화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
