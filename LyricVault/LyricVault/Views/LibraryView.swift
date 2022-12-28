//
//  Screen2.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import Foundation
import SwiftUI


let vault = ["Songs"]

//let setLists = [
//    "Pop Songs 1",
//    "Pop Songs 2",
//    "Blues",
//    "Jazz"
//]

struct LibraryView: View {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Setlists.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var setlists: FetchedResults<Setlists>
//    let setlists = setLists
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("Library") {
                        ForEach(vault, id: \.self) { library in
                            NavigationLink(destination: Text(library)) {
                                Image(systemName: "music.note")
                                Text(library)
                            }
                        }
                    }
                    Section("Set lists") {
                        ForEach(setlists) { setlist in
                            Text(setlist.name ?? "Not found")
                        }
                        .onDelete(perform: deleteSetlist)
                    }
                    
                } // .listStyle(.grouped)
                
                HStack {
                    NavigationLink(destination: SongListView() ) {
                        Text("Find")
                    }
//                    NavigationLink(destination: addSetlist()) {
//                                        Text("Do Something")
//                                    }
//                    Button {
//                        addSetlist()
//                    } label: {
//                        Image(systemName: "plus.square.fill")
//                    }.padding()
                    Spacer()
                    Button {
                        sortSetLists()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.square.fill")
                    }.padding()
                }
            }
            
        }
//        HStack {
//            Button {
//                addSetlist()
//            } label: {
//                Image(systemName: "plus.square.fill")
//            }.padding()
//            Spacer()
//            Button {
//                sortSetLists()
//            } label: {
//                Image(systemName: "arrow.up.arrow.down.square.fill")
//            }.padding()
//        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
    
    private func deleteSetlist(offsets: IndexSet) {
        withAnimation {
            offsets.map { setlists[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    func addSetlist() {
        print("Plus button was tapped")
        // Pop open new view to add a new setlist
        SongListView().environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
    
    func sortSetLists() {
        print("Sort button was tapped")
    }
    
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
