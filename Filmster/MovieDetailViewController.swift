//
//  MovieDetailViewController.swift
//  Filmster
//
//  Created by Aditya Parikh on 9/15/14.
//  Copyright (c) 2014 Aditya Parikh. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieDetailsLabel: UILabel!
    @IBOutlet weak var movieDetailLabelViewContainer: UIView!
    var isDetailPositionDown = false;
    var moviePosterURL : String!
    var moviePosterPlaceHolderURL : String!
    var movieDetailsText : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        var placeHolderImageView = UIImageView()
        //placeHolderImageView.setImageWithURL(NSURL(string: moviePosterPlaceHolderURL))
        //moviePosterImageView.setImageWithURL(NSURL(string: moviePosterURL), placeholderImage: placeHolderImageView.image)
        movieDetailsLabel.text = movieDetailsText
        //movieDetailsLabel.animationDidStart(<#anim: CAAnimation!#>)
        moviePosterImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: moviePosterPlaceHolderURL)), placeholderImage: nil, success: { (request, response, image) -> Void in
            self.moviePosterImageView.image = image
            self.moviePosterImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: self.moviePosterURL)), placeholderImage: nil, success: { (request, response, image) -> Void in
                self.moviePosterImageView.image = image
                }, failure: nil)
            // Do any additional setup after loading the view.
            }, failure: nil)
        // Do any additional setup after loading the view.
    }
    @IBAction func movieDetailLabelTapped(sender: AnyObject) {
        if(self.isDetailPositionDown){
            slideUp()
        }else{
            slideDown()
        }
        self.isDetailPositionDown = !self.isDetailPositionDown
    }

    func slideDown() {
            UIView.animateWithDuration(1.0, animations: {
            // slide down
            self.movieDetailLabelViewContainer.frame = CGRectMake(0, 400, 320, 340);
        })
    }
    
    func slideUp() {
        UIView.animateWithDuration(0.5, animations: {
            // slide down
            self.movieDetailLabelViewContainer.frame = CGRectMake(0, 100, 320, 340);
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
