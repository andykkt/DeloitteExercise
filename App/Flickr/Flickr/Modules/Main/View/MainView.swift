//
//  MainView.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: MainViewModel
    
    // MARK: - Content
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(dataProvider: MockDataProvider()))
    }
}
