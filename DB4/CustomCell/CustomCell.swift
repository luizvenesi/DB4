//
//  CustomCell.swift
//  DB4
//
//  Created by Luiz on 2017-10-08.
//  Copyright © 2017 Luiz Venesi. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

  
  
    @IBOutlet weak var startSenator: UILabel!
    @IBOutlet weak var totalYear: UILabel!
    @IBOutlet weak var year: UILabel!
    
    @IBOutlet weak var other: UILabel!
    @IBOutlet weak var stateSenator: UILabel!
    
    @IBOutlet weak var partySenator: UILabel!
    @IBOutlet weak var nameSenator: UILabel!
    @IBOutlet weak var imageURL: UILabel!
    @IBOutlet weak var imageSenator: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //Call function Image
        get_image(String(imageURL.text!), imageSenator)
        imageURL.isHidden = true
    }
    //Func Convert URL in Image
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (
            data, response, error) in
            if data != nil
            {
                let image = UIImage(data: data!)
                if(image != nil)
                {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                        imageView.alpha = 0
                        UIView.animate(withDuration: 0.1, animations: {
                            imageView.alpha = 1.0
                        })
                    })
                }
            }
        })
        task.resume()
    }
}
