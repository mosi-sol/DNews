// SPDX-License-Identifier: MIT
pragma solidity 0.8;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract News is Ownable{
    uint256 ID = 1;
    struct Post{
        uint256 id;
        string hash;
        address auther;
    }
    mapping(uint256 => Post) public posts;

    event Posted(
        uint256 indexed _id, 
        address indexed _auther, 
        string indexed _title, 
        string _link
        ); // _link = ipfs

    function postNew(string memory title, string memory link) public onlyOwner{
        emit Posted(ID, msg.sender, title, _linkMaker(link));
        Post storage p = posts[ID];
        p.id = ID;
        p.auther = msg.sender;
        p.hash = _linkMaker(link);
        ID += 1;
    }

    function getPost(uint256 _id) public view returns (address _auther, string memory _link) {
        _auther = posts[_id].auther;
        _link = posts[_id].hash;
    }

    function _linkMaker(string memory _link) internal pure returns(string memory){
        string memory a = "ipfs://";
        return string(abi.encodePacked(a, _link));
    }
}

// example ipfs: QmVFs3Woj4YhwLHMG8XTYk9UJdRniZXxxcZthVQphSBH1H
// ver2 bsc testnet: 0x0Ad86d2184d6f9e8BB7566A7BE1fAdAa08cdc725
