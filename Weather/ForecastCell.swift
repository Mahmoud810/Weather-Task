//
//  ForecastCell.swift
//  Weather
//
//  Created by Mahmoud on 17/07/2025.
//

import Foundation

import UIKit

class ForecastCell: UITableViewCell {
    static let identifier = "ForecastCell"

    let iconImageView = UIImageView()
    let dateLabel = UILabel()
    let tempLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let stack = UIStackView(arrangedSubviews: [dateLabel, tempLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 4

        let container = UIStackView(arrangedSubviews: [iconImageView, stack])
        container.spacing = 12
        container.alignment = .center

        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with entry: ForecastEntry) {
        dateLabel.text = entry.dt_txt
        tempLabel.text = "\(entry.main.temp)°C"
        descriptionLabel.text = entry.weather.first?.description.capitalized

        if let icon = entry.weather.first?.icon {
            let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
            if let url = url {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.iconImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
    }
}
