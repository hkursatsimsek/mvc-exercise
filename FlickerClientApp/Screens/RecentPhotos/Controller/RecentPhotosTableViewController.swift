//
//  RecentPhotosTableViewController.swift
//  FlickerClientApp
//
//  Created by Kürşat Şimşek on 24.10.2022.
//

import UIKit

class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {    
    
    var response: PhotosResponse? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }    
    
    private var selectedPhoto: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchController()
        fetchRecentPhotos()
        
    }
    
    private func setUpSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Arayacığınız kelimeyi giriniz."
        navigationItem.searchController = searchController
    }
    
    private func fetchRecentPhotos() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=acdcc2550543d5ec16ddb1270174d4b6&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                self.response = response
            }
        }.resume() 
    }
    
    private func searchPhotos(with text: String) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=acdcc2550543d5ec16ddb1270174d4b6&text=\(text)&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                debugPrint(error)
                return
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosResponse.self, from: data) {
                self.response = response
                self.tableView.reloadData()
            }
        }.resume() 
    }
    

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentPhotosCell", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        if let response = response, let photos = response.photos, let photo = photos.photo {
            let myPhoto = photo[indexPath.row]
            cell.ownerImageView.backgroundColor = .darkGray
            cell.ownerNameLabel.text = myPhoto.ownername
            
            NetworkManager.shared.fetchImage(with: myPhoto.buddyIconUrl) { data in
                cell.ownerImageView.image = UIImage(data: data)
            }
            
            NetworkManager.shared.fetchImage(with: myPhoto.urlN) { data in
                cell.photoImageView.image = UIImage(data: data)
            }
            
            cell.titleLabel.text = myPhoto.title
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let response = response, let photos = response.photos, let photo = photos.photo {
            self.selectedPhoto = photo[indexPath.row]
        }
        performSegue(withIdentifier: "toDetailSegue", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetailViewController {
            vc.photo = self.selectedPhoto
        }
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            DispatchQueue.main.async {
                self.searchPhotos(with: text)
                self.tableView.reloadData()
            }
        }
    }

}
