//
//  Created by Tom Baranes on 16/07/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

import UIKit

public class AnimatablePresentedViewController: UIViewController, PresentationDesignable {

  // MARK: - PresentationAnimatable

  @IBInspectable public var presentationAnimationType: String? {
    didSet {
      setupPresenter()
    }
  }

  @IBInspectable public var dismissAnimationType: String? {
    didSet {
      setupPresenter()
    }
  }

  @IBInspectable public var transitionDuration: Double = .NaN {
    didSet {
      presenter?.transitionDuration = transitionDuration
    }
  }

  @IBInspectable public var cornerRadius: CGFloat = .NaN {
    didSet {
      presenter?.presentedSetup?.cornerRadius = cornerRadius
    }
  }

  @IBInspectable public var dismissOnTap: Bool = true {
    didSet {
      presenter?.presentedSetup?.dismissOnTap = dismissOnTap
    }
  }

  @IBInspectable public var backgroundColor: UIColor = .blackColor() {
    didSet {
      presenter?.presentedSetup?.backgroundColor = backgroundColor
    }
  }

  @IBInspectable public var opacity: CGFloat = 0.7 {
    didSet {
      presenter?.presentedSetup?.opacity = opacity
    }
  }

  // MARK: Private

  private var presenter: PresentationPresenter?

  // MARK: Life cycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupPresenter()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupPresenter()
  }

  // MARK: Life cycle

  override public func viewDidLoad() {
    super.viewDidLoad()
  }

  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let animationType = PresentationAnimationType.fromString(dismissAnimationType ?? "") ?? PresentationAnimationType.Cover(fromDirection: .Bottom)
    if let dismissSystemTransition = animationType.systemTransition {
      modalTransitionStyle = dismissSystemTransition
    }
  }

  // MARK: Helper

  func setupPresenter() {
    let animationType = PresentationAnimationType.fromString(presentationAnimationType ?? "") ?? PresentationAnimationType.Cover(fromDirection: .Bottom)
    presenter = PresentationPresenterManager.sharedManager().retrievePresenter(animationType, transitionDuration: transitionDuration)
    presenter?.dismissAnimationType = PresentationAnimationType.fromString(dismissAnimationType ?? "")
    transitioningDelegate = presenter
    modalPresentationStyle = .Custom
    if let systemTransition = animationType.systemTransition {
      modalTransitionStyle = systemTransition
    }

    var presentedSetup = PresentedSetup()
    presentedSetup.cornerRadius = cornerRadius
    presentedSetup.dismissOnTap = dismissOnTap
    presentedSetup.backgroundColor = backgroundColor
    presentedSetup.opacity = opacity
    presenter?.presentedSetup = presentedSetup
  }

}