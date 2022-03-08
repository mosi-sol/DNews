// SPDX-License-Identifier: MIT
pragma solidity 0.8;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract News is Ownable{
    uint256 id = 1;
    mapping(address => uint) public auther;
    event Posted(
        uint256 indexed _id, 
        address indexed _auther, 
        string indexed _title, 
        string _link
        ); // _link = ipfs

    function postNew(string memory title, string memory link) public onlyOwner{
        emit Posted(id, msg.sender, title, _linkMaker(link));
        auther[msg.sender] = id;
        id += 1;
    }

    function _linkMaker(string memory _link) internal pure returns(string memory){
        string memory a = "ipfs://";
        return string(abi.encodePacked(a, _link));
    }
}
