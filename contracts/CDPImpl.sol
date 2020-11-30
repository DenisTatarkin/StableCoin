pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/Initializable.sol';
import './Ownable.sol';
import './DAIToken'; // Not implemented

contract CDPImpl is Initializable{
    function initialize (address _borrow, uint32 _daiC) public {
        _borrower = _borrow;
        _daiCount = _daiC;
        _isOpened = false;
        _isClosed = false;
    }

    address private _borrower;
    uint32 private _daiCount;
    bool private _isOpened;
    bool private _isClosed;

    function open() public payable{
        require(!_isOpened && !_isColesd);
        //Not implemented
    }

    function close() public{
        //Not implemented
    }
}