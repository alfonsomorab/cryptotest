//
//  ViewController.swift
//  Cryptotest
//
//  Created by alfonso on 4/11/18.
//  Copyright © 2018 alfonso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(2048)
        
        let privateKeyPEM = SwKeyConvert.PrivateKey.derToPKCS1PEM(privateKey)
        let publicKeyPEM = SwKeyConvert.PublicKey.derToPKCS8PEM(publicKey)
        
        print("Public Key: \(publicKeyPEM)")
        print("Private Key: \(privateKeyPEM)")
        
        let message = "Esto es un mensaje de prueba".data(using: .utf8)
        let tag = "".data(using: .utf8)
        
        let encrypt = try! CC.RSA.encrypt(message!, derKey: publicKey, tag: tag!, padding: .oaep, digest: .sha1)
        let b64 = encrypt.base64EncodedString(options: [])
        
        print("Mensaje codificado: \(b64)")
        
        let decrypt = try! CC.RSA.decrypt(encrypt, derKey: privateKey, tag: tag!, padding: .oaep, digest: .sha1)
        let db64 = String(data: decrypt.0, encoding: String.Encoding.utf8) as String!
        print("====================================")
        print("Mensaje decodificado: \(String(describing: db64!))")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension String{
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
        
    }
}

