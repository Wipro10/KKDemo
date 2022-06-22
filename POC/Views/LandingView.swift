
import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: HomeView()) {
                        Image("menu")
                    }
                }
                .padding()
                .background(.white)
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.96, opacity: 1))
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}

