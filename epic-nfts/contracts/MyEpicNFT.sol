// SPDX-License-Identifier: UNLICENSED
// solidityのバージョンを指定
pragma solidity ^0.8.4;
// いくつかの OpenZeppelin のコントラクトをインポート
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// utils ライブラリをインポートして文字列の処理を行う
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

// Base64.solコントラクトからSVGとJSONをBase64に変換する関数をインポート
import { Base64 } from "./libraries/Base64.sol";

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

	// SVGコードを作成
	// 変更されるのは表示される単語だけです
	// すべてのNFTにSVGコードを適用するために、baseSvg変数を作成します
	string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
	// string baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: Super Sans; font-size: 40px; font-weight: bold;}</style><rect width='100%' height='100%' ";
	// string baseSvg2 = "<text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

	// 3つの配列 string[]に、それぞれランダムな単語を設定
	string[] firstWords = ["4 ", "8 ", "9 ", "10 ", "14 "];
	string[] secondWords = ["tachibana ", "hiiragi ", "hige dandy ", "captain dairi ", "captain "];
	string[] thirdWords = ["kouzu", "ninomiya", "rokkakubashi", "hiratsuka", "samukawa"];

	// NFT トークンの名前とそのシンボルを渡す
	// constructor() ERC721 ("TanyaNFT", "TANYA") {
	constructor() ERC721 ("SquareNFT", "SQUARE") {
		console.log("This is my NFT contract.");
	}

	// シードを生成する関数を作成
	function random(string memory input) internal pure returns (uint256) {
		return uint256(keccak256(abi.encodePacked(input)));
	}

	// 各配列からランダムに単語を選ぶ関数を3つ作成する
	// pickRandomFirstWord関数は、最初の単語を選ぶ
	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {

		// pickRandomFirstWord 関数のシードとなる rand を作成
		uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
		rand = rand % firstWords.length;

		// seed rand をターミナルに出力する
		console.log("rand seed: ", rand);

		// firstWords配列から何番目の単語が選ばれるかターミナルに出力
		console.log("rand first word: ", rand);
		return firstWords[rand];
	}

	// pickRandomSecondWord関数は、2番目に表示される単語を選ぶ
	function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {

		// pickRandomSecondWord 関数のシードとなるrandを作成
		uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
		rand = rand % secondWords.length;
		return secondWords[rand];
	}

	// pickRandomThirdWord関数は、3番目に表示される単語を選ぶ
	function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
		
		// pickRandomThirdWord関数のシードとなるrandを作成
		uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
		rand = rand % thirdWords.length;
		return thirdWords[rand];
	}

    function setLineBreak(string memory word) public view returns (string memory) {
        string memory lineBreakStart;
        string memory lineBreaked;
        string memory lineBreakEnd;
        
        lineBreakStart = '<text><tspan x = "0" dy="1.0em">';
        lineBreakEnd = '</tspan></text>';
        lineBreaked = string(abi.encodePacked(lineBreakStart, word, lineBreakEnd));
        return lineBreaked;
    }

	// ユーザーが NFT を取得するために実行する関数
	function makeAnEpicNFT() public {
		
		// 現在のtokenIdを取得 tokenIdは0から始まる
		uint256 newItemId = _tokenIds.current();

		// 3つの配列からそれぞれ1つの単語をランダムに取り出す
		// string memory first = pickRandomFirstWord(newItemId);
		// string memory second = pickRandomSecondWord(newItemId);
		// string memory third = pickRandomThirdWord(newItemId);
		string memory first = setLineBreak(pickRandomFirstWord(newItemId));
        string memory second = setLineBreak(pickRandomSecondWord(newItemId));
        string memory third = setLineBreak(pickRandomThirdWord(newItemId));

		// 3つの単語を連結して格納する変数 combinedWord を定義
		string memory combinedWord = string(abi.encodePacked(first, second, third));

		// 3つの単語を連結して、<text>タグと<svg>タグを閉じる
		string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
		// string memory finalSvg = string(abi.encodePacked(baseSvg1,"fill='", rcol, "' />",baseSvg2, "<tspan x='"''"' dy='"'-50'"'>",first,"</tspan></text>",baseSvg2, second,"</text>",baseSvg2, "<tspan x='"''"' dy='"'50'"'>", third, "</tspan></text></svg>"));

		// NFTに出力されるテキストをターミナルに出力
		console.log("\n----- SVG data -----");
		console.log(finalSvg);
		console.log("--------------------\n");

		// jsonファイルを所定の位置に取得し、base64としてエンコード
		string memory json = Base64.encode(
			bytes(
				string(
					abi.encodePacked(
						'{"name": "',
						// NFTのタイトルを生成される言葉（例；GrandCuteBird）に設定
						combinedWord,
						'", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
						// data:image/svg+xml;base64 を追加し、SVGをbase64 でエンコードした結果を追加
						Base64.encode(bytes(finalSvg)),
						'"}'
					)
				)
			)
		);

		// データの銭湯に data:application/json;base64 を追加する
		string memory finalTokenUri = string(
			abi.encodePacked("data:application/json;base64,", json)
		);

		console.log("\n----- Token URI ----");
		console.log(finalTokenUri);
		console.log("--------------------\n");

		// msg.sender を使って NFT を送信者に Mint する
		_safeMint(msg.sender, newItemId);

		// NFT データを設定します
		// _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY05mdENyZWF0b3IiLAogICAgImRlc2NyaXB0aW9uIjogIlRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTA1bWRFTnlaV0YwYjNJOEwzUmxlSFErQ2p3dmMzWm5QZz09Igp9");

		// tokenURI は後で設定
		// 今はtokenURIの代わりに"We will set tokenURI later"を設定
		// _setTokenURI(newItemId, "We will set tokenURI later.");

		// tokenURIを更新
		_setTokenURI(newItemId, finalTokenUri);

		// NFTがいつ誰に作成されたかを確認します
		console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

		// 次のNFTが Mintされるときのカウンターをインクリメントする
		_tokenIds.increment();
	}
}