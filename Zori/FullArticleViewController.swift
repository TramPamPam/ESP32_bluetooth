//
//  FullArticleViewController.swift
//  Zori
//
//  Created by Oleksandr on 8/1/18.
//  Copyright © 2018 ekreative. All rights reserved.
//

import UIKit

class FullArticleViewController: UIViewController {
    var article: Article!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = article.title
        detailTextView.text = article.body?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let articleImageSrc = article.img?.src,
            let url = URL(string: articleImageSrc),
            let data = try? NSData.init(contentsOf: url) as Data else { return }
        let image = UIImage(data : data)
        imageView.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailTextView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}
