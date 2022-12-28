//
//  Screen2.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-20.
//

import Foundation
import SwiftUI


struct LibraryView: View {
    let persistenceController = PersistenceController.shared
    @State var title: String = ""
    @State var artist: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Songs.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)])
    private var songs: FetchedResults<Songs>
    
    var body: some View {
        // List of all songs
        List {
            ForEach(songs) { song in
                HStack {
                    Text(song.title ?? "Not found")
                    Spacer()
                    Text(song.artist ?? "Not found")
                }
            }
            .onDelete(perform: deleteSong)
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
    
    private func deleteSong(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
}



struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
