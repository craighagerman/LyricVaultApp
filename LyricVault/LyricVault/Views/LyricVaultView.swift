//
//  LyricVaultView.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-25.
//

import SwiftyDropbox
import SwiftUI

struct LyricVaultView: View {
        
    var body: some View {
  
        NavigationStack {
            Text("SwiftUI")
                .navigationTitle("LyricVaultView")
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
//                        Button("Import Songs") {
//                            print("Import Songs tapped")
//                        }
                        
                        NavigationLink(destination: ImportSongsView() ) {
                            Text("Import Songs")
                        }
                        
                        
                        // ---
                    }
                }
        }
        
        
//        VStack {
//            HStack {
//                Text("Lyric Vault").font(.title).padding()
//                Spacer()
//                Button {
//                    openSettings()
//                } label: {
//                    Image(systemName: "gearshape")
//                }.padding()
//            }
//            Spacer()
//            LibraryView()
//        }
        
        
    }
    
    func openSettings() {
        print("Gear button was tapped")
    }
}

struct LyricVaultView_Previews: PreviewProvider {
    static var previews: some View {
        LyricVaultView()
    }
}
