pragma solidity ^0.5.1;
import "./DAIToken.sol";
import "./CDPImpl.sol";
import './Ownable.sol';
import './CDPOracleInterface.sol';
import './CDPRules.sol';

contract CDPAuction is Ownable{
    constructor (address _daiAddr, address _oracleAddr, address _rulesAddr) public {
        _dai = DAIToken(_daiAddr);
        _oracle = CDPOracleInterface(_oracleAddr);
        _rules = CDPRules(_rulesAddr);
    }

    struct AuctionedCDP
    {
        uint256 DAICount;
        uint256 Course;
        bool Liquidated;
    }

    struct OpenedCDP
    {
        address cdpAddress;
        uint256 DAICount;
        bool isOpened;
    }

    OpenedCDP[] private _openedCDPs;
    uint256 private _openedCDPsCount;
    address[] public auctionedCDPsAddresses;
    mapping(address => AuctionedCDP) public auctionedCDPs;
    DAIToken private _dai;
    CDPOracleInterface private _oracle;
    CDPRules private _rules;

    function AddCDPToAudit(address _cdpAddr, uint256 _daiCount) onlyOwner external{
        _openedCDPs.push(OpenedCDP(_cdpAddr, _daiCount, false));
    }

    function audit() public{
        uint256 course = getCourse();
        for(uint i = 0; i < _openedCDPsCount; i++){
            CDPImpl cdp = CDPImpl(_openedCDPs[i].cdpAddress);
            if(cdp.getCourse() > getCourse() - getCourse()/getCoeff())
                auctionedCDPsAddresses.push(address(cdp));
                auctionedCDPs[address(cdp)] = AuctionedCDP(cdp.getDAICount(), cdp.getCourse(), false);
        }
    }

    function buyCDP(address _cdpAddr) public{
        require(!auctionedCDPs[_cdpAddr].Liquidated);
        CDPImpl cdp = CDPImpl(_cdpAddr);
        cdp.closeByAuction(msg.sender, getCourse());
    }

    function getCourse() private returns (uint256 course){
        return uint256 (_oracle.getDollarRate());
    }

     function getCoeff() private returns (uint256 course){
        return _rules.getCoeff();
    }
}