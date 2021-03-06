//
//  FavoriteDetailView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/11.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct FavoriteDetailView: View {
    @EnvironmentObject var store: FavoriteStore
    @EnvironmentObject var user: UserSettings
    @EnvironmentObject var main: PomodoroStore

    @State var favorite: Favorite

    var body: some View {
        List {
            Section {
                TextField("Title", text: $favorite.title)
                    .label(left: "Title")
                Text("\(favorite.count)")
                    .label(left: "Count")
                ProjectSelectorView(project: favorite.project) { project in
                    favorite.project = project
                }
                if let url = favorite.url {
                    Link(destination: url) {
                        Label(url.absoluteString, systemImage: "safari")
                    }
                }
                Link(destination: favorite.html_link) {
                    Label(favorite.html_link.absoluteString, systemImage: "link")
                }
            }

            Button("Start", action: actionStart)
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())
            Button("Update", action: actionUpdate)
                .buttonStyle(ActionButtonStyle())
                .modifier(CenterModifier())
                .disabled(
                    [
                        favorite.title.count > 0
                    ].contains(false))

        }
        .navigationBarTitle(favorite.title)
        .listStyle(GroupedListStyle())
    }

    func actionStart() {
        store.start(favorite: favorite) { pomodoro in
            user.currentTab = .countdown
            main.load()
        }
    }

    func actionUpdate() {
        store.update(favorite: favorite) { (newFavorite) in
            store.load()
        }
    }
}

//struct FavoriteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoriteDetailView()
//    }
//}
