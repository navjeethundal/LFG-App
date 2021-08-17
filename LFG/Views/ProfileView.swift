//
//  ProfileView.swift
//  LFG
//
//  Created by victor lieu on 2020-10-21.
//  Copyright © 2020 LFG-APP. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @State var user = ""
    @State var pass = ""
    @State var login = false
    @State var signup = false
    
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        // set appearance for title
        appearance.titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor : UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)]
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)
    }
 
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                //.edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Profile", displayMode: .inline)
            
                Login(login: $login, signup: $signup, user: $user, pass: $pass)
                
             
            }.alert(isPresented: $login){
                Alert(title: Text(self.user), message: Text(self.pass), dismissButton: .none)
            }
            .sheet(isPresented: $signup){
                signUp(signup: self.$signup)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct Login : View {
    
    @Binding var login : Bool
    @Binding var signup : Bool
    @Binding var user : String
    @Binding var pass : String
    
    var body : some View{
        
        VStack(alignment: .center, spacing: 22, content: {
            Image("profile").resizable().frame(width: 80, height: 80).padding(.bottom, 15)
            HStack{
                Image(systemName: "person.fill").resizable().frame(width: 20, height: 20)
                TextField("Username", text: $user).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            
            HStack{
                Image(systemName: "lock.fill").resizable().frame(width: 15, height: 20).padding(.leading, 3)
                SecureField("Password", text: $pass).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            
            Button(action: {
                
                self.login.toggle()
               
            }) {
                Text("Login").foregroundColor(.white).padding().frame(width: 150)
            }
            .background(Color.blue)
            .cornerRadius(20)
            
            Button(action: {
               
            }) {
                Text("Forgot Password ?").foregroundColor(.white)
            }
            VStack{
                Text("dont have account yet").foregroundColor(.white)
                
                Button(action: {
                    
                    self.signup.toggle()
                   
                }) {
                    Text("Sign Up").foregroundColor(.white).padding().frame(width: 150)
                }
                .background(Color.blue)
                .cornerRadius(20)
            }.padding(.top, 35)
            
            
        })
        .padding(.horizontal, 18)
    }
}

struct signUp : View{
    
    @Binding var signup : Bool
    @State var user : String = ""
    @State var pass : String = ""
    @State var repass : String = ""
    
    var body : some View{
        ZStack {
            Color.black
        VStack(alignment: .center, spacing: 22, content: {
            Image("profile").resizable().frame(width: 80, height: 80).padding(.bottom, 15)
            HStack{
                Image(systemName: "person.fill").resizable().frame(width: 20, height: 20)
                TextField("Username", text: $user).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            
            HStack{
                Image(systemName: "lock.fill").resizable().frame(width: 15, height: 20).padding(.leading, 3)
                SecureField("Password", text: $pass).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            
            HStack{
                Image(systemName: "lock.fill").resizable().frame(width: 15, height: 20).padding(.leading, 3)
                SecureField("Re-Password", text: $repass).padding(.leading, 12).font(.system(size: 20))
            }.padding(12)
            .background(Color("grey"))
            .cornerRadius(20)
            
            Button(action: {
                self.signup.toggle()
                
            }) {
                Text("Sign Up").foregroundColor(.white).padding().frame(width: 150)
            }
            .background(Color.blue)
            .cornerRadius(20)
            
          
            
            
        })
        .padding(.horizontal, 18)
    }
    }
}
