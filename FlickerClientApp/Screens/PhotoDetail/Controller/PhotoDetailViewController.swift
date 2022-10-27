//
//  PhotoDetailViewController.swift
//  FlickerClientApp
//
//  Created by Kürşat Şimşek on 24.10.2022.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let photo = photo {
            
            title = photo.title
            ownerNameLabel.text = photo.ownername
            descriptionLabel.text = photo.photoDescription?.content
            
            if let iconServer = photo.iconserver,
               let iconFarm = photo.iconfarm,
               let nsId = photo.owner,
               NSString(string: iconServer).intValue > 0 {
                NetworkManager.shared.fetchImage(with: "http://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(nsId).jpg") { data in
                    self.ownerImageView.image = UIImage(data: data)
                }
            } else {
                NetworkManager.shared.fetchImage(with: "https://www.flickr.com/images/buddyicon.gif") { data in
                    self.ownerImageView.image = UIImage(data: data)
                }
            }
            
            NetworkManager.shared.fetchImage(with: photo.urlZ) { data in
                self.imageView.image = UIImage(data: data)
            }
        }
        
 
    }

}
