//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    let rawMovieList = json["feed"]["entry"].arrayValue
                    
                    let randomValue = Int(arc4random_uniform(UInt32(rawMovieList.count)))
                    print(randomValue)
                    
                    let movie = Movie(json: rawMovieList[randomValue])
                    
                    self.movieTitleLabel.text = movie.name
                    self.rightsOwnerLabel.text = movie.rightsOwner
                    self.releaseDateLabel.text = movie.releaseDate
                    self.priceLabel.text = String(movie.price)
                    self.loadPoster(movie.poster)
                    self.viewOniTunesPressed(movie.link)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: String(sender))!)
    }
    
}

