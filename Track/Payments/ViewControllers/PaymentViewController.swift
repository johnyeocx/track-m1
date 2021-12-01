//
//  PaymentViewController.swift
//  Track
//
//  Created by John Yeo on 21/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class PaymentViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    var payment: Payment!
    
 
    @IBOutlet weak var paymentLabel: UITextField!
    
    @IBOutlet weak var reasonLabel: UITextView!
    
    @IBOutlet weak var addText: UITextField!
    
    @IBOutlet weak var reduceText: UITextField!
    
    @IBOutlet weak var paymentScrollView: UIScrollView!
    
    @IBOutlet weak var nameLabel: UITextField!
    
    weak var delegate: PaymentListViewController?
    
    @IBOutlet var paymentView: UIView!
    
    @IBOutlet weak var quickMinus: UITextField!
    
    @IBOutlet weak var headerView: RadialGradientView!
    
    
    private let quickAddButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 345, y: 165, width: 40, height: 40)
        button.tintColor = .darkGray
        return button
    }()
    
    private let quickMinusButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 345, y: 200, width: 40, height: 40)
        button.tintColor = .darkGray
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 56, height: 56)
        button.tintColor = .darkGray
        return button
    }()
    
    @objc func dismissButtonTapped() {
        print("dismiss button tapped")
        self.dismiss(animated: true, completion: nil)
    }
        
    @objc func addButtonTapped() {
        addText.isHidden = false
        addText.becomeFirstResponder()
    }
    
    @objc func minusButtonTapped() {
        reduceText.isHidden = false
        reduceText.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addSubview(dismissButton)
        paymentScrollView.addSubview(quickAddButton)
        paymentScrollView.addSubview(quickMinusButton)
        self.navigationController?.navigationBar.prefersLargeTitles = true

        nameLabel.delegate = self
        paymentLabel.delegate = self
        reasonLabel.delegate = self
        reasonLabel.tag = 1
        addText.delegate = self
        addText.tag = 2
        reduceText.tag = 3
        quickMinus.tag = 4
        addText.isHidden = true
        reduceText.isHidden = true

        
        paymentLabel.text = convertDoubleToCurrency(amount: Double(payment.amount))
        if payment.amount < 0 {
            paymentLabel.textColor = .red
        }
        else {
            paymentLabel.textColor = .systemGreen
        }
        reasonLabel.text = payment.reason
        if reasonLabel.text == "Add Reason" {
            reasonLabel.textColor = .lightGray
        }
        nameLabel.text = payment.name
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        let spaceItemLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
        let secondDoneButton = UIBarButtonItem(barButtonSystemItem:
        UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
//        let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let minusToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        let minusButton = UIBarButtonItem(title: "-/+", style: .plain, target: self, action: #selector(toggleMinus))
        minusToolBar.items = [minusButton, spaceItemLeft, secondDoneButton]
        toolbar.items = [spaceItemLeft, doneButton]
        
        
        
        
        addText.inputAccessoryView = minusToolBar
        reduceText.inputAccessoryView = toolbar
        reasonLabel.inputAccessoryView = toolbar
        nameLabel.inputAccessoryView = toolbar
        paymentLabel.inputAccessoryView = minusToolBar
        
//        headerView.layer.cornerRadius = 20.0
//        headerView.layer.borderWidth = 10
//        headerView.layer.borderColor = UIColor(rgb: 0x00E6FF).cgColor
    }
    
    @objc func toggleMinus() {

        // Get text from text field
        if var text = paymentLabel.text , text.isEmpty == false{

            // Toggle
            if text.hasPrefix("-") {
                text = text.replacingOccurrences(of: "-", with: "")
            }
            else
            {
                text = "-\(text)"
            }

            // Set text in text field
            paymentLabel.text = text

        }
        else if paymentLabel.text?.isEmpty == true {
        paymentLabel.text = "-"
        }
    }
     
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = -250
        })
        if reasonLabel.text == "Add Reason" {
            reasonLabel.text = ""
            reasonLabel.textColor = .white
        }
        

    }
        
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
        
        if reasonLabel.text == "" {
            reasonLabel.text = "Add Reason"
            reasonLabel.textColor = .lightGray
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            reduceText.text = ""
        }
        
        if textField.tag == 2 {
            addText.text = ""
        }
        
        if textField.tag == 4 {
            quickMinus.font = quickMinus.font?.withSize(20)
        }

    }
    
    @objc func doneClicked () {
        if let convertedAddText = Float(addText.text!) {
            payment.amount = payment.amount + convertedAddText
            paymentLabel.text = String(format: "%.2f", payment.amount)
            view.endEditing(true)
        }
        else {
            view.endEditing(true)
        }
        
        if let convertedMinusText = Float(reduceText.text!) {
            payment.amount = payment.amount - convertedMinusText
            paymentLabel.text = String(format: "%.2f", payment.amount)
            view.endEditing(true)
        }
        else {
            view.endEditing(true)
        }
        
        if let paymentText = Float(paymentLabel.text!) {
            paymentLabel.text = String(format: "%.2f", paymentText)
            view.endEditing(true)
        }
        else {
            view.endEditing(true)
        }
        
        if (paymentLabel.text?.hasPrefix("$"))! {
            if let tmp = Double(paymentLabel.text!.dropFirst()) {
                paymentLabel.text = convertDoubleToCurrency(amount: tmp)
                view.endEditing(true)
            }
            else {
                return
            }
        }
        
        else {
            if let tmp  = Double(paymentLabel.text!) {
                paymentLabel.text = convertDoubleToCurrency(amount: tmp)
                view.endEditing(true)
            }
            else {
                view.endEditing(true)
            }

        }
        addText.isHidden = true
        reduceText.isHidden = true
        addText.text = ""
        reduceText.text = ""
        
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addText.resignFirstResponder()
        paymentLabel.resignFirstResponder()
        reasonLabel.resignFirstResponder()
    }
    
    @IBAction func enterTapped() {
        if let tmp = paymentLabel.text {
            if tmp != "$" && tmp != ""{
                if tmp.hasPrefix("$") == true {
                    payment.amount = Float(convertCurrencyToDouble(input: tmp))
                }
                else if tmp.hasPrefix("-") == true
                {
                    if tmp.dropFirst().hasPrefix("$") {
                        let amount = Float(convertCurrencyToDouble(input: String(tmp.dropFirst())))
                        let amount2 = -amount
                        payment.amount = amount2
                    }
                    else {
                        payment.amount = Float(tmp)!
                    }
                }
                else {
                    payment.amount = Float(tmp)!
                }
                
            }
        }
        else {
            return
        }
        
        payment.reason = reasonLabel.text!
        payment.name = nameLabel.text!
        print(payment.amount)
        PaymentManager.main.save(payment: payment)
        
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func convertCurrencyToDouble(input: String) -> Double! {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }
    
}


