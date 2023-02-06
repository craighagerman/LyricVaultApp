//
//  LyricVaultView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-25.
//

import SwiftyDropbox
import SwiftUI

struct LyricVaultView: View {
    // a var used for popping a new sheet
    @State private var showingNewPlaylistSheet = false
    
    let persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Setlist.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var setlists: FetchedResults<Setlist>
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section("Library") {
                        NavigationLink(destination: LibraryView().environment(\.managedObjectContext, persistenceController.container.viewContext) ) {
                            Image(systemName: "music.note")
                            Text("All Songs")
                        }
                    }
                    Section("Set lists") {
                        ForEach(setlists) { setlist in
                            let slid = setlist.setlistid!
                            NavigationLink(destination: SetListView2(slid: slid).environment(\.managedObjectContext, persistenceController.container.viewContext) ) {
                                Image(systemName: "list.bullet")
                                Text(setlist.name ?? "Not found")
                            }
                        }
                        .onDelete(perform: deleteSetlistName)
                    }
                }.listStyle(.grouped)
                Text("Lyric Vault")
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button {
                                showingNewPlaylistSheet.toggle()
                            } label: {
                                Image(systemName: "music.note.list")
                            }.sheet(isPresented: $showingNewPlaylistSheet) {
                                AddSetlistView()
                            }
                        }
                        ToolbarItemGroup(placement: .secondaryAction) {
                            // TODO - refactor to a NavigationLink
                            Button("Sort Setlists") {
                                sortSetLists()
                            }
                            NavigationLink(destination: ImportSongsView() ) {
                                Text("Import Songs")
                            }
                            NavigationLink(destination: AddSongView() ) {
                                Text("Add Song")
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
    
    private func deleteSetlistName(offsets: IndexSet) {
        withAnimation {
            offsets.map {setlists[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    func sortSetLists() {
        print("Sort button was tapped")
    }
}


// ----------------------------------------------------------------------
// LyricVaultView Preview
// ----------------------------------------------------------------------
struct LyricVaultView_Previews: PreviewProvider {
    static var previews: some View {
        LyricVaultView()
    }
}


// ----------------------------------------------------------------------
// Sheet that is popped up to create a new play list name
// ----------------------------------------------------------------------
struct AddSetlistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismissview
    
    @State private var disabled = true
    @State var setlistName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Text("New Setlist")
                Spacer()
                Button("Done") {
                    addPlaylistName(name: setlistName)
                    dismiss()
                }.disabled(setlistName.isEmpty)
            }.padding(40)
            HStack {
                Spacer()
                TextField("Setlist Name", text: $setlistName).textFieldStyle(.roundedBorder).padding(10) //.background(Color.yellow)
                Spacer()
            }
            Spacer()
        }
    }
    
    func dismiss() {
        print("DISMISS pressed")
    }
    
    private func addPlaylistName(name: String) {
        print("calling addPlaylistName() with name= \(name)")
        withAnimation {
            let sl = Setlist(context: viewContext)
            sl.setlistid = UUID()
            sl.name = name
            saveContext()
        }
    }
    
    // TODO : refactor - this is copy/pasted exactly in a couple places
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
}




