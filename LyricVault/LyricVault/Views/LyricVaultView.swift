//
//  LyricVaultView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-25.
//

import SwiftyDropbox
import SwiftUI

struct LyricVaultView: View {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Setlists.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var setlists: FetchedResults<Setlists>
    
    //    @FetchRequest(entity: Songs.entity(), sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)])
    //    private var vault: FetchedResults<Songs>
    
    let vault = ["Songs"] // TODO - pull from DB
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section("Library") {
                        NavigationLink(destination: LibraryView().environment(\.managedObjectContext, persistenceController.container.viewContext) ) {
                            Image(systemName: "music.note")
                            Text("All Songs")
                        }
                        
                        
                        //                        ForEach(vault, id: \.self) { library in
                        //                            NavigationLink(destination: Text(library)) {
                        //                                Image(systemName: "music.note")
                        //                                Text(library)
                        //                            }
                        //                        }
                    }
                    Section("Set lists") {
                        ForEach(setlists) { setlist in
                            Text(setlist.name ?? "Not found")
                        }
                        .onDelete(perform: deleteSetlist)
                    }
                    
                }.listStyle(.grouped)
                Text("Lyric Vault")
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button("New Playlist") {
                                print("About tapped!")
                            }
                        }
                        ToolbarItemGroup(placement: .secondaryAction) {
                            Button("Sort Setlists") {
                                print("Sort Setlists tapped")
                            }
                            NavigationLink(destination: ImportSongsView() ) {
                                Text("Import Songs")
                            }
                        }
                    }
            }
        }
    }
    
    func openSettings() {
        print("Gear button was tapped")
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

struct LyricVaultView_Previews: PreviewProvider {
    static var previews: some View {
        LyricVaultView()
    }
}
