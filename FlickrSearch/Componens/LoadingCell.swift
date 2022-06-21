//
//  LoadingCell.swift
//  FlickrSearch
//
//  Created by Attila Tamas on 21.06.2022.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.startAnimating()
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        loadingIndicator.startAnimating()
    }
}
