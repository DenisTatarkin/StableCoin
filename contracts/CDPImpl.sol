pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/Initializable.sol';
import './Ownable.sol';
import './DAIToken.sol';

contract CDPImpl is Initializable{
    function initialize (address payable _borrow, uint32 _daiC, address _daiAddr) public {
        _borrower = _borrow;
        _daiCount = _daiC;
        _isOpened = false;
        _isClosed = false;
        _dai = DAIToken(_daiAddr);
    }

    address payable private _borrower;
    uint32 private _daiCount;
    bool private _isOpened;
    bool private _isClosed;
    uint256 private _deposit;
    DAIToken _dai;

    function open() public payable{
        require(!_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        require(msg.value == getCourse(_daiCount));
        _isOpened = true;
        _deposit = msg.value;
        _dai.transfer(_borrower, _daiCount);
    }

      function close() public{
        require(_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        _isOpened = false;
        _isClosed = true;
        _dai.transferFrom(_borrower, address(this), _daiCount);
        _borrower.transfer(getCourse(_daiCount));
    }

    function getCourse(uint256 _daiC) private returns (uint256 course){
        //Not implemented
    }
}