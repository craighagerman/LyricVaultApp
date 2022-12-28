//
//  Contacts.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-21.
//


/*
 see:
 https://stackoverflow.com/questions/58809357/swiftui-list-with-section-index-on-right-hand-side
 https://www.donnywals.com/how-to-filter-an-array-in-swift/
 */



import SwiftUI

struct Contact: Identifiable, Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return (lhs.lastName, lhs.firstName) < (rhs.lastName, rhs.firstName)
    }
    
    var id = UUID()
    let firstName: String
    let lastName: String
}

let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

struct Contacts: View {
    @State private var searchText = ""
    
    var contacts = [Contact]()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                ZStack {
                    List {
                        ForEach(alphabet, id: \.self) { letter in
                            Section(header: Text(letter).id(letter)) {
                                ForEach(contacts.filter({ (contact) -> Bool in
                                    contact.lastName.prefix(1) == letter
                                })) { contact in
                                    HStack {
                                        Image(systemName: "person.circle.fill").font(.largeTitle).padding(.trailing, 5)
                                        Text(contact.firstName)
                                        Text(contact.lastName)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Contacts")
                    .listStyle(PlainListStyle())
                    
                    VStack {
                        ForEach(alphabet, id: \.self) { letter in
                            HStack {
                                Spacer()
                                
                                Spacer()
                                Button(action: {
                                    print("letter = \(letter)")
                                    //need to figure out if there is a name in this section before I allow scrollto or it will crash
                                    if contacts.first(where: { $0.lastName.prefix(1) == letter }) != nil {
                                        withAnimation {
                                            scrollProxy.scrollTo(letter)
                                        }
                                    }
                                }, label: {
                                    Text(letter)
                                        .foregroundColor(Color.blue)
                                        .padding(.trailing, 7)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    init() {
        contacts.append(Contact(firstName: "Chris", lastName: "Ryan"))
        contacts.append(Contact(firstName: "Allyson", lastName: "Ryan"))
        contacts.append(Contact(firstName: "Jonathan", lastName: "Ryan"))
        contacts.append(Contact(firstName: "Brendan", lastName: "Ryaan"))
        contacts.append(Contact(firstName: "Jaxon", lastName: "Riner"))
        contacts.append(Contact(firstName: "Leif", lastName: "Adams"))
        contacts.append(Contact(firstName: "Frank", lastName: "Conors"))
        contacts.append(Contact(firstName: "Allyssa", lastName: "Bishop"))
        contacts.append(Contact(firstName: "Justin", lastName: "Bishop"))
        contacts.append(Contact(firstName: "Johnny", lastName: "Appleseed"))
        contacts.append(Contact(firstName: "George", lastName: "Washingotn"))
        contacts.append(Contact(firstName: "Abraham", lastName: "Lincoln"))
        contacts.append(Contact(firstName: "Steve", lastName: "Jobs"))
        contacts.append(Contact(firstName: "Steve", lastName: "Woz"))
        contacts.append(Contact(firstName: "Bill", lastName: "Gates"))
        contacts.append(Contact(firstName: "Donald", lastName: "Trump"))
        contacts.append(Contact(firstName: "Darth", lastName: "Vader"))
        contacts.append(Contact(firstName: "Clark", lastName: "Kent"))
        contacts.append(Contact(firstName: "Bruce", lastName: "Wayne"))
        contacts.append(Contact(firstName: "John", lastName: "Doe"))
        contacts.append(Contact(firstName: "Jane", lastName: "Doe"))
        contacts.sort()
    }
}

struct Contacts_Previews: PreviewProvider {
    static var previews: some View {
        Contacts()
    }
}
