//
//  DetailViewController.swift
//

import UIKit
import Nuke

class DetailViewController: UIViewController {

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterImageShadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    @IBAction func tapbutton1(_ sender: UIButton) {
        handleRatingButtonTap(index: 0)
    }
    
    
    @IBAction func tapbutton2(_ sender: UIButton) {
        handleRatingButtonTap(index: 1)
    }
  
    @IBAction func tapbutton3(_ sender: UIButton) {
        handleRatingButtonTap(index: 2)
    }
    
    @IBAction func tapbutton4(_ sender: UIButton) {
        handleRatingButtonTap(index: 3)
    }
    
    @IBAction func tapbutton5(_ sender: UIButton) {
        handleRatingButtonTap(index: 4)
    }
    
    func handleRatingButtonTap(index: Int) {
        // Call the common function to handle button tap
        ratingButtonTapped(ratingButtons[index])
    }
    
    
    var movie: Movie!
    
    var ratingButtons: [UIButton] = []
    var numberOfRatings: Int = 0
    var totalRating: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add buttons to the array
        ratingButtons = [button1, button2, button3, button4, button5]

                // Set initial button states
        updateButtonStates(selectedButtonIndex: -1)




        // MARK: Style views
        posterImageView.layer.cornerRadius = 20
        posterImageView.layer.borderWidth = 2
        posterImageView.layer.borderColor = UIColor.white.cgColor

        posterImageShadowView.layer.cornerRadius = posterImageView.layer.cornerRadius
        posterImageShadowView.layer.shadowColor = UIColor.black.cgColor
        posterImageShadowView.layer.shadowOpacity = 0.5
        posterImageShadowView.layer.shadowOffset = CGSize(width: -3, height: 0)
        posterImageShadowView.layer.shadowRadius = 5

        // MARK: - Set text for labels
        titleLabel.text = movie.title
        overviewTextView.text = movie.overview

        // Unwrap the optional vote average
        if let voteAverage = movie.voteAverage {

            // voteAverage is a Double
            // We can convert it to a string using `\(movie.voteAverage)` (aka *String Interpolation*)
            // inside string quotes (aka: *string literal*)
            voteLabel.text = "Rating: \(totalRating)"
        } else {

            // if vote average is nil, set vote average label text to empty string
            voteLabel.text = ""
        }

        // The `releaseDate` is a `Date` type. We can convert it to a string using a `DateFormatter`.
        // Create a date formatter
        let dateFormatter = DateFormatter()

        // Set the date style for how the date formatter will display the date as a string.
        // You can experiment with other settings like, `.short`, `.long` and `.full`
        dateFormatter.dateStyle = .medium

        // Unwrap the optional release date
        if let releaseDate = movie.releaseDate {

            // Use the the date formatter's `string(from: Date)` method to convert the date to a string
            let releaseDateString = dateFormatter.string(from: releaseDate)
            releaseDateLabel.text = "Released: \(releaseDateString)"
        } else {

            // if release date is nil, set release date label text to empty string
            releaseDateLabel.text = ""
        }

        // MARK: - Fetch and set images for image views

        // Unwrap the optional poster path
        if let posterPath = movie.posterPath,

            // Create a url by appending the poster path to the base url. https://developers.themoviedb.org/3/getting-started/images
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) {

            // Use the Nuke library's load image function to (async) fetch and load the image from the image url.
            Nuke.loadImage(with: imageUrl, into: posterImageView)
        }

        // Unwrap the optional backdrop path
        if let backdropPath = movie.backdropPath,

            // Create a url by appending the backdrop path to the base url. https://developers.themoviedb.org/3/getting-started/images
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500" + backdropPath) {

            // Use the Nuke library's load image function to (async) fetch and load the image from the image url.
            Nuke.loadImage(with: imageUrl, into: backdropImageView)
        }
    }

    @IBAction func ratingButtonTapped(_ sender: UIButton) {
            guard let selectedIndex = ratingButtons.firstIndex(of: sender) else {
                return
            }

            // Calculate new rating
            numberOfRatings += 1
            totalRating += selectedIndex + 1

            // Update button states
            updateButtonStates(selectedButtonIndex: selectedIndex)

            // Print or use the new rating
        let averageRating = numberOfRatings == 0 ? 0 : Double(totalRating) / Double(numberOfRatings)
        
        voteLabel.text = "Rating: \(averageRating)"
        }

    func updateButtonStates(selectedButtonIndex: Int) {
        for (index, button) in ratingButtons.enumerated() {
            button.isEnabled = (index <= selectedButtonIndex && selectedButtonIndex != -1)
        }
    }

}
