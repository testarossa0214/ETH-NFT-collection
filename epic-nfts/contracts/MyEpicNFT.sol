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
contract MyEpicNFT is ERC721URIStorage {

	// OpenZeppelin が tokenIds を簡単に追跡するために提供するライブラリを呼び出してる
	using Counters for Counters.Counter;

	// _tokenIdsを初期化(_tokenIds = 0)
	Counters.Counter private _tokenIds;

	// NFT トークンの名前とそのシンボルを渡す
	constructor() ERC721 ("TanyaNFT", "TANYA") {
		console.log("This is my NFT contract.");
	}

	// ユーザーが NFT を取得するために実行する関数
	function makeAnEpicNFT() public {
		
		// 現在のtokenIdを取得 tokenIdは0から始まる
		uint256 newItemId = _tokenIds.current();

		// msg.sender を使って NFT を送信者に Mint する
		_safeMint(msg.sender, newItemId);

		// NFT データを設定します
		_setTokenURI(newItemId, "Valuable data!");

		// NFTがいつ誰に作成されたかを確認します
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

		// 次のNFTが Mintされるときのカウンターをインクリメントする
		_tokenIds.increment();
	}
}



