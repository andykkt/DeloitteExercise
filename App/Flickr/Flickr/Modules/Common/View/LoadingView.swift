//
//  LoadingView.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {
    let title: String
    var content: () -> Content
    @State var showLoader = false
    var body: some View {
        ZStack {
            self.content()
                .disabled(true)
                .blur(radius: 3)
            
            Rectangle()
                .foregroundColor(Color.black.opacity(0.4))
                .ignoresSafeArea()

            VStack {
                if showLoader {
                    LoadingIndicatorView()
                }
                
                Text(title)
                    .foregroundColor(.black)
                    .markProFont(style: .body)
                    .padding(.top, 10)
            }
            .padding(.all, 60)
            .background(backgroundView)
        }
        .onAppear {
            DispatchQueue.main.async {
                showLoader.toggle()
            }
        }
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
           .foregroundColor(Color.white)
           .shadow(radius: 10)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            LoadingView(title: "Searching...") {
                VStack {
                    Rectangle()
                        .foregroundColor(.white)
                    Rectangle()
                        .foregroundColor(.blue)
                    Rectangle()
                        .foregroundColor(.red)
                    Rectangle()
                        .foregroundColor(.green)
                    Rectangle()
                        .foregroundColor(.white)
                }
                
            }
            .transition(.slide)
        }
        
    }
}
