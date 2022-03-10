// SPDX-License-Identifier: MIT
// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol


// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/news.sol


pragma solidity 0.8;

// import "@openzeppelin/contracts/access/Ownable.sol";

// @ver: 1.0.2
// @new: tips
contract News is Ownable{
    uint256 ID = 1;
    struct Post{
        uint256 id;
        string hash;
        address auther;
    }
    mapping(uint256 => Post) public posts;
    mapping(address => uint) private userBalances;
    bool internal locked;

    modifier noReentrant() {
		require(!locked, "no re entrancy");
		locked = true;
		_;
		locked = false;
	}

    event Posted(
        uint256 indexed _id, 
        address indexed _auther , 
        string indexed _title, 
        string _link
    ); // _link = ipfs

    event Deposit(address indexed Depositor, uint amount);
    event Withdraw(uint256 date, uint amount);

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

    // tips section
    receive() external payable {}

    fallback() external payable {}

    function tips() external payable{
        emit Deposit(msg.sender, msg.value);
        userBalances[msg.sender] += msg.value;
    }

    function withdrawtips() external onlyOwner noReentrant {
		(bool success, ) = msg.sender.call{value: balanceOf()}("");
		require(success);
        emit Withdraw(block.timestamp, userBalances[msg.sender]);
        userBalances[msg.sender] = 0;
    }

    function balanceOf() view public returns(uint) {
        return address(this).balance;
    }
}

// example ipfs: QmVFs3Woj4YhwLHMG8XTYk9UJdRniZXxxcZthVQphSBH1H
// ver1.0.2 bsc testnet: https://testnet.bscscan.com/address/0x09ee14fa0e02e4479f64d7badb33f77c44081411#code
// donation (tips) tested, contract hold 100wei now

// todo: seprat logic, add user role, privacy for sender the post
