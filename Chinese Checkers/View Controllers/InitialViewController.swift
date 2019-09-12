//
//  InitialViewController.swift
//  Chinese Checkers
//
//  Created by Thalys Viana on 17/08/19.
//  Copyright © 2019 Thalys Viana. All rights reserved.
//

import UIKit
import SwiftGRPC

class InitialViewController: UIViewController {

    
    @IBOutlet weak var hostPortTextField: UITextField!
    @IBOutlet weak var clientAddressTextField: UITextField!
    @IBOutlet weak var clientPortTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var hostWifiAddressLabel: UILabel!
    
    var playerType: [PlayerType] = []
    
    var changed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getHostIpAddress()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func getHostIpAddress() {
        guard let wifiAddress = Server.shared.getWiFiAddress() else {
            print("Could not get wifi address.")
            return
        }
        hostWifiAddressLabel.text = "Current Address: \(wifiAddress)"
    }
    
    // MARK: - Actions
    
    @IBAction func connectButtonClicked(_ sender: UIButton) {
        Server.shared
            .setPort(hostPortTextField.text!)
            .start()
        startButton.isEnabled = true
        
        Client.shared.connect(address: clientAddressTextField.text ?? "127.0.0.1", port: clientPortTextField.text!) {
            Client.shared.identifyPlayer(playerType: "RED")
        }
    }
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameVC" {
            if let destination = segue.destination as? GameViewController {
                destination.player = Server.shared.player
            }
        }
    }

}
