//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit
class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    //This App Must Test on a Realy iPhone.
    let productID = "com.aboullezz.InspoQuotes.PremiumQuotes"
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //SKPaymentTransactionObserver Delegate:
        SKPaymentQueue.default().add(self)
        //didLoad in screen:
        if isPurchased(){
            showPremiumQuotes()
        }
    }
    // MARK: - TableView DataSource Methods:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = UIColor.blue
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    // MARK: - TableView Delegate Methods:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        buyPremiumQuotes()
    }
    //MARK: - In-App Purchase Methodes -> from StoreKit :
    func buyPremiumQuotes () {
        if SKPaymentQueue.canMakePayments() {
            //can make payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            //user can't make payments
            print("user can't make payments")
        }
    }
    //SKPaymentTransactionObserver Delegate Methods:
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //user payment succeful
                //must creat sandBox user first from appstoreconnect.aplle.com
                print("Transaction Successful1")
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                //user payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction Failed due to error: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                //restore data for user who deleted this app
            } else if transaction.transactionState == .restored {
                showPremiumQuotes()
                print("Transaction Restored")
                //to remove the restoreButton when restored done:
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    // Methods of Parchased:
    func showPremiumQuotes() {
        //save data for user who payed
        UserDefaults.standard.set(true, forKey: productID)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    func isPurchased () -> Bool {
        let purchasedStatues = UserDefaults.standard.bool(forKey: productID)
        if purchasedStatues {
            print("Done Purchased")
            return true
        } else {
            print("Never Purchased")
            return false
        }
    }
    // Restore Button Action:
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
