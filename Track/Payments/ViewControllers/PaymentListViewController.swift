//
//  PaymentListViewController.swift
//  Track
//
//  Created by John Yeo on 20/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation
import UIKit

class PaymentListViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var payments: [Payment] = []
    var historyPayments = [Payment]()
    
    var currentPaymentsOwed = [Payment]()
    var paymentsOwedPaid = [Payment]()

    var currentPaymentsOwe = [Payment]()
    var paymentsOwePaid = [Payment]()
    
    var paymentsOwe: [Payment] = []
    var paymentsOwed: [Payment] = []
    var IsEditing = false
    var isHistory = false
    var orderIsAscending = true
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func startEditing() {
        print(IsEditing)
        
        if IsEditing == true {
            editButton.title = "Edit"
        }
        if IsEditing == false {
            editButton.title = "Done"
        }
        
        

        tableView.setEditing(!IsEditing, animated: true)
        
        IsEditing = !IsEditing
    }
    
    @IBAction func createInputPage() {
        performSegue(withIdentifier: "InputSegue", sender: self)
    }
    
    
    private let tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor(rgb: 0x00FFE6)
        return tableHeaderView
    }()
    
    private let historyButton: UIButton = {
        let historyButton = UIButton()
        historyButton.tintColor = UIColor.darkGray
        historyButton.setBackgroundImage(UIImage(systemName: "clock.fill"), for: .normal)
        historyButton.addTarget(self, action: #selector(historyButtonPressed), for: .touchUpInside)
        historyButton.frame = CGRect(x: 20, y: 3, width: 32, height: 30)
        return historyButton
    }()
    
    
    
    private let clearHistoryButton: UIButton = {
        let clearHistoryButton = UIButton()
        clearHistoryButton.tintColor = .darkGray
        clearHistoryButton.setTitleColor(.darkGray, for: .normal)
        clearHistoryButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        clearHistoryButton.setTitle("Clear All", for: .normal)
        clearHistoryButton.addTarget(self, action: #selector(clearHistoryButtonPressed), for: .touchUpInside)
        return clearHistoryButton
    }()
    
    public let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.tintColor = UIColor.darkGray
        filterButton.setBackgroundImage(UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        filterButton.frame = CGRect(x: 100, y: 3, width: 32, height: 30)
        return filterButton
    }()
    
    private let orderButton: UIButton = {
        let orderButton = UIButton()
        orderButton.tintColor = UIColor.darkGray
        orderButton.setBackgroundImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        orderButton.addTarget(self, action: #selector(orderButtonPressed), for: .touchUpInside)
        orderButton.frame = CGRect(x: 60, y: 3, width: 32, height: 30)
        return orderButton
    }()
    
    @objc func filterButtonPressed() {
        
        filterButton.tintColor = .white
        let modalViewController = FilterViewController()
        modalViewController.delegate = self
        navigationController?.present(modalViewController, animated: true, completion: nil)
        
    }
    
    @objc func orderButtonPressed() {
        
        if orderIsAscending {
            orderButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        }
        else {
            orderButton.setBackgroundImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        }
        
        orderIsAscending = !orderIsAscending
        UserDefaults.standard.setValue(orderIsAscending, forKey: "order")
        
        orderButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 6.0,
        options: .allowUserInteraction,
        animations: { [weak self] in
          self?.orderButton.transform = .identity
        },
        
        completion: nil)
        reload()
    }
    
    @objc func historyButtonPressed() {
        
        //add clear history button
        if !isHistory {
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.clearHistoryButton.alpha = 1
                self.tableHeaderView.addSubview(self.clearHistoryButton)
            }, completion: nil)
        }
        
        else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.clearHistoryButton.alpha = 0
                self.clearHistoryButton.removeFromSuperview()
            }, completion: nil)
        }

        
        historyPayments = HistoryPaymentManager.main.historyGetAllPayments()
        var tmphistorypaymentsOwe: [Payment] = []
        var tmphistorypaymentsOwed: [Payment] = []
        for paymentindex in historyPayments {
            if paymentindex.amount > 0 {
                tmphistorypaymentsOwed.append(paymentindex)
            }
            else if paymentindex.amount < 0 {
                tmphistorypaymentsOwe.append(paymentindex)
            }
        }
        paymentsOwedPaid = tmphistorypaymentsOwed
        paymentsOwePaid = tmphistorypaymentsOwe
        
        
        
        let payments = PaymentManager.main.getAllPayments()
        print("payments: \(payments)")
        print("history payments: \(historyPayments)")
        isHistory = !isHistory
        
        // change color of the button
        if isHistory {
            historyButton.tintColor = .white
        }
        else {
            historyButton.tintColor = .darkGray
        }
        
        UIView.transition(with: tableView,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations:
            { () -> Void in
                self.tableView.reloadData()
        },
                          completion: nil);
        setBackgroundView()
        
    }
    
    @objc func clearHistoryButtonPressed() {
        //animate button press
        clearHistoryButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.clearHistoryButton.transform = .identity
            },
                       completion: nil)
        
        // main functionality of clear button
        HistoryPaymentManager.main.historyDeleteAll()
        historyButtonPressed()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        //        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
        //            self.searchBar.alpha = 0 // Here you will get the animation you want
        //        }, completion: { _ in
        //            self.searchBar.removeFromSuperview() // Here you hide it when animation done
        //        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.tableHeaderView.alpha = 1
            self.tableHeaderView.frame.size.height = 45// Here you will get the animation you want
        }, completion: { _ in
 // Here you hide it when animation done
        })
        searchBar.resignFirstResponder()
        searchBar.text = ""
        currentPaymentsOwed = paymentsOwed
        reload()
    }
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.searchTextField.tintColor = .lightGray
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.backgroundColor = UIColor(rgb: 0x00FFE6)
        searchController.searchBar.searchTextField.backgroundColor = .darkGray
        //        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.leftView?.tintColor = .lightGray
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont(name: "HelveticaNeue-Bold", size: 17)!
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        return searchController
    }()
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.tableHeaderView.alpha = 0
            self.tableHeaderView.frame.size.height = 0 // Here you will get the animation you want
        }, completion: { _ in
// Here you hide it when animation done
        })
        tableView.reloadData()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        tableHeaderView.addSubview(historyButton)
        tableHeaderView.addSubview(filterButton)
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
       
        
        if orderIsAscending {
            orderButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        }
        else {
            orderButton.setBackgroundImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        }
        tableHeaderView.addSubview(orderButton)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0x00FFE6)
        
        guard let order = UserDefaults.standard.value(forKey: "order") as? Bool else {
            return
        }
        orderIsAscending = order
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    func reload () {
        IsEditing = false
        isEditing = false
        isHistory = false
        payments = PaymentManager.main.getAllPayments()
        var tmppaymentsOwe: [Payment] = []
        var tmppaymentsOwed: [Payment] = []
        for paymentindex in payments {
            if paymentindex.amount > 0 {
                tmppaymentsOwed.append(paymentindex)
            }
            else if paymentindex.amount < 0 {
                tmppaymentsOwe.append(paymentindex)
            }
        }
        
        

        paymentsOwed = tmppaymentsOwed
        currentPaymentsOwed = paymentsOwed
        paymentsOwe = tmppaymentsOwe
        currentPaymentsOwe = paymentsOwe
        
        let filterKey = UserDefaults.standard.value(forKey: "filter") as? String ?? "recent"
        
        
        if filterKey == "name" {
            if orderIsAscending {
                currentPaymentsOwed = currentPaymentsOwed.sorted(by: {$1.name > $0.name})
            }
            else {
                currentPaymentsOwed = currentPaymentsOwed.sorted(by: {$0.name > $1.name})
            }
        }
        else if filterKey == "amount" {
            if orderIsAscending {
                currentPaymentsOwed = currentPaymentsOwed.sorted(by: {$1.amount > $0.amount})
            }
            else {
                currentPaymentsOwed = currentPaymentsOwed.sorted(by: {$0.amount > $1.amount})
            }
        }
        else if filterKey == "recent" {
            if orderIsAscending {
                currentPaymentsOwed = currentPaymentsOwed.sorted(by: { stringToDate(dateString: $1.date)  > stringToDate(dateString: $0.date) })
            }
            else {
                currentPaymentsOwed = currentPaymentsOwed.sorted(by: { stringToDate(dateString: $0.date)  > stringToDate(dateString: $1.date) })
            }
        }
        
        self.tableView.reloadData()
        setEditButton()
        setBackgroundView()
        print(payments)
    }
    
   
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            guard !searchText.isEmpty else {
                currentPaymentsOwed = paymentsOwed
                tableView.reloadData()
                return
            }
            currentPaymentsOwed = paymentsOwed.filter({ payment -> Bool in
                guard let text = searchBar.text else {return false}
                return payment.name.lowercased().contains(text.lowercased())
            })
            tableView.reloadData()
        case 1:
            guard !searchText.isEmpty else {
                currentPaymentsOwe = paymentsOwe
                tableView.reloadData()
                return
            }
            currentPaymentsOwe = paymentsOwe.filter({ payment -> Bool in
                guard let text = searchBar.text else {return false}
                return payment.name.lowercased().contains(text.lowercased())
            })
            tableView.reloadData()
        default:
            break
        }
        return
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(rgb: 0x00FFE6)
        let footerView = UIView()
        footerView.backgroundColor = .black
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        reload()

    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentSegue" {
            if let des = segue.destination as? PaymentViewController {
                switch segmentedControl.selectedSegmentIndex {
                case 0: des.payment = currentPaymentsOwed[tableView.indexPathForSelectedRow!.row]
                case 1: des.payment = currentPaymentsOwe[tableView.indexPathForSelectedRow!.row]
                default:
                    break
                }
                
                des.delegate = self
            }
        }
        if segue.identifier == "InputSegue" {
            let des = segue.destination as! UserInputViewController
            des.delegate = self
        }
    }
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue) {}
    
    
    func setBackgroundView() {
        if tableView.numberOfRows(inSection: 0) > 0 {
            self.tableView.backgroundView = nil
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            if isHistory {
                
                noDataLabel.text = "No History"
            }
            else {
                noDataLabel.text = "No Payments"
            }
            noDataLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            noDataLabel.textAlignment = NSTextAlignment.center
            noDataLabel.textColor = .lightGray
            self.tableView.backgroundView = noDataLabel
            setEditButton()
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.clear
            ], for: .normal)
        }
    }
    
    func setEditButton() {
        editButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ], for: .normal)
        tableView.setEditing(false, animated: true)
        IsEditing = false
        editButton.title = "Edit"
    }
}




