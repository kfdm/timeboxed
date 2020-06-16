//
//  ExtendPomodoroView.swift
//  TimeBoxed
//
//  Created by Paul Traylor on 2020/06/05.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import SwiftUI

struct ExtendPomodoroView: View {
    @ObservedObject var store = PomodoroStore.shared
    var pomodoro: Pomodoro

    var body: some View {
        Section(header: Text("Extend")) {
            Button(action: actionAddPomodoro) {
                Text("25 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionAddHour) {
                Text("60 Min")
            }
            .buttonStyle(ActionButtonStyle())
            .modifier(CenterModifier())

            Button(action: actionStop) {
                Text("Stop")
            }
            .buttonStyle(DangerButtonStyle())
            .modifier(CenterModifier())
        }
    }

    func actionAddPomodoro() {
        store.update(id: pomodoro.id, end: pomodoro.end.addingTimeInterval(25 * 60)) { pomodoro in
            print(pomodoro)
        }
    }

    func actionAddHour() {
        store.update(id: pomodoro.id, end: pomodoro.end.addingTimeInterval(60 * 60)) { pomodoro in
            print(pomodoro)
        }
    }

    func actionStop() {
        store.update(id: pomodoro.id, end: Date()) { pomodoro in
            print(pomodoro)
        }
    }
}

#if DEBUG

    struct ExtendPomodoroView_Previews: PreviewProvider {

        static var previews: some View {
            ExtendPomodoroView(pomodoro: PreviewData.pomodoro)
        }
    }

#endif
