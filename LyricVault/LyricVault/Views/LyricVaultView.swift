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
    
    @FetchRequest(entity: SetlistNames.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var setlistNames: FetchedResults<SetlistNames>
    
    //    @FetchRequest(entity: Setlists.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    //    private var setlists: FetchedResults<Setlists>
    
    
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
                        ForEach(setlistNames) { setlist in
                            let setlistId = setlist.setlistId!
                            NavigationLink(destination: SetlistView(setlistId: setlistId).environment(\.managedObjectContext, persistenceController.container.viewContext) ) {
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
                                NewPlaylistView()
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
    
    
    func newPlaylist() {
        print("New Playlist tapped!")
        
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
            offsets.map { setlistNames[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    func addSetlist() {
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


// ----------------------------------------------------------------------
// Sheet that is popped up to create a new play list name
// ----------------------------------------------------------------------
struct NewPlaylistView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var disabled = true
    @State var setlistName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Text("New Playlist")
                Spacer()
                Button("Done") {
                    addPlaylistName(name: setlistName)
                    dismiss()
                }.disabled(setlistName.isEmpty)
                
            }.padding(40)
            HStack {
                Spacer()
                TextField("Playlist Name", text: $setlistName).textFieldStyle(.roundedBorder).padding(10) //.background(Color.yellow)
                Spacer()
            }
            Spacer()
        }
    }
    
    
    private func addPlaylistName(name: String) {
        withAnimation {
            let sl = SetlistNames(context: viewContext)
            sl.setlistId = UUID()
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




