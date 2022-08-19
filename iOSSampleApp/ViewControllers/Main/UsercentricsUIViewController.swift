import UIKit
import Usercentrics
import UsercentricsUI
import AppTrackingTransparency

class UsercentricsUIViewController: UIViewController {

    @IBOutlet weak var showFirstLayerButton: UIButton!
    @IBOutlet weak var showSecondLayerButton: UIButton!
    @IBOutlet weak var customizationExampleOneButton: UIButton!
    @IBOutlet weak var customizationExampleTwoButton: UIButton!
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

            if status.shouldCollectConsent {
                self.presentFirstLayer()
            } else {
                self.applyConsent(with: status.consents)
            }
        } onFailure: { error in
            /// Handle error
            print(error.localizedDescription)
        }
    }

    private func presentFirstLayer(layout: UsercentricsLayout = .popup(position: .center),
                                   bannerSettings: BannerSettings? = nil) {
        guard let navigationController = self.navigationController else { fatalError("Navigation Controller needed") }

        // Launch Usercentrics Banner with your settings
        let banner = UsercentricsBanner(bannerSettings: bannerSettings)
        banner.showFirstLayer(hostView: navigationController, layout: layout) { [weak self] response in
            guard let self = self else { return }
            /// Process consents
            self.applyConsent(with: response.consents)
        }
    }

    private func presentSecondLayer() {
        guard let navigationController = self.navigationController else { fatalError("Navigation Controller needed") }

        // This is useful when you need to call our CMP from settings screen for instance, therefore the user may dismiss the view
        let banner = UsercentricsBanner(bannerSettings: BannerSettings(secondLayerStyleSettings: SecondLayerStyleSettings(showCloseButton: true)))
        banner.showSecondLayer(hostView: navigationController) { [weak self] response in
            guard let self = self else { return }
            /// Process consents
            self.applyConsent(with: response.consents)
        }
    }

    private func applyConsent(with consents: [UsercentricsServiceConsent]) {
        /// https://docs.usercentrics.com/cmp_in_app_sdk/latest/apply_consent/apply-consent/#apply-consent-to-each-service
    }
}

extension UsercentricsUIViewController {

    @IBAction func didTapShowFirstLayer(_ sender: Any) {
        self.presentFirstLayer()
    }

    @IBAction func didTapShowSecondLayer(_ sender: Any) {
        self.presentSecondLayer()
    }

    @IBAction func didTapShowCustomExampleOne(_ sender: Any) {
        self.presentFirstLayer(layout: .popup(position: .bottom), bannerSettings: customizationExample1())
    }

    @IBAction func didTapShowCustomExampleTwo(_ sender: Any) {
        self.presentFirstLayer(layout: .full, bannerSettings: customizationExample2())
    }

    @IBAction func didTapCustomUIMethods(_ sender: Any) {
        self.navigationController?.pushViewController(BuildYourOwnUIViewController(), animated: true)
    }

    private func enableButtons() {
        [showCustomUIButton, showFirstLayerButton, showSecondLayerButton, customizationExampleOneButton, customizationExampleTwoButton].forEach {
            $0.isEnabled = true
        }
    }

    private func setupUI() {
        title = "Usercentrics"
    }
}
