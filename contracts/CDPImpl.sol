pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/Initializable.sol';
import './Ownable.sol';
import './DAIToken.sol';

contract CDPImpl is Initializable{
    function initialize (address payable _borrow, address _auctionAddr, uint256 _daiC, address _daiAddr) public {
        _borrower = _borrow;
        _daiCount = _daiC;
        _isOpened = false;
        _isClosed = false;
        _dai = DAIToken(_daiAddr);
        _auction = _auctionAddr;
    }

    address payable private _borrower;
    address private _auction;
    uint256 private _daiCount;
    bool private _isOpened;
    bool private _isClosed;
    uint256 private _deposit;
    uint256 private _course;
    uint256 private _coeff;
    DAIToken _dai;

    function open() public payable{
        require(!_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        _course = setCourse(_daiCount);
        _coeff = getCoeff();
        require(msg.value == _daiCount * _coeff/_course);
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
            _borrower.transfer(setCourse(_daiC));
             _dai.transferFrom(_borrower, address(this), _daiC);
            _daiCount = 0;
        }
    }

    function closeByAuction(address payable _buyer, uint256 _newCourse) public{
        require(_isOpened && !_isClosed);
        require(msg.sender == _auction);
        _dai.transferFrom(_buyer, address(this), _daiCount * _newCourse / _course);
        _dai.transferFrom(_borrower, address(this), _daiCount);
        _buyer.transfer(_deposit);
    }

    function setCourse(uint256 _daiC) private returns (uint256 course){
        //Not implemented
    }

    function getCourse() public returns (uint256 course){
        return _course;
    }

    function getDAICount() public returns (uint256 count){
        return _daiCount;
    }

    function getBorrower() public returns (address borrower){
        return _borrower;
    }

    function getDeposit() public returns (uint256 deposit){
        return _deposit;
    }

     function getCoeff() private returns (uint256 coeff){
        //Not implemented
    }
}