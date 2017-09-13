//
//  ColorServiceProvider.swift
//  ColorMaster
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ColorServiceProviderDelegate: class {
    func provider(_ provider: ColorServiceProvider, listOfConnectedPeersHasChanged list: [String])
    func provider(_ provider: ColorServiceProvider, didReceived color: UIColor, from peer: String)
}

final class ColorServiceProvider: NSObject {
    
    fileprivate let serviceName = "cm-service"
    fileprivate let advertiser: MCNearbyServiceAdvertiser
    fileprivate let browser: MCNearbyServiceBrowser
    fileprivate let peerId: MCPeerID
    lazy var session: MCSession = {
        let session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    weak var delegate: ColorServiceProviderDelegate?
    
    init(with displayName: String) {
        peerId = MCPeerID(displayName: displayName)
        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: serviceName)
        browser = MCNearbyServiceBrowser(peer: peerId, serviceType: serviceName)
        
        super.init()
        
        advertiser.delegate = self
        browser.delegate = self
        
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func send(_ color: UIColor) throws {
        let data = color.data
        try session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
}

extension ColorServiceProvider: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, session)
    }
}

extension ColorServiceProvider: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID)")
        print("invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
    }
}
extension ColorServiceProvider: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state)")
        delegate?.provider(self, listOfConnectedPeersHasChanged: session.connectedPeers.map{ $0.displayName })
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        delegate?.provider(self, didReceived: UIColor(data: data), from: peerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
}



