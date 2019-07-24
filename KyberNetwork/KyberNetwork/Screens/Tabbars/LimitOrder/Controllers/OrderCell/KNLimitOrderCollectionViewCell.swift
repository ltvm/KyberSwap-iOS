// Copyright SIX DAY LLC. All rights reserved.

import UIKit
import BigInt

protocol KNLimitOrderCollectionViewCellDelegate: class {
  func limitOrderCollectionViewCell(_ cell: KNLimitOrderCollectionViewCell, cancelPressed order: KNOrderObject)
  func limitOrderCollectionViewCell(_ cell: KNLimitOrderCollectionViewCell, showWarning order: KNOrderObject)
}

class KNLimitOrderCollectionViewCell: UICollectionViewCell {

  static let height: CGFloat = 96.0
  static let cellID: String = "kLimitOrderCollectionViewCell"

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var headerContainerView: UIView!

  @IBOutlet weak var pairValueLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var orderWarningIcon: UIButton!
  @IBOutlet weak var orderStatusLabel: UIButton!

  @IBOutlet weak var feeTextLabel: UILabel!
  @IBOutlet weak var feeValueLabel: UILabel!

  @IBOutlet weak var fromTextLabel: UILabel!
  @IBOutlet weak var sourceValueLabel: UILabel!

  @IBOutlet weak var toTextLabel: UILabel!
  @IBOutlet weak var destValueLabel: UILabel!
  @IBOutlet weak var leadingSpaceToContainerViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingSpaceToContainerViewConstraint: NSLayoutConstraint!

  @IBOutlet weak var cancelButton: UIButton!

  weak var delegate: KNLimitOrderCollectionViewCellDelegate?

  var pan: UIPanGestureRecognizer!
  var order: KNOrderObject!
  var hasAction: Bool = true

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.orderStatusLabel.rounded(radius: self.orderStatusLabel.frame.height / 2.0)
    self.feeTextLabel.text = "Fee".toBeLocalised().uppercased()
    self.fromTextLabel.text = NSLocalizedString("From", value: "From", comment: "").uppercased()
    self.toTextLabel.text = NSLocalizedString("To", value: "To", comment: "").uppercased()
    self.cancelButton.setTitle(
      NSLocalizedString("cancel", value: "Cancel", comment: "").uppercased(),
      for: .normal
    )

    let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(_:)))
    swipeLeftGesture.direction = .left
    self.addGestureRecognizer(swipeLeftGesture)

    let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.onSwipe(_:)))
    swipeRightGesture.direction = .right
    self.addGestureRecognizer(swipeRightGesture)
  }

  func updateCell(with order: KNOrderObject, isReset: Bool, hasAction: Bool = true, bgColor: UIColor) {
    self.containerView.backgroundColor = bgColor
    self.order = order
    self.hasAction = hasAction

    let rate = BigInt(order.targetPrice * pow(10.0, 18.0)).displayRate(decimals: 18)

    let srcTokenSymbol = order.srcTokenSymbol
    let destTokenSymbol = order.destTokenSymbol

    self.pairValueLabel.text = "\(srcTokenSymbol)  ➞  \(destTokenSymbol) >= \(rate)"

    self.orderWarningIcon.isHidden = order.messages.isEmpty
    self.addressLabel.text = "\(order.sender.prefix(8))..\(order.sender.suffix(4))"

    self.orderStatusLabel.isHidden = false
    switch order.state {
    case .open:
      self.orderStatusLabel.setTitle("Open".toBeLocalised(), for: .normal)
      self.orderStatusLabel.backgroundColor = UIColor(red: 234, green: 230, blue: 255)
      self.orderStatusLabel.setTitleColor(UIColor(red: 64, green: 50, blue: 148), for: .normal)
    case .inProgress:
      self.orderStatusLabel.setTitle("In progress".toBeLocalised(), for: .normal)
      self.orderStatusLabel.backgroundColor = UIColor(red: 222, green: 235, blue: 255)
      self.orderStatusLabel.setTitleColor(UIColor(red: 0, green: 73, blue: 176), for: .normal)
    case .filled:
      self.orderStatusLabel.setTitle("Filled".toBeLocalised(), for: .normal)
      self.orderStatusLabel.backgroundColor = UIColor(red: 215, green: 242, blue: 226)
      self.orderStatusLabel.setTitleColor(UIColor(red: 0, green: 102, blue: 68), for: .normal)
    case .cancelled:
      self.orderStatusLabel.setTitle("Cancelled".toBeLocalised(), for: .normal)
      self.orderStatusLabel.backgroundColor = UIColor(red: 255, green: 235, blue: 229)
      self.orderStatusLabel.setTitleColor(UIColor(red: 191, green: 38, blue: 0), for: .normal)
    case .invalidated:
      self.orderStatusLabel.setTitle("Invalidated".toBeLocalised(), for: .normal)
      self.orderStatusLabel.backgroundColor = UIColor(red: 247, green: 232, blue: 173)
      self.orderStatusLabel.setTitleColor(UIColor(red: 23, green: 43, blue: 77), for: .normal)
    default:
      self.orderStatusLabel.isHidden = true
    }
    let feeDisplay: String = {
      let feeDouble = order.fee * order.sourceAmount
      return NumberFormatterUtil.shared.displayLimitOrderValue(from: feeDouble)
    }()
    self.feeValueLabel.text = "\(feeDisplay) \(srcTokenSymbol)"

    let actualSrcAmount = order.sourceAmount
    self.sourceValueLabel.text = "\(NumberFormatterUtil.shared.displayLimitOrderValue(from: actualSrcAmount)) \(srcTokenSymbol)"
    self.destValueLabel.text = ">= \(NumberFormatterUtil.shared.displayLimitOrderValue(from: actualSrcAmount * order.targetPrice)) \(destTokenSymbol)"
    if hasAction {
      if order.state != .open {
        self.updateCancelButtonUI(isShowing: false, callFromSuper: true)
      } else {
        self.updateCancelButtonUI(isShowing: !isReset, callFromSuper: true)
      }
    }
  }

  @objc func onSwipe(_ gesture: UISwipeGestureRecognizer) {
    if self.order != nil && self.order.state != .open { return }
    if !self.hasAction { return }
    if gesture.state == .ended {
      self.updateCancelButtonUI(isShowing: gesture.direction == .left)
    }
  }

  fileprivate func updateCancelButtonUI(isShowing: Bool, callFromSuper: Bool = false) {
    if isShowing {
      UIView.animate(withDuration: 0.25, animations: {
          self.cancelButton.isHidden = false
          self.leadingSpaceToContainerViewConstraint.constant = -108
          self.trailingSpaceToContainerViewConstraint.constant = 108.0
          self.layoutIfNeeded()
      }, completion: { _ in
        if self.order != nil {
          self.delegate?.limitOrderCollectionViewCell(self, cancelPressed: self.order)
        }
      })
    } else {
      self.cancelButton.isHidden = true
      self.layoutIfNeeded()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        UIView.animate(withDuration: 0.16) {
          self.trailingSpaceToContainerViewConstraint.constant = 0
          self.leadingSpaceToContainerViewConstraint.constant = 0
          self.layoutIfNeeded()
        }
      }
    }
  }

  @IBAction func cancelButtonPressed(_ sender: Any) {
    if self.order == nil { return }
    if !self.hasAction { return }
    self.delegate?.limitOrderCollectionViewCell(self, cancelPressed: self.order)
  }

  @IBAction func orderWarningButtonPressed(_ sender: Any) {
    if self.order == nil { return }
    self.delegate?.limitOrderCollectionViewCell(self, showWarning: self.order)
  }
}
