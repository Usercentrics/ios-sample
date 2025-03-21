import UIKit
import Usercentrics
import UsercentricsUI
import AppTrackingTransparency

class UsercentricsUIViewController: UIViewController {

    @IBOutlet weak var showFirstLayerGDPR: UIButton!
    @IBOutlet weak var showSecondLayerGDPR: UIButton!
    @IBOutlet weak var showFirstLayerTCF: UIButton!
    @IBOutlet weak var showSecondLayerTCF: UIButton!
    @IBOutlet weak var showFirstLayerCCPA: UIButton!
    @IBOutlet weak var showSecondLayerCCPA: UIButton!
    
    private let gdprSettingsId = "lQ_Dio7QL"
    private let tcfSettingsId = "EA4jnNPb9"
    private let ccpaSettingsId = "NfThHXzzZNc-RE"

    override func viewDidLoad() {
        super.viewDidLoad()

        //setupUsercentrics()
        enableButtons()
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

    private func presentFirstLayer(layout: UsercentricsLayout = .full,
                                   bannerSettings: BannerSettings? = nil) {
        guard let navigationController = self.navigationController else { fatalError("Navigation Controller needed") }

        
        UsercentricsCore.isReady { [weak self] status in
            guard let self = self else { return }
            let banner = UsercentricsBanner(bannerSettings: bannerSettings)
            banner.showFirstLayer(hostView: navigationController, layout: layout) { [weak self] response in
                guard let self = self else { return }
                /// Process consents
                self.applyConsent(with: response.consents)
            }
        } onFailure: { error in
            // Handle non-localized error
        }

    }

    private func presentSecondLayer() {
        guard let navigationController = self.navigationController else { fatalError("Navigation Controller needed") }
        
        UsercentricsCore.isReady { [weak self] status in
            // This is useful when you need to call our CMP from settings screen for instance, therefore the user may dismiss the view
            let banner = UsercentricsBanner(bannerSettings: BannerSettings(secondLayerStyleSettings: SecondLayerStyleSettings(showCloseButton: true)))
            banner.showSecondLayer(hostView: navigationController) { [weak self] response in
                guard let self = self else { return }
                /// Process consents
                self.applyConsent(with: response.consents)
            }

        } onFailure: { error in
            // Handle non-localized error
        }
        
    }

    private func applyConsent(with consents: [UsercentricsServiceConsent]) {
        /// https://docs.usercentrics.com/cmp_in_app_sdk/latest/apply_consent/apply-consent/#apply-consent-to-each-service
    }
    
    private func initialize(_settingsId: String) {
        let options = UsercentricsOptions(settingsId: _settingsId)
        options.loggerLevel = .debug
        UsercentricsCore.configure(options: options)
    }
    
    private func clearAndInitAgain(_settingsId: String){
        UsercentricsCore.isReady { [weak self] status in
            guard let self = self else { return }
            UsercentricsCore.shared.clearUserSession(onSuccess: { status in
                // This callback is equivalent to isReady API
            }, onError: { error in
                // Handle non-localized error
            })
        } onFailure: { error in
            // Handle non-localized error
        }
        self.initialize(_settingsId: _settingsId)
    }
}

extension UsercentricsUIViewController {

    @IBAction func didTapShowFirstLayerGDPR(_ sender: Any) {
        clearAndInitAgain(_settingsId: gdprSettingsId)
        self.presentFirstLayer()
    }

    @IBAction func didTapShowSecondLayerGDPR(_ sender: Any) {
        clearAndInitAgain(_settingsId: gdprSettingsId)
        self.presentSecondLayer()
    }

    @IBAction func didTapShowFirstLayerTCF(_ sender: Any) {
        clearAndInitAgain(_settingsId: tcfSettingsId)
        self.presentFirstLayer()
    }

    @IBAction func didTapShowSecondLayerTCF(_ sender: Any) {
        clearAndInitAgain(_settingsId: tcfSettingsId)
        self.presentSecondLayer()
    }

    @IBAction func didTapShowFirstLayerCCPA(_ sender: Any) {
        clearAndInitAgain(_settingsId: ccpaSettingsId)
        self.presentFirstLayer()
    }
    
    @IBAction func didTapShowSecondLayerCCPA(_ sender: Any) {
        clearAndInitAgain(_settingsId: ccpaSettingsId)
        self.presentSecondLayer()
    }

    private func enableButtons() {
        [showFirstLayerCCPA, showSecondLayerCCPA, showFirstLayerGDPR, showSecondLayerGDPR, showFirstLayerTCF, showSecondLayerTCF].forEach {
            $0.isEnabled = true
        }
    }

    private func setupUI() {
        title = "Usercentrics"
    }
}
