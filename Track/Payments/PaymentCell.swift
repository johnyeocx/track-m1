//
//  PaymentCell.swift
//  Track
//
//  Created by John Yeo on 20/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    
    
    func setPayment(payment: Payment) {
        paymentNameLabel.text = payment.name
        paymentAmountLabel.text = convertDoubleToCurrency(amount: Double(payment.amount))
        if payment.amount > 0 {
            paymentAmountLabel.textColor = .systemGreen
        }
        
        else if payment.amount < 0 {
            paymentAmountLabel.textColor = .red
        }
        paymentDateLabel.text = payment.date
        return
    }
    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
}
