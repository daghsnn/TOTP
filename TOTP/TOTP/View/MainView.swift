//
//  MainView.swift
//  TOTP
//
//  Created by Hasan Dag on 22.12.2021.
//

import Foundation
import UIKit
import SnapKit

final class MainView : UIView {
    // MARK:- Varibles
    var timer = AppConstants.kTIME {
        didSet{
            self.timeLbl.text = "\(timer)"
        }
    }
    
    var progressionValue : Float = 0 {
        didSet{
            DispatchQueue.main.async {
                self.progressView.setProgress(self.progressionValue, animated: true)
            }
        }
    }
    var algorthm: OTPAlgorithm = .sha1 {
        didSet{
            createToken(algorithm: algorthm)
        }
    }
    // MARK:- UI Elements
    private lazy var algorthmLbl: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Select an Algorithm"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var segmentedCntr: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["SHA1","SHA256","SHA512"])
        segment.tintColor = .white
        segment.backgroundColor = .darkGray
        segment.selectedSegmentTintColor = .systemBlue
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        return segment
    }()
    
    private lazy var progressView: UIProgressView = {
        let progresView = UIProgressView(progressViewStyle: .default)
        progresView.trackTintColor = UIColor.darkGray
        progresView.progressTintColor = UIColor.red
        progresView.layer.cornerRadius = 10
        return progresView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.axis = .horizontal
        stack.isBaselineRelativeArrangement = true
        return stack
    }()
    
    private lazy var timeLbl: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Time"
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    //
    private lazy var firtTxt: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.textAlignment = .center
        txt.layer.cornerRadius = 5
        txt.layer.borderColor = UIColor.darkText.cgColor
        txt.layer.borderWidth = 1
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    private lazy var secondTxt: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.textAlignment = .center
        txt.layer.cornerRadius = 5
        txt.layer.borderColor = UIColor.darkText.cgColor
        txt.layer.borderWidth = 1
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    private lazy var thirdTxt: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.textAlignment = .center
        txt.layer.cornerRadius = 5
        txt.layer.borderColor = UIColor.darkText.cgColor
        txt.layer.borderWidth = 1
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    private lazy var fourthTxt: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.textAlignment = .center
        txt.layer.cornerRadius = 5
        txt.layer.borderColor = UIColor.darkText.cgColor
        txt.layer.borderWidth = 1
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    private lazy var fivethTxt: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.textAlignment = .center
        txt.layer.cornerRadius = 5
        txt.layer.borderColor = UIColor.darkText.cgColor
        txt.layer.borderWidth = 1
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    private lazy var sixthTxt: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.textAlignment = .center
        txt.layer.cornerRadius = 5
        txt.layer.borderColor = UIColor.darkText.cgColor
        txt.layer.borderWidth = 1
        txt.isUserInteractionEnabled = false
        return txt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        configureUI()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
  
        createToken(algorithm: algorthm)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI(){
        addSubview(algorthmLbl)
        addSubview(segmentedCntr)
        addSubview(stackView)
        stackView.addArrangedSubview(firtTxt)
        stackView.addArrangedSubview(secondTxt)
        stackView.addArrangedSubview(thirdTxt)
        stackView.addArrangedSubview(fourthTxt)
        stackView.addArrangedSubview(fivethTxt)
        stackView.addArrangedSubview(sixthTxt)
        addSubview(progressView)
        addSubview(timeLbl)
        
        configureConstraints()
    }
    
    fileprivate func configureConstraints(){
        algorthmLbl.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview().inset(UIView.height * 0.15)
        }
        
        segmentedCntr.snp.makeConstraints { (maker) in
            maker.top.equalTo(algorthmLbl.snp.bottom).offset(UIView.height * 0.075)
            maker.width.equalToSuperview().multipliedBy(0.7)
            maker.height.equalTo(UIView.height * 0.1)
            maker.centerX.equalToSuperview()
            
        }
        stackView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.equalTo(UIView.height * 0.05)
            maker.width.equalTo(UIView.width * 0.5)
        }
        
        timeLbl.snp.makeConstraints { (maker) in
            maker.top.equalTo(stackView.snp.bottom).offset(UIView.height * 0.2)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        progressView.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeLbl.snp.bottom).offset(UIView.height * 0.1)
            maker.width.equalTo(UIView.width * 0.7)
            maker.centerX.equalToSuperview()
        }
    }
    
    
    // MARK:- Time OTP Functions

    fileprivate func randomString(algorthm: OTPAlgorithm) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        switch algorthm {
        case .sha1:
            return String((0..<20).map{ _ in letters.randomElement()! })
        case .sha256:
            return String((0..<32).map{ _ in letters.randomElement()! })
        case .sha512:
            return String((0..<64).map{ _ in letters.randomElement()! })
        }
    }
    
    fileprivate func createToken(algorithm:OTPAlgorithm){
        self.timer = AppConstants.kTIME
        self.progressionValue = 0
        let randomStr = randomString(algorthm: algorithm)
        guard let data = Data(base64Encoded: randomStr) else { return }
        let totpVarible = TOTP(secret: data, digits: AppConstants.kDIGITS, timeInterval: 30, algorithm: algorthm)
        guard let otpString = totpVarible?.generate(time: Date(timeIntervalSinceNow: 30)) else {return}
        
        createTxtOtp(otp: otpString)
    }
    
    fileprivate func createTxtOtp(otp:String) {
        firtTxt.text = otp[0]
        secondTxt.text = otp[1]
        thirdTxt.text = otp[2]
        fourthTxt.text = otp[3]
        fivethTxt.text = otp[4]
        sixthTxt.text = otp[5]
    }
    
    @objc func updateTimer() {
        let reversedTimer = AppConstants.kTIME - timer
        if timer != 0 {
            progressionValue = Float(reversedTimer) * 0.0333
           
            timer -= 1

        } else {
            progressionValue = 1.0
            createToken(algorithm: self.algorthm)
            timer = AppConstants.kTIME
            
            editAnimation()
           
        }
    }
    
    fileprivate func editAnimation(){
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [10, -10, 0, 10, -10, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6,0.8,1]
        animation.duration = 1

        animation.isAdditive = true
        stackView.layer.add(animation, forKey: "shake")
    }
    // MARK:- Actions

    @objc func segmentChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async {
                self.timer = AppConstants.kTIME
                self.algorthm = .sha1
                self.progressionValue = 0.0
            }
            editAnimation()
        case 1:
            DispatchQueue.main.async {
                self.timer = AppConstants.kTIME
                self.algorthm = .sha256
                self.progressionValue = 0.0
            }
            editAnimation()

        case 2:
            DispatchQueue.main.async {
                self.timer = AppConstants.kTIME
                self.algorthm = .sha512
                self.progressionValue = 0.0
            }
            editAnimation()

        default:
            self.timer = AppConstants.kTIME
            self.algorthm = .sha1
            self.progressionValue = 0.0
            editAnimation()

        }
    }
}
