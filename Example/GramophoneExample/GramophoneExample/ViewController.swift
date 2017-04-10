//
//  Gramophone.swift
//  Gramophone
//
//  Copyright (c) 2017 Jared Verdi. All Rights Reserved
//
//  Icon created by Gan Khoon Lay from the Noun Project
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
import UIKit
import Gramophone

let CLIENT_ID = "{YOUR_INSTAGRAM_CLIENT_ID}"
let REDIRECT_URI = "{YOUR_INSTAGRAM_REDIRECT_URI}"

class ViewController: UITableViewController {
    private var gramophone: Gramophone!
    
    private var tableItems: [Media]
    
    private var isLoggedIn = false {
        didSet {
            updateLoginButton()
            loadData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.tableItems = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        assert(CLIENT_ID != "{YOUR_INSTAGRAM_CLIENT_ID}" && REDIRECT_URI != "{YOUR_INSTAGRAM_REDIRECT_URI}",
               "Replace CLIENT_ID and REDIRECT_URI placeholders with your credentials from https://www.instagram.com/developer/clients/manage/ to run the demo.")
        
        setupGramophone()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gramophone"
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(didTapToggleLogin))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MediaCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Setup
    
    func setupGramophone() {
        let configuration = ClientConfiguration(
            clientID: CLIENT_ID,
            redirectURI: REDIRECT_URI,
            scopes: [.basic, .publicContent, .comments, .followerList, .likes, .relationships]
        )
        gramophone = Gramophone(configuration: configuration)
    }
    
    // MARK: - Actions
    
    func login() {
        gramophone.client.authenticate(from: self) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let accessToken = response.data
                print("Authenticated - access token: \(accessToken)")
                strongSelf.isLoggedIn = true
                
            case .failure(let error):
                print("Failed to authenticate: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() {
        gramophone.client.logout()
    }
    
    func loadData() {
        gramophone.client.myRecentMedia(options: nil) { [weak self] mediaResult in
            guard let strongSelf = self else { return }
            
            switch mediaResult {
                
            case .success(let response):
                let mediaItems = response.data.items
                for media in mediaItems {
                    if let images = media.images, let rendition = images[.thumbnail] {
                        print("Media [ID: \(media.ID), \(rendition.url)]")
                    }
                }
                strongSelf.tableItems = mediaItems
                strongSelf.tableView.reloadData()
                
            case .failure(let error):
                print("Failed to load media: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Login button
    
    func didTapToggleLogin() {
        if isLoggedIn {
            logout()
        }
        else {
            login()
        }
    }
    
    func updateLoginButton() {
        guard let leftBarButtonItem = navigationItem.leftBarButtonItem else { return }
        leftBarButtonItem.title = isLoggedIn ? "Logout" : "Login"
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        
        let mediaItem = tableItems[indexPath.row]
        cell.textLabel!.text = mediaItem.caption?.text
        cell.imageView!.image = nil
        if let images = mediaItem.images, let rendition = images[.thumbnail] {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: rendition.url)
                    DispatchQueue.main.async {
                        cell.imageView!.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
                catch {}
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaItem = tableItems[indexPath.row]
        let mediaViewController = DetailViewController(mediaItem: mediaItem, gramophone: gramophone)
        navigationController?.pushViewController(mediaViewController, animated: true)
    }
}

