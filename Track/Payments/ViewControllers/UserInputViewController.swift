//
//  UserInputViewController.swift
//  Track
//
//  Created by John Yeo on 20/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI

struct Person {
    let personImage: UIImageView
    let personTextField: UITextField
    var personId: Int
}

class UserInputViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    
    let contact = CNMutableContact()
    var textFields = [UITextField] ()
    var payment: Payment!
    var payments: [Payment] = []
    var trial: String?
    var counter = 55
    var imageCounter = 14.5
    var scrollCounter = 0
    var tagCounter = 1
    var persons = [CustomUIButton]()
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //comment
    weak var delegate: PaymentListViewController?
    
    @IBOutlet weak var paymentName: UITextField!
    
    @IBOutlet weak var paymentAmount: UITextField!
    
    @IBOutlet weak var paymentReason: UITextField!
    
    @IBOutlet weak var inputHeader: UILabel!
    
    @IBOutlet var overallView: UIView!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstButton: CustomUIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var enterView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.scrollView.delegate = self
//        textFields.append(paymentName)
        firstButton.person = Person(personImage: firstImageView, personTextField: paymentName, personId: 0)
        persons.append(firstButton)
        scrollCounter = Int(scrollView.frame.size.height)
        paymentName.delegate = self
        paymentAmount.delegate = self
        paymentReason.delegate = self
        paymentName.tag = 1
        paymentAmount.tag = 2
        paymentReason.tag = 3
        
        paymentName.text = ""
//        paymentName.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: themeColor()])
        paymentAmount.text = ""

        paymentReason.text = ""
        
