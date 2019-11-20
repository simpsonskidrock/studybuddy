import SwiftUI

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false

    @EnvironmentObject var session: SessionStore

    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }

    var body: some View {
        VStack {
            TextField("email", text: $email)
            SecureField("enter password", text: $password)
            if (error) {
                Text("ahhh crap")
            }
            Button(action: signIn) {
                Text("Sign in")
            }
        }
    }
}
