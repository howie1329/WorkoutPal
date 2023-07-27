//
//  NewMessageViewModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/10/23.
//

import Foundation
import _PhotosUI_SwiftUI

class NewMessageViewModel: ObservableObject {
    @Published var feedUIImage: UIImage?
    @Published var feedPhotoPickerItem: PhotosPickerItem?
    
    let service = FeedService()
    
    func convertImage() async {
        guard let imageItem = feedPhotoPickerItem else {return}
        self.feedUIImage = await service.convertPhoto(imageItem)
    }
    
    func uploadMessage(_ message: MessageFeed) async {
        await service.createNewMessage(photo: feedPhotoPickerItem, message: message)
    }
}
