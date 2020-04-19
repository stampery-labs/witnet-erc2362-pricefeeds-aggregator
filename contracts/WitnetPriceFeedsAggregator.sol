pragma solidity 0.6.6;

import "adomedianizer/contracts/IERC2362.sol";


/**
* @title Exposes several Witnet-powered price feeds through a unified, standard ERC-2362 compliant interface
**/
contract WitnetPriceFeedsAggregator is IERC2362 {

  address public owner;
  mapping(bytes32 => address) public feeds;

  /**
  * @notice Constructs the contract by initializing its owner to the address of the account that is deploying it.
  */
  constructor () public {
    owner = msg.sender;
  }

  /**
  * @notice Simple modifier for guarding some function from being called by someone different than the deployer of this
  * contract.
  **/
  modifier onlyOwner() {
    require(msg.sender == owner, "This method can only be called by the contract owner");
    _;
  }

  /**
  * @notice Queries a price feed contract for the latest value. Note that we can only query feeds that has been
  * previously registered through the `registerFeed` function.
  * @param _id An ERC-2362 compliant data point ID.
  * @return value, timestamp and status, as provided for by ERC-2362.
  **/
  function valueFor(bytes32 _id) external view override returns(int256, uint256, uint256) {
    address feed = feeds[_id];
    require(feed != address(0), "Unsupported feed ID");

    return IERC2362(feed).valueFor(_id);
  }

  /**
  * @notice Registers a new price feed. This method also doubles as an updater in case we want to replace the address
  * of the contract providing a data point, as identified by its ERC-2362 data point ID.
  * @param _id An ERC-2362 compliant data point ID.
  * @param _address The address the ERC-2362 compliant contract that will provide the data.
  **/
  function registerFeed(bytes32 _id, address _address) external onlyOwner() {
    feeds[_id] = _address;
  }

  /**
  * @notice Unregisters a existing price feed, as identified by its ERC-2362 data point ID.
  * @param _id An ERC-2362 compliant data point ID.
  **/
  function unregisterFeed(bytes32 _id) external onlyOwner() {
    address feed = feeds[_id];
    require(feed != address(0), "Tried to unregister a feed ID that was not registered");
    delete feeds[_id];
  }

  /**
  * @notice Enables the owner of this contract to transfer ownership to another account, or eventually freezing the list
  * of supported feeds by setting the owner to a provably non-existing address like `address(0)`.
  * @param _newOwner The address of the new owner.
  **/
  function transferOwnership(address _newOwner) external onlyOwner() {
    owner = _newOwner;
  }

}
