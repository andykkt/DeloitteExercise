//
//  FlickrBackground.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct FlickrBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.mainBackground
                
                VStack(alignment: .center) {
                    HStack {
                        Circle()
                            .foregroundColor(.flickrBlue)
                            .frame(width: geometry.frame(in: .global).width)
                        
                        Circle()
                            .foregroundColor(.flickrPink)
                            .frame(width: geometry.frame(in: .global).width)
                    }
                    .frame(width: geometry.frame(in: .global).width)
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct FlickrBackground_Previews: PreviewProvider {
    static var previews: some View {
        FlickrBackground()
    }
}
