//
//  FriendViewController.swift
//  Track
//
//  Created by John Yeo on 24/5/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class FriendsViewController: UITableViewController {
    
    struct ExpandableNames {
        var isExpanded : Bool
        var names: [FavouritableContact]
    }

    struct FavouritableContact {
        let name: String
        var hasFavorited: Bool
    }
    
    var twoDimensionalArray = [
        ExpandableNames(isExpanded: true, names: ["amy", "Bill", "Zack", "Steve"].map{ FavouritableContact(name: $0, hasFavorited: false)}),
        ExpandableNames(isExpanded: true, names: ["John", "Zach", "Bharat", "Steve"].map{ FavouritableContact(name: $0, hasFavorited: false)})
    ]
    
    
    override func viewDidLoad() {
        fetchContacts()
        super.viewDidLoad()
        
        
    }
    
    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) {(granted, err) in
            if let err = err {
                print("failed to request access", err)
                return
            }
            if granted {
                print("Access granted")

                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

                do {

                    var favoritableContacts = [FavouritableContact] ()


                    try store.enumerateContacts(with: request, usingBlock: {(contact, stopPointerIfYouWantToStopEnumerating) in


                    print(contact.givenName)

                    favoritableContacts.append(FavouritableContact(name: contact.givenName + " " + contact.familyName, hasFavorited: false))

                    let names = ExpandableNames(isExpanded: true, names: favoritableContacts)

                    self.twoDimensionalArray = [names]
                    } )



                } catch let error {
                        print("failed to enumerate contacts:", error)
                }

            }
            else {
                print ("access denied")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        twoDimensionalArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimensionalArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let name = twoDimensionalArray[indexPath.section].names[indexPath.row].name
        cell.textLabel?.text = name
        return cell
    }
}


