import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";

contract TrusteePayout is Proposal {
    
    address[] public recipients;

    uint256[] public payouts;

    uint256 public immutable voteReward = 9615000000000000000000;

    ECOx public immutable ecox; 
    
    address public immutable trustedNodes;

    constructor(
        address[] memory _recipients,
        uint256[] memory _payouts,
        ECOx _ecox,
        address _trustedNodes
        ) {
        recipients = _recipients;
        payouts = _payouts;
        ecox = _ecox;
        trustedNodes = _trustedNodes;
    }

    function name() public pure virtual override returns (string memory) {
        return "Trustee Payout Proposal";
    }

    function description()
        public
        pure
        virtual
        override
        returns (string memory)
    {
        return
            "Pays out Trustees for their first term due to a smart contract bug";
    }

    /** A URL where more details can be found.
     */
    function url() public pure override returns (string memory) {
        return
            "Please see the forum for more information on this proposal";
    }

    function enacted(address _self) public virtual override{

        // Add the contract to the minter and burner list   
        ecox.updateMinters(address(this), true);
        ecox.updateBurners(address(this), true);

        // Query the balance of the TrustedNodes contract
        uint256 balance = ecox.balanceOf(trustedNodes);

        // Burn the balance of the TrustedNodes contract
        ecox.burn(trustedNodes, balance);

        // Mint the balance of the TrustedNodes contract to root policy
        ecox.mint(address(this), balance);

        for (uint256 i = 0; i < recipients.length; i++) {
            ecox.transfer(recipients[i], payouts[i]);
        }
        ecox.transfer(trustedNodes, voteReward);
    }

}  
