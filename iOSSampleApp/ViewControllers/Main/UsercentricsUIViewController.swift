import UIKit
import Usercentrics
import UsercentricsUI
import AppTrackingTransparency

class UsercentricsUIViewController: UIViewController {

    @IBOutlet weak var showUsercentricsButton: UIButton!
    @IBOutlet weak var showCustomUIButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUsercentrics()
        setupUI()
    }
    
    private func setupUsercentrics() {
        /// isReady is called after Usercentrics has finished initializing
        /// get the consent status of the user, via UsercentricsReadyStatus
        UsercentricsCore.isReady { [weak self] status in
            guard let self = self else { return }
            self.enableButtons()

            if status.shouldShowCMP {
                self.presentUsercentricsUI(showCloseButton: false)
            } else {
                self.applyConsent(with: status.consents)
            }
        } onFailure: { error in
            /// Handle error
            print(error.localizedDescription)
        }
    }

    private func presentUsercentricsUI(showCloseButton: Bool) {
        let settings = UsercentricsUISettings(customFont: nil,
                                              customLogo: nil,
                                              showCloseButton: showCloseButton)

        let viewController: UIViewController
        /// Get the UsercentricsUI and display it
        viewController = UsercentricsUserInterface.getPredefinedUI(settings: settings) { [weak self] response in
            guard let self = self else { return }
            /// Process consents
            self.applyConsent(with: response.consents)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }

        viewController.isModalInPresentation = true
        viewController.modalPresentationStyle = .overFullScreen

        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    private func applyConsent(with consents: [UsercentricsServiceConsent]) {
        /// https://docs.usercentrics.com/cmp_in_app_sdk/latest/apply_consent/apply-consent/#apply-consent-to-each-service
    }

}

extension UsercentricsUIViewController {

    @IBAction func didTapShowUsercentricsUI(_ sender: Any) {
        /// This is useful when you need to call our CMP from settings screen for instance, therefore the user may dismiss the view
        presentUsercentricsUI(showCloseButton: true)
    }

    @IBAction func didTapCustomUIMethods(_ sender: Any) {
        self.navigationController?.pushViewController(BuildYourOwnUIViewController(), animated: true)
    }

    private func enableButtons() {
        self.showUsercentricsButton.isEnabled = true
        self.showCustomUIButton.isEnabled = true
    }

    private func setupUI() {
        title = "Usercentrics"
    }
}
