pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/Initializable.sol';
import './Ownable.sol';
import './DAIToken.sol';

contract CDPImpl is Initializable{
    function initialize (address payable _borrow, uint256 _daiC, address _daiAddr) public {
        _borrower = _borrow;
        _daiCount = _daiC;
        _isOpened = false;
        _isClosed = false;
        _dai = DAIToken(_daiAddr);
    }

    address payable private _borrower;
    uint256 private _daiCount;
    bool private _isOpened;
    bool private _isClosed;
    uint256 private _deposit;
    uint256 private _fiat;
    DAIToken _dai;

    function open() public payable{
        require(!_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        _fiat = getCourse(_daiCount);
        require(msg.value == _fiat);
        _isOpened = true;
        _deposit = msg.value;
        _dai.transfer(_borrower, _daiCount);
    }

      function close(uint256 _daiC) public{
        require(_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        require(_daiC <= _daiCount);
        if(_daiC < _daiCount){
            _dai.transferFrom(_borrower, address(this), _daiC);
            _daiCount -= _daiC;
        }
        else
        {
            _isOpened = false;
            _isClosed = true;
            _borrower.transfer(getCourse(_daiC));
            _daiCount = 0;
        }
    }

    function getCourse(uint256 _daiC) private returns (uint256 course){
        //Not implemented
    }
}