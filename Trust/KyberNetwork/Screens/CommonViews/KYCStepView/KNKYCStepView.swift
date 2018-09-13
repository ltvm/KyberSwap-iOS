// Copyright SIX DAY LLC. All rights reserved.

import UIKit

enum KNKYCStepViewState: Int {
  case personalInfo = 0
  case id = 1
  case submit = 2
  case done
}

class KNKYCStepView: XibLoaderView {

  let kInActiveBackgroundColor: UIColor = UIColor(red: 225, green: 225, blue: 225)
  let kActiveBackgroundColor: UIColor = UIColor.white
  let kDoneBackgroundColor: UIColor = UIColor.Kyber.lightSeaGreen

  let backgroundColors: [UIColor] = [
    UIColor(red: 225, green: 225, blue: 225),
    UIColor.white,
    UIColor.Kyber.lightSeaGreen,
  ]

  let borderColors: [UIColor] = [
    UIColor.clear,
    UIColor.Kyber.lightSeaGreen,
    UIColor.clear,
  ]

  let borderWidths: [CGFloat] = [0, 6, 0]

  let images: [UIImage?] = [
    nil,
    nil,
    UIImage(named: "done_white_icon"),
  ]

  let separatorBackgroundColors: [UIColor] = [
    UIColor(red: 225, green: 225, blue: 225),
    UIColor.Kyber.lightSeaGreen,
    UIColor.Kyber.lightSeaGreen,
  ]

  let textColors: [UIColor] = [
    UIColor.Kyber.grayChateau,
    UIColor.Kyber.grayChateau,
    UIColor.Kyber.lightSeaGreen,
  ]

  @IBOutlet weak var personalInfoStepImageView: UIImageView!
  @IBOutlet weak var firstSeparatorView: UIView!
  @IBOutlet weak var personalInfoLabel: UILabel!

  @IBOutlet weak var idImageView: UIImageView!
  @IBOutlet var secondSeparatorView: UIView!
  @IBOutlet weak var idLabel: UILabel!

  @IBOutlet weak var submitImageView: UIImageView!
  @IBOutlet weak var submitLabel: UILabel!

  override func commonInit() {
    super.commonInit()
    self.personalInfoStepImageView.rounded(radius: self.personalInfoStepImageView.frame.height / 2.0)
    self.idImageView.rounded(radius: self.idImageView.frame.height / 2.0)
    self.submitImageView.rounded(radius: self.submitImageView.frame.height / 2.0)

    self.personalInfoStepImageView.backgroundColor = kActiveBackgroundColor
    self.personalInfoStepImageView.rounded(
      color: UIColor.Kyber.lightSeaGreen,
      width: 6.0,
      radius: self.personalInfoStepImageView.frame.height / 2.0
    )
    self.idImageView.backgroundColor = kInActiveBackgroundColor
    self.submitImageView.backgroundColor = kInActiveBackgroundColor
  }

  func updateView(with state: KNKYCStepViewState) {
    let personalInfoState: Int = {
      return state == .personalInfo ? 1 : 2
    }()
    let idState: Int = {
      if state == .personalInfo { return 0 }
      if state == .id { return 1 }
      return 2
    }()
    let submitState: Int = {
      if state == .submit { return 1 }
      if state == .done { return 2 }
      return 0
    }()
    self.updatePersonalInfo(stateID: personalInfoState)
    self.updateID(stateID: idState)
    self.updateSubmit(stateID: submitState)
  }

  fileprivate func updatePersonalInfo(stateID: Int) {
    self.personalInfoStepImageView.image = self.images[stateID]
    self.personalInfoStepImageView.backgroundColor = self.backgroundColors[stateID]
    self.personalInfoLabel.textColor = self.textColors[stateID]
    self.personalInfoStepImageView.rounded(
      color: self.borderColors[stateID],
      width: self.borderWidths[stateID],
      radius: self.personalInfoStepImageView.frame.height / 2.0
    )
  }

  fileprivate func updateID(stateID: Int) {
    self.idImageView.image = self.images[stateID]
    self.idImageView.backgroundColor = self.backgroundColors[stateID]
    self.idLabel.textColor = self.textColors[stateID]
    self.firstSeparatorView.backgroundColor = stateID == 0 ? kInActiveBackgroundColor : kDoneBackgroundColor
    self.idImageView.rounded(
      color: self.borderColors[stateID],
      width: self.borderWidths[stateID],
      radius: self.idImageView.frame.height / 2.0
    )
  }

  fileprivate func updateSubmit(stateID: Int) {
    self.submitImageView.image = self.images[stateID]
    self.submitImageView.backgroundColor = self.backgroundColors[stateID]
    self.submitLabel.textColor = self.textColors[stateID]
    self.secondSeparatorView.backgroundColor = stateID == 0 ? kInActiveBackgroundColor : kDoneBackgroundColor
    self.submitImageView.rounded(
      color: self.borderColors[stateID],
      width: self.borderWidths[stateID],
      radius: self.submitImageView.frame.height / 2.0
    )
  }
}