extension PaymentListViewController: UITableViewDataSource, UITableViewDelegate {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if isHistory {
                return paymentsOwedPaid.count
            }
            else {
                return currentPaymentsOwed.count
            }
        case 1:
            if isHistory {
                return paymentsOwePaid.count
            }
            else {
                return currentPaymentsOwe.count
            }

        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell") as! PaymentCell
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                if isHistory {
                    let payment = paymentsOwedPaid[indexPath.row]
                    cell.setPayment(payment: payment)
                }
                else {
                    let payment = currentPaymentsOwed[indexPath.row]
                    cell.setPayment(payment: payment)
                }
                    
                return cell
            case 1:
                if isHistory {
                    let payment = paymentsOwePaid[indexPath.row]
                    cell.setPayment(payment: payment)
                }
                else {
                    let payment = currentPaymentsOwe[indexPath.row]
                    cell.setPayment(payment: payment)
                }

                return cell
            
            default:
                break
        }
        cell.backgroundColor = .black
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 78
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Paid") { (action, view, completion) in
            switch self.segmentedControl.selectedSegmentIndex {
                case 0:
                    if self.isHistory {
                        // delete from history database
                        let payment = self.paymentsOwedPaid[indexPath.row]
                        HistoryPaymentManager.main.historyDelete(payment: payment)
                        self.paymentsOwedPaid.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.setBackgroundView()
                    }
                    else {
                        // add to history database
                        var payment = self.currentPaymentsOwed[indexPath.row]
                        let date = self.currentDate()
                        payment.date = "Paid on \(date)"
                        let _ = HistoryPaymentManager.main.historyCreate(payment: payment)
                        
                        PaymentManager.main.delete(payment: self.currentPaymentsOwed[indexPath.row])
                        self.currentPaymentsOwed.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.setBackgroundView()
                        // self.setHeaderView()
                }

                case 1:
                    if self.isHistory {
                        // delete from history database
                        let payment = self.paymentsOwePaid[indexPath.row]
                        HistoryPaymentManager.main.historyDelete(payment: payment)
                        self.paymentsOwePaid.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.setBackgroundView()
                    }
                    else {
                        let _ = HistoryPaymentManager.main.historyCreate(payment: self.currentPaymentsOwe[indexPath.row])
                        
                        PaymentManager.main.delete(payment: self.currentPaymentsOwe[indexPath.row])
                        self.currentPaymentsOwe.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        //                    self.setHeaderView()
                        self.setBackgroundView()
                    }

                default:
                    break
            }
            
        }
        if isHistory {
            action.backgroundColor = .systemRed
            action.title = "Delete"
        }
        else {
            action.backgroundColor = .systemGreen

        }
        
        return action
    }
    
    func currentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateTimeString = formatter.string(from: currentDateTime)
        return dateTimeString
    }
    
    func stringToDate(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        guard let date = formatter.date(from: dateString) else {
            return Date()
        }
        return date
    }
    
    
}

extension UIColor {
convenience init(hexString: String, alpha: CGFloat = 1.0) {
    let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexString)
    if (hexString.hasPrefix("#")) {
        scanner.scanLocation = 1
    }
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    self.init(red:red, green:green, blue:blue, alpha:alpha)
}
func toHexString() -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    return String(format:"#%06x", rgb)
}

}



    

    
