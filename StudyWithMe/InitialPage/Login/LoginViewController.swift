//
//  ViewController.swift
//  StudyWithMe
//
//  Created by 배한결 on 2021/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idInputTextField: InputTextField!
    @IBOutlet weak var passwordInputTextField: InputTextField!
    @IBOutlet weak var signInButton: ShadowingButton!
    @IBOutlet weak var signUpButton: ShadowingButton!
    @IBOutlet weak var loginFailLabel: UILabel!
    @IBOutlet weak var autoLoginCheckBox: UIImageView!
    @IBOutlet weak var saveIdCheckBox: UIImageView!
    @IBOutlet weak var autoLogin: UIStackView!
    @IBOutlet weak var saveId: UIStackView!
    
    
    private final let  uncheck_image = UIImage(systemName: "circle", compatibleWith: nil)
    
    private final let check_image = UIImage(systemName: "checkmark.circle.fill", compatibleWith: nil)
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        input()
        output()
    }
    
    
}

extension LoginViewController {
    
    func input(){
        self.signInButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000),latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.login)
            .disposed(by: disposeBag)
        
        self.signUpButton.rx.tap.asObservable()
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext:{[weak self] _ in
                self?.moveToSignUpPage()
            })
            .disposed(by: disposeBag)
        
        self.idInputTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(1000), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .bind(to: viewModel.input.idTextField)
            .disposed(by: disposeBag)
        
        self.passwordInputTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.passwordTextField)
            .disposed(by: disposeBag)
        
        self.idInputTextField.clearButton.rx.tap.asObservable()
            .subscribe(onNext:{[weak self] _ in
                self?.clearInputId()
            })
            .disposed(by: disposeBag)
        
        
        self.passwordInputTextField.clearButton.rx.tap.asObservable()
            .subscribe(onNext:{[weak self] _ in
                self?.clearInputPw()
            })
            .disposed(by: disposeBag)
    }
    
    func output(){
        self.viewModel.output.login.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{[weak self] result in
                        self?.handleLoginResult(result: result)})
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    func handleLoginResult(result : LoginViewModel.LoginResult){
        switch result {
        case .success :
            // 로그인 성공 처리 -> 메인 페이지로 이동
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let main = mainStoryboard.instantiateViewController(identifier: "MainNavigationVC") as! UINavigationController
            
            main.modalTransitionStyle = .crossDissolve
            main.modalPresentationStyle = .overFullScreen
            
            self.present(main, animated: true) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                
            }
            
        case .inValidInput(let text) :
            if text.count > 4 {
                idInputTextField.configureView(isWrong:true)
                passwordInputTextField.configureView(isWrong:true)
            }
            else if text == "아이디" {
                idInputTextField.configureView(isWrong: true)
                passwordInputTextField.configureView(isWrong: false)
            }else{
                idInputTextField.configureView(isWrong: false)
                passwordInputTextField.configureView(isWrong: true)
            }
            
            loginFailLabel.text = "\(text)를 입력해주세요."
            
        case .nonexistentUser:
            idInputTextField.configureView(isWrong: true)
            passwordInputTextField.configureView(isWrong: false)
            loginFailLabel.text = "존재하지 않는 아이디 입니다."
            break
        case .inconsistentUser:
            idInputTextField.configureView(isWrong: false)
            passwordInputTextField.configureView(isWrong: true)
            loginFailLabel.text = "아이디와 비밀번호가 일치하지 않습니다."
            break
        case .failure :
            break
        }
        
    }
}

extension LoginViewController {
    
    func createView(){
        createIdInputTextField()
        createPasswordInputTextField()
        createLoginButton()
        createSignUpButton()
        createLoginFailLabel()
        configureViews()
        createAutoLogin()
        createSaveId()
        
    }
    
