pragma solidity ^0.5.1;
import '@openzeppelin/upgrades/contracts/Initializable.sol';
import './Ownable.sol';
import './DAIToken.sol';
import './CDPOracleInterface.sol';
import './CDPRules.sol';

contract CDPImpl is Initializable{
     constructor (address _borrow, address _auctionAddr, address _daiAddr, address _oracleAddr, address _rulesAddr, uint256 _daiC) public {
        _borrower = _borrow;
        _daiCount = _daiC;
        _isOpened = false;
        _isClosed = false;
        _dai = DAIToken(_daiAddr);
        _auction = _auctionAddr;
        _oracle = CDPOracleInterface(_oracleAddr);
        _rules = CDPRules(_rulesAddr);
        _deposit = (1 + 1/getCoeff()) * _daiCount / getCourse();
    }

    address private _borrower;
    address private _auction;
    uint256 private _daiCount;
    bool private _isOpened;
    bool private _isClosed;
    uint256 private _deposit;
    uint256 private _course;
    uint256 private _coeff;
    DAIToken _dai;
    CDPOracleInterface _oracle;
    CDPRules _rules;

    function open() public payable{
        require(!_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        require(msg.value == _deposit);
        _dai.transfer(_borrower, _daiCount);
    }

    function close(uint256 _daiC) public{
        require(_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        require(_daiC == _daiCount);
        if(_daiC < _daiCount){
            _dai.transferFrom(_borrower, address(this), _daiC);
            _daiCount -= _daiC;
        }
        _isOpened = false;
        _isClosed = true;
       // _borrower.transfer(setCourse(_daiC));
        _dai.transferFrom(_borrower, address(this), _daiC);
        _daiCount = 0;
    }

    function closePartly(uint256 _daiC) public{
        require(_isOpened && !_isClosed);
        require(msg.sender == _borrower);
        require(_daiC < _daiCount);
        _dai.transferFrom(_borrower, address(this), _daiC);
        _daiCount -= _daiC;
    }

    function closeByAuction(address payable _buyer, uint256 _daiC) public{
        require(_isOpened && !_isClosed);
        require(msg.sender == _auction);
        require(_daiC < _daiCount);
        _dai.transferFrom(_buyer, address(this), _daiC);
        _buyer.transfer(_deposit);
        _isOpened = false;
        _isClosed = true;
    }

    function setCourse(uint256 _daiC) private returns (uint256 course){
        return uint256 (_oracle.getDollarRate());
    }

    function getCourse() public view returns (uint256 course){
        return _course;
    }

    function getDAICount() public view returns (uint256 count){
        return _daiCount;
    }

    function getBorrower() public view returns (address borrower){
        return _borrower;
    }

    function getDeposit() public view returns (uint256 deposit){
        return _deposit;
    }

     function getCoeff() private returns (uint256 coeff){
        return _rules.getCoeff();
    }
}