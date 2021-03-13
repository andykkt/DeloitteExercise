//
//  OnboardingView.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Environments
    
    @EnvironmentObject var appState: AppState
    
    // MARK: - Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                FlickrBackground()
                    .blur(radius: 52.0)
                
                ScrollView {
                    messageView
                }
            }
        }
        .background(FlickrBackground())
        .ignoresSafeArea()
    }
}

extension OnboardingView {
    private var messageView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                Text("Deloitte Flickr")
                    .foregroundColor(.white)
                    .flickrFont(style: .logo)
                
                Text("Simple Flickr Search")
                    .foregroundColor(.white)
                    .flickrFont(style: .body)

                Button(action: {
                    appState.onboarded()
                }, label: {
                    ZStack {
                        Color.yellow
                            .frame(height: 44)
                        
                        Text("Get started")
                            .foregroundColor(.black)
                            .flickrFont(style: .button)
                    }
                    .padding([.leading, .trailing], 10)
                })
                .padding()
            }
            .padding()
            .background(VisualEffectBlur(blurStyle: .light))
            .cornerRadius(22.0)
            .frame(width: UIScreen.main.bounds.width * 0.7)
            .shadow(radius: 10)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
