//
//  LoginView.swift
//  TimeBoxed
//
//  Created by ST20638 on 2020/04/09.
//  Copyright © 2020 Paul Traylor. All rights reserved.
//

import Combine
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.presentationMode) var presentation

    @State var username: String = ""
    @State var password: String = ""
    @State private var cancellable: AnyCancellable?

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            TextField("Login", text: $username)
                .textContentType(.emailAddress)
                .keyboardType( /*@START_MENU_TOKEN@*/.emailAddress /*@END_MENU_TOKEN@*/)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .textContentType(.password)
                .keyboardType(.asciiCapable)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: submitLogin) {
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            .disabled(username.isEmpty || password.isEmpty)
        }
    }

    func submitLogin() {
        cancellable = URLRequest.request(path: "/api/pomodoro", login: username, password: password)
            .dataTaskPublisher()
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (error) in
                    print(error)
                },
                receiveValue: { _ in
                    self.userSettings.users.append(self.username)
                    self.userSettings.current_user = self.username

                    Settings.keychain.set(self.password, for: self.username)
                    self.presentation.wrappedValue.dismiss()
                })
    }
}

#if DEBUG

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView().previewDevice(PreviewData.device)
        }
    }

#endif
