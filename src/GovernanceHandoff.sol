// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Proposal} from "currency-1.5/governance/community/proposals/Proposal.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
// import {TrustedNodes} from "currency-1.5/governance/monetary/TrustedNodes.sol";


contract GovernanceHandoff is Proposal {

    ECOx public constant ECOX = ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a);

    address public immutable governorMultisig; 

    constructor(address _multisig) { 
        governorMultisig = _multisig;
    }

    function name() public pure virtual override returns (string memory) {
        return "Governance Transition";
    }

    function description()
        public
        pure
        virtual
        override
        returns (string memory)
    {
        return
            "moves governance to a multisig, also removes ECOx mint/burn permissions from the policy contract";
    }

    /** A URL where more details can be found.
     */
    function url() public pure override returns (string memory) {
        return
            "";
    }

    function enacted(address _self) public virtual override{

        // Update the governor from CommunityGovernance contract to the multisig
        Policy(address(this)).updateGovernor(governorMultisig);

        // revoke mint and burn permissions from the policy contract
        ECOX.updateMinters(address(this), false);
        ECOX.updateBurners(address(this), false);
    }

}  