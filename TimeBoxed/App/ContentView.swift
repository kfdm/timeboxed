//
//  ContentView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
        case countdown
        case favorites
        case project
        case history
        case settings
    }

    @EnvironmentObject var userSettings: UserSettings
    @State private var currentTab = ContentView.Tab.countdown
    @State private var showLogin = false

    var body: some View {
        TabView(selection: $currentTab) {
            CountdownPageView()
                .tabItem {
                    VStack {
                        Image("stopwatch")
                        Text("Active")
                    }
                }
                .tag(Tab.countdown)

            FavoriteListView(selection: $currentTab)
                .tabItem {
                    VStack {
                        Image("star")
                        Text("Favorite")
                    }
                }
                .tag(Tab.favorites)
            ProjectList()
                .tabItem {
                    Text("Projects")
                }
                .tag(Tab.project)
            HistoryView()
                .tabItem {
                    VStack {
                        Image("calendar")
                        Text("History")
                    }
                }
                .tag(Tab.history)
            SettingsView()
                .tabItem {
                    VStack {
                        Image("maintenance")
                        Text("Settings")
                    }
                }
                .tag(Tab.settings)

        }
        .sheet(isPresented: $showLogin) {
            LoginView()
                .environmentObject(self.userSettings)
        }
        .onAppear {
            self.showLogin = self.userSettings.current_user == nil
        }
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().previewDevice(PreviewData.device)
        }
    }

#endif