    func createIdInputTextField(){
        idInputTextField.setPlaceHolder("아이디를 입력해 주세요.")
        idInputTextField.keyboardType = .alphabet
        
        // 아이디 저장이 설정되어 있다면 아이디를 불러온다.
        if UserDefaults.standard.bool(forKey: "SAVE_ID"){
            idInputTextField.text = UserDefaults.standard.string(forKey: "SAVED_ID")
        }
        
    }
    
    func createPasswordInputTextField(){
        passwordInputTextField.setPlaceHolder("비밀번호를 입력해 주세요.")
        passwordInputTextField.keyboardType = .default
        passwordInputTextField.isSecureTextEntry = true
    }
    
    func createLoginButton(){
        signInButton.layer.backgroundColor = UIColor.Service.mainDarkBlue.value.cgColor
        signInButton.layer.shadowColor  = UIColor.lightGray.cgColor
        signInButton.titleLabel?.textColor = UIColor.white
    }
    
    func createSignUpButton(){
        signUpButton.layer.backgroundColor = UIColor.white.cgColor
        signUpButton.layer.shadowColor  = UIColor.lightGray.cgColor
        signUpButton.setTitleColor(UIColor.Service.mainDarkBlue.value, for: .normal)
        
    }
    
    func createLoginFailLabel(){
        loginFailLabel.textColor = UIColor.Service.mainDarkBlue.value
    }
    
    func configureViews(){
        view.layoutIfNeeded()
        signInButton.layer.cornerRadius = signInButton.frame.height / 2.0
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2.0
        idInputTextField.initView()
        passwordInputTextField.initView()
    }
    
    func createAutoLogin(){
        autoLoginCheckBox.tintColor = UIColor.Service.yellow.value
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(autoLogin(_:)))
        autoLogin.addGestureRecognizer(tapGesture)
        
        let state = UserDefaults.standard.bool(forKey: "AUTO_LOGIN")
        if state {
            autoLoginCheckBox.image = check_image
        }
    }
    
    func createSaveId(){
        saveIdCheckBox.tintColor = UIColor.Service.yellow.value
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveId(_:)))
        saveId.addGestureRecognizer(tapGesture)
        
        let state = UserDefaults.standard.bool(forKey: "SAVE_ID")
        if state {
            saveIdCheckBox.image = check_image
        }
    }
    
    func clearInputId(){
        self.idInputTextField.text = ""
        viewModel.input.idTextField.accept("")
    }
    
    func clearInputPw(){
        self.passwordInputTextField.text = ""
        viewModel.input.passwordTextField.accept("")
    }
}

extension LoginViewController {
    // 화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){ self.view.endEditing(true)
    }
    
    func moveToSignUpPage(){
        // 로그인 성공 처리 -> 메인 페이지로 이동
        let signUp = self.storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpViewController
        
        signUp.modalTransitionStyle = .crossDissolve
        signUp.modalPresentationStyle = .overFullScreen
        
        self.present(signUp, animated: true)
    }
}

// 자동 로그인, 아이디 저장 처리
extension LoginViewController {
    @objc func autoLogin(_ gesture : UIGestureRecognizer){
        
        let before = UserDefaults.standard.bool(forKey: "AUTO_LOGIN") //이전 값 가져오기
        
        // toogle
        if before {
            autoLoginCheckBox.image = uncheck_image
            UserDefaults.standard.set(false,forKey: "AUTO_LOGIN")
        }
        else {
            autoLoginCheckBox.image = check_image
            UserDefaults.standard.set(true,forKey: "AUTO_LOGIN")
        }
    }
    
    @objc func saveId(_ gesture : UIGestureRecognizer){
        let before = UserDefaults.standard.bool(forKey: "SAVE_ID") //이전 값 가져오기
        
        // toogle
        if before {
            saveIdCheckBox.image = uncheck_image
            UserDefaults.standard.set(false,forKey: "SAVE_ID")
        }
        else {
            saveIdCheckBox.image = check_image
            UserDefaults.standard.set(true,forKey: "SAVE_ID")
        }
    }
}

