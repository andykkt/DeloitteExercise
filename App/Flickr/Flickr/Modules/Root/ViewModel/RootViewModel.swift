//
//  RootViewModel.swift
//  Flickr
//
//  Created by Andy Kim on 6/3/21.
//

import SwiftUI
import Combine

class RootViewModel: ObservableObject, Identifiable {
    
    // MARK: - Dependencies
    
    let dataProvider: DataProvidable
    
    // MARK: - Init
    
    init(dataProvider: DataProvidable) {
        self.dataProvider = dataProvider
    }
}
