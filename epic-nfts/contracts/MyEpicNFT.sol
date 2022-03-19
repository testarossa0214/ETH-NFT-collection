// SPDX-License-Identifier: UNLICENSED
// solidityのバージョンを指定
pragma solidity ^0.8.4; 
// いくつかの OpenZeppelin のコントラクトをインポート
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// contract MyEpicNFT {
//     constructor() {
//         console.log("This is my NFT contract.");
//     }
// }

// インポートした OpenZeppelin のコントラクトを継承
// 継承したコントラクトのメソッドにアクセスできるようになる
contract MyEpicNFT is ERC721URIStorage{


}



