pragma solidity ^0.5.1;
import "./DAIToken.sol";
import "./CDPImpl.sol";
import './Ownable.sol';

contract CDPAuction is Ownable{
    constructor (address _daiAddr) public {
        _dai = DAIToken(_daiAddr);
    }

    struct AuctionedCDP
    {
        uint256 DAICount;
        uint256 Course;
        bool Liquidated;
    }

    address[] private _openedCDPs;
    uint256 private _openedCDPsCount;
    address[] public auctionedCDPsAddresses;
    mapping(address => AuctionedCDP) public auctionedCDPs;
    DAIToken private _dai;

    function AddCDPToAudit(address _cdpAddr) onlyOwner external{
        _openedCDPs.push(_cdpAddr);
    }

    function audit() public{
        uint256 course = getCourse();
        for(uint i = 0; i < _openedCDPsCount; i++){
            CDPImpl cdp = CDPImpl(_openedCDPs[i]);
            if(cdp.getCourse() > 25 * getCourse() / 100)
                auctionedCDPsAddresses.push(address(cdp));
                auctionedCDPs[address(cdp)] = AuctionedCDP(cdp.getDAICount(), cdp.getCourse(), false);
        }
    }

    function buyCDP(address _cdpAddr) public{
        require(!auctionedCDPs[_cdpAddr].Liquidated);
        CDPImpl cdp = CDPImpl(_cdpAddr);
        cdp.closeByAuction(msg.sender, getCourse());
    }

    function getCourse() private returns (uint256){
        //not implemented
    }

}