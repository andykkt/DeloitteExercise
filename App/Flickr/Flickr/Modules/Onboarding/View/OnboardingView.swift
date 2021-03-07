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
                
                VStack {
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
                            Rectangle()
                                .foregroundColor(.yellow)
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
                .frame(width: geometry.size.width * 0.7)
                .shadow(radius: 10)
            }
        }
        .background(FlickrBackground())
        .ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
