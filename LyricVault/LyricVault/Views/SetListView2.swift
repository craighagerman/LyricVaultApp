//
//  SetListView2.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2023-02-04.
//


import Foundation
import SwiftUI


struct SetListView2: View {
    @State var slid: UUID
    let persistenceController = PersistenceController.shared
    @State private var showingSetlistSheet = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var setlist: FetchedResults<Setlist>

    init(slid: UUID) {
        _slid = State(initialValue: slid)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Setlist.setlistid ), slid as NSUUID)
        _setlist = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: predicate)
    }
    
    
    
    
    var body: some View {
        var foo = setlist.first ?? Setlist()
        var ssongs: [Song] = foo.songs ?? [Song]()
        let songIds: [UUID] = ssongs.map{ $0.songid! }
        
        NavigationStack {
            VStack {
                Text("Setlist Songs.  \(setlist.count) setlist, (\(ssongs.count)) songs")
                
                Text("Lyric Vault")
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            Button {
                                showingSetlistSheet.toggle()
                            } label: {
                                Image(systemName: "plus.circle")
                            }.sheet(isPresented: $showingSetlistSheet) {
                                AddSongToSetlistView(songIds: songIds)
                            }
                        }
                    }
                
                
                //        var songs = setlist.songs
                //        Text("Num of songs: \(setlist  )")
                
                
                //            List {
                //                ForEach(songs ?? [], id: \.self) { song in
                //                    NavigationLink(destination: SongView(song: song).environment(\.managedObjectContext, persistenceController.container.viewContext) ) {
                //                        Text("\(song.artist!) - \(song.title!)")
                //                    }
                //                }
                //                .onDelete(perform: deleteSong)
                //            }
                
            }
        }
    }
    
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("An error occured: \(error)")
        }
    }
}







// --------------------------------------------------------------------------------------------------------------------------------------------
// Sheet that is popped up to create a new play list name
// --------------------------------------------------------------------------------------------------------------------------------------------
struct AddSongToSetlistView: View {
    @State var songIds: [UUID]
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismissview
    let persistenceController = PersistenceController.shared
    @State private var disabled = true
    @State private var selection = Set<Song>()
    
    
    
    @FetchRequest var songs: FetchedResults<Song>
    
//    @FetchRequest(entity: Song.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)] )
//    var songs: FetchedResults<Song>
    
    
    
  

    
    
    
//    @FetchRequest var setlist: FetchedResults<Setlist>
//
//    init(slid: UUID) {
//        _slid = State(initialValue: slid)
//        let predicate = NSPredicate(format: "%K == %@", #keyPath(Setlist.setlistid ), slid as NSUUID)
//        _setlist = FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: predicate)
//    }
    
    
    
    init(songIds: [UUID]) {
        _songIds = State(initialValue: songIds)
        let predicate = NSPredicate(format: "NOT %K IN %@", #keyPath(Setlist.setlistid ), songIds as [NSUUID])
        _songs = FetchRequest(entity: Song.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)], predicate: predicate)
    }
    
    
    
    
    var body: some View {
        // List of all songs
        NavigationStack {
            List(songs, id: \.self, selection: $selection) { song in
                Text("\(song.artist!) - \(song.title!)")
            }
            .navigationTitle("Song List")
            .toolbar { EditButton() }
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