//        inputHeader.clipsToBounds = true
//        inputHeader.layer.cornerRadius = 30
//        inputHeader.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        
        overallView.clipsToBounds = true
        overallView.layer.cornerRadius = 30
        overallView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceItemLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([spaceItemLeft, doneButton, spaceItemRight], animated: true)
        
        let minusToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        let minusButton = UIBarButtonItem(title: "-/+", style: .plain, target: self, action: #selector(toggleMinus))
        minusToolBar.items = [minusButton, spaceItemLeft, doneButton]
        
        paymentAmount.inputAccessoryView = minusToolBar
        
        
        nameView.layer.borderWidth = 2.0
        nameView.layer.cornerRadius = 20.0
        nameView.layer.borderColor = UIColor(rgb: 0x00FFE6).cgColor
        
        amountView.layer.borderWidth = 2.0
        amountView.layer.cornerRadius = 20.0
        amountView.layer.borderColor = UIColor(rgb: 0x00FFE6).cgColor
        amountView.addSubview(divideButton)
        
        reasonView.layer.borderWidth = 2.0
        reasonView.layer.cornerRadius = 20.0
        reasonView.layer.borderColor = UIColor(rgb: 0x00FFE6).cgColor
        
        enterButton.layer.cornerRadius = 20.0
        enterButton.layer.borderWidth = 1
        enterButton.layer.borderColor = UIColor(rgb: 0x00FFE6).cgColor

        
        
    }
    
    private let divideButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 282, y: 14.5, width: 26, height: 25))
        button.setBackgroundImage(UIImage(systemName: "divide.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(didTapDivideButton), for: .touchUpInside)
        button.tintColor = UIColor(rgb: 0x00FFE6)
        return button
    }()
    
    @objc func didTapDivideButton() {
        print("tapped divide button")
        guard var amount = getPaymentAmount() else {
            return
        }
        amount = amount/Float(persons.count)
        paymentAmount.text = convertDoubleToCurrency(amount: Double(amount))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func addPerson() {

        
        scrollView.contentSize = CGSize(width: 414, height: scrollCounter + 55)
        scrollCounter = scrollCounter + 55
        
        nameView.frame = CGRect(x:46, y: 84, width: 322, height: nameView.frame.size.height + 55)
        
        //create new textfield
        let txtUserName = UITextField(frame: CGRect(x: Int(67.0), y: counter, width: 207, height: 55))
        txtUserName.backgroundColor = UIColor.clear
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Name:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        txtUserName.font = UIFont(name: "HelveticaNeue", size: 20)
        txtUserName.textColor = .white
        
        counter = counter + 55
        nameView.addSubview(txtUserName)
        
        //create new image
        let image = UIImageView(frame: CGRect(x: 16, y: imageCounter + 55, width: 25, height: 26))
        image.tintColor = UIColor.lightGray
        imageCounter = imageCounter + 55
        image.image = UIImage(named: "person.crop.circle")
        nameView.addSubview(image)
        
        // create delete button
        let deletePersonButton = CustomUIButton(frame: CGRect(x: 282, y: imageCounter, width: 26, height: 25))
        deletePersonButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        deletePersonButton.tintColor = UIColor(rgb: 0x00FFE6)
        deletePersonButton.addTarget(self, action: #selector(didTapDeletePersonButton(sender:)), for: .touchUpInside)
        deletePersonButton.person = Person(personImage: image, personTextField: txtUserName, personId: tagCounter)
        nameView.addSubview(deletePersonButton)
        
        
        amountView.frame = CGRect(x:46, y: amountView.frame.origin.y + 55, width: 322, height: 55)
        reasonView.frame = CGRect(x:46, y: reasonView.frame.origin.y + 55, width: 322, height: 55)
        enterButton.frame = CGRect(x:46, y: enterButton.frame.origin.y + 55, width: 322, height: 55)

        persons.append(deletePersonButton)
        paymentAmount.tag = paymentAmount.tag + 1
        paymentReason.tag = paymentReason.tag + 1
//        textFields.append(txtUserName)
//        textFields[tagCounter].tag = tagCounter + 1
        persons[tagCounter].person?.personTextField.tag = tagCounter + 1
        persons[tagCounter].person?.personTextField.delegate = self
//        textFields[tagCounter].delegate = self
        tagCounter += 1
    }
    
    @objc func didTapDeletePersonButton(sender: CustomUIButton) {
        sender.person?.personImage.removeFromSuperview()
        sender.person?.personTextField.removeFromSuperview()
        sender.removeFromSuperview()
        guard let personId = sender.person?.personId else {
            return
        }
        
//        textFields.remove(at: personId)


        for index in 0..<persons.count {
            if index > personId {
                
                persons[index].person?.personTextField.frame.origin.y -= 55
                persons[index].person?.personImage.frame.origin.y -= 55
                persons[index].person?.personId -= 1
                persons[index].frame.origin.y -= 55
                persons[index].person?.personTextField.tag -= 1
            }
        }
        
        persons.remove(at: personId)
        nameView.frame.size.height -= 55
        amountView.frame.origin.y -= 55
        reasonView.frame.origin.y -= 55
        enterButton.frame.origin.y -= 55
        imageCounter -= 55
        counter -= 55
        tagCounter = tagCounter - 1
        sender.removeFromSuperview()
    }
    
    @objc func toggleMinus() {

        // Get text from text field
        if var text = paymentAmount.text , text.isEmpty == false{

            // Toggle
            if text.hasPrefix("-") {
                text = text.replacingOccurrences(of: "-", with: "")
            }
            else
            {
                text = "-\(text)"
            }

            // Set text in text field
            paymentAmount.text = text

        }
        else if paymentAmount.text?.isEmpty == true {
        paymentAmount.text = "-"
        }
    }
    
    @objc func doneClicked () {
        if (paymentAmount.text?.hasPrefix("$"))! {
            let tmp = Double(paymentAmount.text!.dropFirst())
            paymentAmount.text = convertDoubleToCurrency(amount: tmp!)
            paymentAmount.resignFirstResponder()
            paymentReason.becomeFirstResponder()
        }
        
        else {
            if let tmp  = Double(paymentAmount.text!) {
                paymentAmount.text = convertDoubleToCurrency(amount: tmp)
                view.endEditing(true)
                paymentReason.becomeFirstResponder()
            }
            else {
                paymentAmount.resignFirstResponder()

            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
              nextField.becomeFirstResponder()
           }
            
    
        else if textField.tag == paymentReason.tag {
            textField.resignFirstResponder()
        }
            
        else {
              // Not found, so remove keyboard.
            paymentAmount.becomeFirstResponder()
           }
           // Do not add a line break
    
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
    }

    
    @IBAction func enterTapped() {
        // check that all fields have been filled up
        guard let paymentName = paymentName.text,
            let paymentAmount = paymentAmount.text,
            let  paymentReason = paymentReason.text,
            !paymentName.isEmpty,
            !paymentAmount.isEmpty else {
                return
        }
        
        //get last row Id
        let lastRowId = PaymentManager.main.getLastRowId()
        
        // get today's date in a string
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateTimeString = formatter.string(from: currentDateTime)
        
        //compare name label to database
        let payments = PaymentManager.main.getAllPayments()
        for person in persons  {
            var isFound = false
            guard let personName = person.person?.personTextField.text,
                !personName.isEmpty else {
                    return
            }
            
            for row in payments {
                if personName == row.name {
                    payment = row
                    guard let amount = getPaymentAmount() else {
                        return
                    }
                    payment.amount = amount + payment.amount
                    payment.reason = paymentReason + " - " + dateTimeString + "\n\n" + payment.reason
                    payment.date = dateTimeString
                    let _ = PaymentManager.main.save(payment: payment)
                    isFound = true
                    break
                }
            }
            if !isFound {
                let reason = "\(paymentReason) - \(dateTimeString)"
                guard let amount = self.getPaymentAmount() else {
                    return
                }
                self.payment = Payment(id: lastRowId, name: personName, amount: amount, reason: reason, date: dateTimeString)
                let _ = PaymentManager.main.create(payment: payment)
            }
            
        }
        
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
        return
    }

    
//    func savePayment () {
//        if let paymentName = paymentName.text{
//            payment.name = paymentName
//        }
//        else {
//            return
//        }
//
//
//
//        if let paymentReason = paymentReason.text{
//            payment.reason = paymentReason
//        }
//        else {
//            return
//        }
//    }
    
    func themeColor () -> UIColor {
        let x = UIColor(displayP3Red: 70, green: 154, blue: 166, alpha: 0.8)
        return x
    }
    
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    @IBAction func addFriends() {
      // 1
      let contactPicker = CNContactPickerViewController()
      contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
      // 2
      present(contactPicker, animated: true)
    }
    
    func getPaymentAmount() -> Float? {
        
        if let tmp = paymentAmount.text {
            if tmp != "$" && tmp != "" && tmp != "-"{
                
            //if paymentAmount is positive
                
                if tmp.hasPrefix("$") == true {
                    let amount = Float(convertCurrencyToDouble(input: tmp))
                    return amount
                }
                    
                // if payment amount is negative
                else if tmp.hasPrefix("-") == true {
                    if String(tmp.dropFirst()).hasPrefix("$") {
                        var amount = Float(convertCurrencyToDouble(input:String(tmp.dropFirst())))
                            amount = -amount
                        return amount
                    }
                        
                    else {
                        let amount = Float(tmp)
                        return amount
                    }
                }
                else {
                    let amount = Float(tmp)
                    return amount
                }
            }
        }
        return nil
    }
    
    func convertCurrencyToDouble(input: String) -> Double! {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }

}



extension UserInputViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController,
                     didSelect contactProperty: CNContactProperty) {
    
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        // You can fetch selected name and number in the following way

        // user name
        for contact in contacts {
            let userName:String = contact.givenName + " " + contact.familyName
            paymentName.text = userName + paymentName.text! + ", "
        }
        
        // user phone number
//        let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
//        let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value


        // user phone number string
//        let primaryPhoneNumberStr:String = firstPhoneNumber.stringValue

//        print(primaryPhoneNumberStr)

    }
}

class CustomUIButton: UIButton {
    var person: Person?
}
    
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
