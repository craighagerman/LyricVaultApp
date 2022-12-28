//
//  SelectableList.swift
//  LyricVault
//
//  Created by Craig Hagerman on 2022-12-23.
//

import SwiftUI

struct SelectableList: View {
    @State var isEditing = true
    @State private var selection = Set<String>()

    let names = [ "Cyril", "Lana", "Mallory", "Sterling" ]

    var body: some View {
        NavigationStack {
            List(names, id: \.self, selection: $selection) { name in
                Text(name)
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
            .navigationTitle("List Selection")
//            .toolbar {
//                EditButton()
//            }
        }.onAppear {
//            self.isEditing.toggle()
            print("OnAppear")
        }
    }
}

struct SelectableList_Previews: PreviewProvider {
    static var previews: some View {
        SelectableList()
    }
}
