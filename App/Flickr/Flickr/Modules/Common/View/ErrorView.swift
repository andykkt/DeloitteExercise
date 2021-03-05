//
//  ErrorView.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI

struct ErrorView<Content>: View where Content: View {
    let title: String?
    let description: String?
    var content: () -> Content
    let action: () -> Void
    
    init(title: String? = "An Error Occured",
         description: String? = nil,
         content: @escaping (() -> Content),
         action: @escaping (() -> Void))
    {
        self.title = title
        self.description = description
        self.content = content
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.content()
                    .disabled(true)
                    .blur(radius: 3)
                
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.4))
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    
                    if let title = title {
                        Text(title)
                            .markProFont(style: .alertTitle)
                            .foregroundColor(.black)
                    }
                    
                    if let description = description {
                        Text(description)
                            .markProFont(style: .body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: geometry.size.width * 0.6)
                            .padding(.bottom, 10)
                            .padding()
                    }
                    
                    Button(action: action) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.yellow)
                                .frame(height: 44)
                            
                            Text("OK")
                                .foregroundColor(.black)
                                .markProFont(style: .button)
                        }
                        .padding([.leading, .trailing], 10)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(backgroundView)
                .frame(width: geometry.size.width * 0.6)
                .frame(height: 120)
            }
        }
    }
    
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
           .foregroundColor(Color.white)
           .shadow(radius: 10)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(description: "Please try again later, error(Expected to decode Dictionary<String, Any> but found a string/data instead. (type: Dictionary<String, Any>, accessToken)") {
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
        } action: {
            
        }
    }
}
