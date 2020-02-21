//
//  DescriptorParser.swift
//  FullyNoded2
//
//  Created by Peter on 15/02/20.
//  Copyright © 2020 Blockchain Commons, LLC. All rights reserved.
//

import Foundation

// Examples:
// pk(0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798)
// pkh(02c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5)
// wpkh(02f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9)
// sh(wpkh(03fff97bd5755eeea420453a14355235d382f6472f8568a18b2f057a1460297556))
// combo(0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798)
// multi(1,022f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4,025cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc)
// sh(multi(2,022f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01,03acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe))
// sh(sortedmulti(2,03acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe,022f01e5e15cca351daff3843fb70f3c2f0a1bdd05e5af888a67784ef3e10a2a01))
// wsh(multi(2,03a0434d9e47f3c86235477c7b1ae6ae5d3442d49b1943c2b752a68e2a47e247c7,03774ae7f858a9411e5ef4246b70c65aac5649980be5c17891bbec17895da008cb,03d01115d548e7561b15c38f004d734633687cf4419620095bc5b0f47070afe85a))
// sh(wsh(multi(1,03f28773c2d975288bc7d1d205c3748651b075fbc6610e58cddeeddf8f19405aa8,03499fdf9e895e719cfd64e67f07d38e3226aa7b63678949e6e49b241a60e823e4,02d7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e)))
// pk(xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8)
// pkh(xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw/1'/2)
// pkh([d34db33f/44'/0'/0']xpub6ERApfZwUNrhLCkDtcHTcxd75RbzS1ed54G1LkBUHQVHQKqhMkhgbmJbZRkrgZw4koxb5JaHWkY4ALHY2grBGRjaDMzQLcgJvLJuZZvRcEL/1/*)

// wsh(multi(1,xpub661MyMwAqRbcFW31YEwpkMuc5THy2PSt5bDMsktWQcFF8syAmRUapSCGu8ED9W6oDMSgv6Zz8idoc4a6mr8BDzTJY47LJhkJ8UB7WEGuduB/1/0/*,xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH/0/0/*))

//wsh(sortedmulti(1,xpub661MyMwAqRbcFW31YEwpkMuc5THy2PSt5bDMsktWQcFF8syAmRUapSCGu8ED9W6oDMSgv6Zz8idoc4a6mr8BDzTJY47LJhkJ8UB7WEGuduB/1/0/*,xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH/0/0/*))

class DescriptorParser {
    
    func descriptor(_ descriptor: String) -> DescriptorStruct {
        
        var dict = [String:Any]()
        
        if descriptor.contains("[") && descriptor.contains("]") {
            
            let arr1 = descriptor.split(separator: "[")
            let arr2 = arr1[1].split(separator: "]")
            let derivation = arr2[0]
            let arr3 = derivation.split(separator: "/")
            var path = "m"
            
            for (i, item) in arr3.enumerated() {
                
                switch i {
                    
//                case 0:
//                    let fingerprint = item
                    
                case 1:
                    let type = item
                    path += "/" + type
                    
                default:
                    
                    path += "/" + item
                    
                }
                
            }
            
            switch path {
                
            case "m/44'/0'/0'":
                dict["isBIP44"] = true
                dict["isP2PKH"] = true
                
            case "m/84'/0'/0'":
                dict["isBIP84"] = true
                dict["isP2WPKH"] = true
                
            case "m/49'/0'/0'":
                dict["isBIP49"] = true
                dict["isP2SHP2WPKH"] = true
                
            default:
                
                break
                
            }
            
        }
        
        if descriptor.contains("multi") {
            
            dict["isMulti"] = true
            
            if descriptor.contains("sortedmulti") {
                
                dict["isBIP67"] = true
                
            }
            
            let arr = descriptor.split(separator: "(")
            
            for (i, item) in arr.enumerated() {
                
                if i == 0 {
                    
                    switch item {
                        
                    case "multi":
                        
                        dict["format"] = "Bare multi"
                        
                    case "wsh":
                        
                        dict["format"] = "P2WSH"
                        
                    case "sh":
                        
                        if arr[1] == "wsh" {
                            
                            dict["format"] = "P2SH - P2WSH"
                            
                        } else {
                            
                            dict["format"] = "P2SH"
                            
                        }
                        
                    default:
                        
                        break
                        
                    }
                    
                }
                
                switch item {
                    
                case "multi", "sortedmulti":
                    
                    let mofnarray = (arr[i + 1]).split(separator: ",")
                    let numberOfKeys = mofnarray.count - 1
                    dict["mOfNType"] = "\(mofnarray[0]) of \(numberOfKeys)"
                    
                default:
                    
                    break
                    
                }
                
            }
                        
        } else {
            
            if descriptor.contains("combo") {
                
                dict["format"] = "Combo"
                
            } else {
                
                let arr = descriptor.split(separator: "(")
                
                for (i, item) in arr.enumerated() {
                    
                    if i == 0 {
                        
                        switch item {
                            
                        case "wpkh":
                            
                            dict["format"] = "P2WPKH"
                            dict["isP2WPKH"] = true
                            
                        case "sh":
                            
                            if arr[1] == "wpkh" {
                                
                                dict["format"] = "P2SH-P2WPKH"
                                dict["isP2SHP2WPKH"] = true
                                
                            } else {
                                
                                dict["format"] = "P2SH"
                                
                            }
                            
                        case "pk":
                            
                            dict["format"] = "P2PK"
                            
                        case "pkh":
                            
                            dict["format"] = "P2PKH"
                            dict["isP2PKH"] = true
                            
                        default:
                            
                            break
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        if descriptor.contains("xpub") || descriptor.contains("xprv") {
            
            dict["chain"] = "Mainnet"
            
        } else if descriptor.contains("tpub") || descriptor.contains("tprv") {
            
            dict["chain"] = "Testnet"
            
        }
        
        if descriptor.contains("xprv") || descriptor.contains("tprv") {
            
            dict["isHot"] = true
            
        }
        
        return DescriptorStruct(dictionary: dict)
        
    }
    
}
