// Copyright SIX DAY LLC. All rights reserved.

import UIKit
import BigInt

class KNAlertTableViewCell: UITableViewCell {

  static let height: CGFloat = 56.0
  @IBOutlet weak var tokenIcon: UIImageView!
  @IBOutlet weak var pairLabel: UILabel!
  @IBOutlet weak var alertPriceLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func updateCell(with alert: KNAlertObject, index: Int) {
    let placeHolder = UIImage(named: alert.token.lowercased())
    let url = "https://raw.githubusercontent.com/KyberNetwork/KyberNetwork.github.io/master/DesignAssets/tokens/iOS/\(alert.token.lowercased()).png"
    if let image = placeHolder {
      let newImage: UIImage? = alert.state == .active ? image : image.noir
      self.tokenIcon.image = newImage
    } else {
      let defaultImage: UIImage? = alert.state == .active ? UIImage(named: "default_token") : UIImage(named: "default_token")?.noir
      self.tokenIcon.setImage(
        with: url,
        placeholder: defaultImage,
        size: CGSize(width: 36.0, height: 36.0),
        applyNoir: alert.state != .active
      )
    }
    self.pairLabel.attributedText = {
      let attributedString = NSMutableAttributedString()
      let pair = "\(alert.token)/\(alert.currency)"
      let pairAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.foregroundColor: UIColor(red: 29, green: 48, blue: 58),
        NSAttributedStringKey.font: UIFont.Kyber.medium(with: 16),
      ]
      attributedString.append(NSAttributedString(string: pair, attributes: pairAttributes))
      if let triggered = alert.triggeredDate {
        let triggerAttributes: [NSAttributedStringKey: Any] = [
          NSAttributedStringKey.foregroundColor: UIColor.Kyber.grayChateau,
          NSAttributedStringKey.font: UIFont.Kyber.medium(with: 12),
        ]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        let triggerString = String(
          format: "Triggered: %@".toBeLocalised(),
          dateFormatter.string(from: Date(timeIntervalSince1970: triggered))
        )
        attributedString.append(NSAttributedString(string: "\n\(triggerString)", attributes: triggerAttributes))
      }
      return attributedString
    }()
    self.pairLabel.numberOfLines = 0
    self.alertPriceLabel.text = {
      let number = BigInt(alert.price * pow(10.0, 18.0))
      let string = number.displayRate(decimals: 18)
      if alert.isAbove { return ">= \(string)" }
      return "<= \(string)"
    }()
    self.alertPriceLabel.textColor = {
      if alert.state != .active {
        return UIColor.Kyber.grayChateau
      }
      return alert.isAbove ? UIColor.Kyber.shamrock : UIColor.Kyber.strawberry
    }()
    self.backgroundColor = index % 2 == 0 ? UIColor(red: 242, green: 243, blue: 246) : UIColor.clear
    self.tokenIcon.alpha = alert.state == .active ? 1.0 : 0.5
    self.layoutIfNeeded()
  }
}
