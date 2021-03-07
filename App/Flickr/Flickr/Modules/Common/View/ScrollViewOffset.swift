//
//  ScrollViewOffset.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct ScrollViewOffset<Content: View>: View {
    private let content: (ScrollViewProxy) -> Content
    private let onOffsetChange: (CGFloat) -> Void
    private let axes: Axis.Set
    private let showIndicators: Bool
    
    init(_ axes: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         @ViewBuilder content: @escaping (ScrollViewProxy) -> Content,
        onOffsetChange: @escaping (CGFloat) -> Void)
    {
        self.axes = axes
        self.showIndicators = showsIndicators
        self.onOffsetChange = onOffsetChange
        self.content = content
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(axes, showsIndicators: showIndicators) {
                offsetReader
                content(proxy)
                    .padding(.top, -8)
            }
            .coordinateSpace(name: "frameLayer")
            .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
        }
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: OffsetPreferenceKey.self,
                            value: proxy.frame(in: .named("frameLayer")).minY
                )
        }
        .frame(height: 0)
    }
}
