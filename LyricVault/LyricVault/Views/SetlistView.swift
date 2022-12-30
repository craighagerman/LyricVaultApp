//
//  SetlistView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-28.
//

import SwiftUI

struct SetlistView: View {
    
    var slid: UUID
    
    let persistenceController = PersistenceController.shared
    @State var title: String = ""
    @State var artist: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    // @Environment(\.managedObjectContext) var moc
    
    @State private var items:[Setlist]?
    
    @FetchRequest(entity: Setlist.entity(), sortDescriptors: [NSSortDescriptor(key: "setlistid", ascending: true)])
    private var setlists: FetchedResults<Setlist>
//    private var setlist_items: FetchedResults<Setlist>
    
//    @FetchRequest(entity: Song.entity(), sortDescriptors: [NSSortDescriptor(key: "artist", ascending: true)])
//    private var songs: FetchedResults<Song>
    

    
    
//    init(setlists: Setlist) {
//        self.setlists = setlists
//        self._todoItems = FetchRequest(
//            entity: Setlist.entity(),
//            sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)],
//            predicate: NSPredicate(format: "todoList == %@", todoList)
//        )
//    }
    
    
//    func fetchSetlists() {
//        // fetch data from Core Data
//        do {
//            let request = Setlist.fetchRequest()
//            // set filtering and sorting on the request
//            let theId = Setlist.id
//            let pred = NSPredicate(format: "%K == %@", #keyPath(Setlist.id ), slid as NSUUID)
//            request.predicate = pred
//            self.items = try viewContext.fetch(request)
////            tableView.reloadData()
//        }
//        catch {
//
//        }
//    }
    
    
    
    func getSetlistName(slid: UUID) -> String {
//        let predicate = NSPredicate(format: "%K == %@", #keyPath(SetlistNames.setlistid), slid as NSUUID)

//        guard let uuidQuery = UUID(uuidString: slid) else { return [] } // no valid UUID with this code
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Setlist.setlistid ), slid as NSUUID)
                
        @FetchRequest(entity: Setlist.entity(),
                      sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)],
                      predicate: predicate
        )
        var setlists: FetchedResults<Setlist>
        let name = setlists.first?.name ?? "Not Found"
        return name
    }
    
    
    var body: some View {
        // List songs in a given setlist
        let name = getSetlistName(slid: slid)
        List {
            Section("setlist: \(name)") {
                ForEach(setlists) { setlist in
                    HStack {
//                        Text("\(setlist.songid!)")
//                        Spacer()
                        Text("\(setlist.setlistid!)")
                        Spacer()
                        Text("\(setlist.name!)")
                    }
                }
                //            .onDelete(perform: deleteSong)
            }
        }
    }
    
    
    
    
}





//struct SetlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetlistView()
//    }
//}
