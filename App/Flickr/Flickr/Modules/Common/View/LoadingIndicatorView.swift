//
//  LoadingIndicatorView.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct LoadingIndicatorView: View {
    var size: CGFloat = 30
    @State private var shouldAnimate = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Circle()
                .fill(Color.blue)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5, anchor: .center)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever())
                .frame(width: size, height: size)
            Circle()
                .fill(Color.red)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5, anchor: .center)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
                .frame(width: size, height: size, alignment: .center)
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView()
    }
}
