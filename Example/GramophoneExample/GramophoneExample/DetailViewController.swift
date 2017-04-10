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

class DetailViewController: UITableViewController {
    private let gramophone: Gramophone
    private let mediaItem: Media
    private var tableItems: [Comment]
    
    required init(mediaItem: Media, gramophone: Gramophone) {
        self.gramophone = gramophone
        self.mediaItem = mediaItem
        self.tableItems = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        view.backgroundColor = UIColor.white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadComments()
    }
    
    // MARK: - Actions
    
    func loadComments() {
        gramophone.client.comments(mediaID: mediaItem.ID) { [weak self] commentResult in
            guard let strongSelf = self else { return }
            
            switch commentResult {
                
            case .success(let response):
                let comments = response.data.items
                for comment in comments {
                    print("Comment [ID: \(comment.ID), \(comment.text)]")
                }
                strongSelf.tableItems = comments
                strongSelf.tableView.reloadData()
                
            case .failure(let error):
                print("Failed to load comments: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        let comment = tableItems[indexPath.row]
        cell.textLabel!.text = "\(comment.user.fullName): \(comment.text)"
        cell.textLabel!.numberOfLines = 5
        cell.textLabel!.font = UIFont.systemFont(ofSize: 11)
        cell.imageView!.image = nil
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: comment.user.profilePictureURL)
                DispatchQueue.main.async {
                    cell.imageView!.image = UIImage(data: data)
                    cell.setNeedsLayout()
                }
            }
            catch {}
        }
        return cell
    }
}

