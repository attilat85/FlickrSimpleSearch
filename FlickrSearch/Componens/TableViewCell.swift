//
//  TableViewCell.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 20.06.2022.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    var photo: Photo? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        titleLabel?.text = photo?.title
        let url = URL(string: photo?.url ?? "")
        photoImageView?.contentMode = .scaleAspectFit
        photoImageView?.kf.setImage(with: url)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
