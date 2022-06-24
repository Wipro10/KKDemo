
import SwiftUI

struct TopBar: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Image("profileIconSmall")
            VStack(alignment: .leading) {
                Text(NSLocalizedString(Constants.essexlad, comment: ""))
                    .font(.custom(FontConstants.bebasNeueRegular, size: 19))
                Text(NSLocalizedString(Constants.viewAndEditProfile, comment: ""))
                    .font(.custom(FontConstants.latoRegular, size: 13))
            }
            Spacer()
            ZStack {
                Image("Close")
                Image("CloseVector")
            }.onTapGesture {
                self.mode.wrappedValue.dismiss()
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 15)
        .padding(.vertical)
    }
}

struct VerifyView: View {
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString(Constants.getVerified, comment: ""))
                    .font(.custom(FontConstants.bebasNeueRegular, size: 39))
                Text(NSLocalizedString(Constants.becomeTrusted, comment: ""))
                    .font(.custom(FontConstants.latoRegular, size: 13))
                Button(action: {

                }) {
                    HStack {
                        Image("warning")
                        Text(NSLocalizedString(Constants.verifyNow, comment: ""))
                            .font(.custom(FontConstants.latoBold, size: 14))
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.35, blue: 0.35), Color(red: 0.95, green: 0, blue: 0)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(.infinity)
            }
            Image("image58")
                .frame(width: 100)
                .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color(red: 0.451, green: 0.541, blue: 0.612, opacity: 0.08), radius: 15)
        .padding(.horizontal)
        
    }
    
}

struct ProfileView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image("Ellipse 44")
                    .cornerRadius(.infinity)
                    .overlay(Circle().stroke(viewModel.isProfileCompleted ? .green : .red, lineWidth: 5))
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(FontConstants.bebasNeueRegular, size: 29))
                    Text(viewModel.message)
                        .font(.custom(FontConstants.latoRegular, size: 13))
                }
                Spacer(minLength: 0)
            }
            Button(action: {
                viewModel.completeProfile()
            }, label: {
                Text(viewModel.isProfileCompleted ? NSLocalizedString(Constants.success, comment: "") : NSLocalizedString(Constants.letsGetIt, comment: ""))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Group {
                        if viewModel.isProfileCompleted {
                            LinearGradient(gradient: Gradient(colors: [
                                Color(red: 129 / 255.0, green: 228.0 / 255.0, blue: 52 / 255.0, opacity: 1),
                                Color(red: 196 / 255.0, green: 241.0 / 255.0, blue: 161 / 255.0, opacity: 1)
                            ]), startPoint: .leading, endPoint: .trailing)
                        } else {
                            LinearGradient(gradient: Gradient(colors: [
                                Color(red: 0, green: 0.82, blue: 1, opacity: 1),
                                Color(red: 148.0 / 255.0, green: 228.0 / 255.0, blue: 1, opacity: 1)
                            ]), startPoint: .leading, endPoint: .trailing)
                        }
                     })
                    .cornerRadius(.infinity)
                    .padding(.top, 8)
            })
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: Color(red: 0.451, green: 0.541, blue: 0.612, opacity: 0.08), radius: 15)
        .padding(.horizontal)
    }
    
}

struct EventsView: View {
    
    var body: some View {
        ZStack {
            Image("eventsbg")
                .resizable()
            HStack {
                Spacer()
                Image("AmeliaxKittens")
            }
            .frame(maxWidth: .infinity)
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString(Constants.events, comment: ""))
                        .foregroundColor(.white)
                        .font(.custom(FontConstants.bebasNeueRegular, size: 39))
                    Text(NSLocalizedString(Constants.buyAndAccess, comment: ""))
                        .foregroundColor(.white)
                        .font(.custom(FontConstants.latoRegular, size: 13))
                }
                Spacer(minLength: 150)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .cornerRadius(20)
        .shadow(color: Color(red: 0.451, green: 0.541, blue: 0.612, opacity: 0.08), radius: 15)
        .padding(.horizontal)
    }
    
}

struct AccountSettings: View {
    var body: some View {
        HStack {
            Circle()
            .fill(Color(red: 0.962, green: 0.962, blue: 0.962, opacity: 1))
            .overlay(Circle().strokeBorder(Color(red: 175, green: 181, blue: 191, opacity: 0.45)))
            .overlay(Image("accountSetting"))
            .frame(width: 35, height: 35)
            Text(NSLocalizedString(Constants.accountSettings, comment: ""))
                .font(.custom(FontConstants.bebasNeueRegular, size: 20))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(.white)
    }
}

struct Logout: View {
    var body: some View {
        HStack {
            Circle()
            .fill(Color(red: 0.962, green: 0.962, blue: 0.962, opacity: 1))
            .overlay(Circle().strokeBorder(Color(red: 175, green: 181, blue: 191, opacity: 0.45)))
            .overlay(Image("logoutvector"))
            .frame(width: 35, height: 35)
            Text(NSLocalizedString(Constants.logout, comment: ""))
                .font(.custom(FontConstants.bebasNeueRegular, size: 20))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(.white)
    }
}



struct HomeView: View {
    
    //MARK: Properties
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    //MARK: Methods
    
    var body: some View {
        ZStack {
            VStack() {
                TopBar()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                ScrollView {
                    VerifyView()
                    ProfileView(viewModel: viewModel)
                    EventsView()
                    VStack(spacing: 0) {
                        AccountSettings()
                        Divider()
                        Logout()
                        Divider()
                    }
                }
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.96, opacity: 1))
            .alert(viewModel.alertMessage, isPresented: $viewModel.isShowAlert) {
                Button(NSLocalizedString(Constants.OK, comment: ""), role: .cancel) { }
            }
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.75)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).scaleEffect(1)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
