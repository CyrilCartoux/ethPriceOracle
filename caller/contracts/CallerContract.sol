// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./EthPriceOracleInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CallerContract is Ownable {
    EthPriceOracleInterface private oracleInstance;
    address private oracleAddress;
    uint256 private ethPrice;
    event newOracleAddressEvent(address oracleAddress);
    event ReceivedNewRequestIdEvent(uint256 id);
    event PriceUpdatedEvent(uint256 ethPrice, uint256 id);
    mapping(uint256 => bool) myRequests;

    /** Allow the owner to update the oracle address */
    function setOracleInstanceAddress(address _oracleInstanceAddress)
        public
        onlyOwner
    {
        /** Update oracle address */
        oracleAddress = _oracleInstanceAddress;
        oracleInstance = EthPriceOracleInterface(oracleAddress);
        /** Emit event */
        emit newOracleAddressEvent(oracleAddress);
    }

    /** 
        Requests the latest ETH price from oracle contract
        Receives computed requestId
        Called by Client.js every x seconds 
    */
    function updateEthPrice() public {
        uint256 id = oracleInstance.getLatestEthPrice();
        myRequests[id] = true;
        emit ReceivedNewRequestIdEvent(id);
    }

    /**
        Validates the response, update ETH price 
     */
    function callback(uint256 _ethPrice, uint256 _id) public onlyOracle {
        require(myRequests[_id], "This request is not in my pending list.");
        ethPrice = _ethPrice;
        delete myRequests[_id];
        emit PriceUpdatedEvent(_ethPrice, _id);
    }

    modifier onlyOracle() {
        require(msg.sender == oracleAddress,"You are not authorized to call this function.");
        _;
    }
}
