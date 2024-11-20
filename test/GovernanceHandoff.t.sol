import {Test} from "forge-std/Test.sol";
import {ECOx} from "currency-1.5/currency/ECOx.sol";
import {Policy} from "currency-1.5/policy/Policy.sol";
import {TrustedNodes} from "currency-1.5/governance/monetary/TrustedNodes.sol";
import "./../src/GovernanceHandoff.sol";
import "forge-std/console.sol";

contract ForkTest is Test {
 
    uint256 mainnetFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address constant communityGovernance = 0x039F39846C6F9911993809C7488eF4502208cE4B;

    ECOx ecox = ECOx(0xcccD1Ba9f7acD6117834E0D28F25645dECb1736a);

    Policy policy = Policy(0x8c02D4cc62F79AcEB652321a9f8988c0f6E71E68);

    GovernanceHandoff proposal;

    function setUp() public {
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL);
    }

    function testCanPass() public {
        // check that the active fork is mainnet
        assertEq(vm.activeFork(), mainnetFork);

        // check that policy is minter or burner
        assertTrue(ecox.minters(address(policy)));
        assertTrue(ecox.burners(address(policy)));

        // check that governor is communityGovernance
        assertTrue(policy.governor() == communityGovernance);

        address newGovernor = makeAddr('newGovernor');

        // create the proposal
        proposal = new GovernanceHandoff(newGovernor);

        // enact the proposal
        vm.prank(communityGovernance);
        policy.enact(address(proposal));
    
       // check that policy is no longer minter burner
        assertFalse(ecox.minters(address(policy)));
        assertFalse(ecox.burners(address(policy)));

        // check that governor is newGovernor
        assertTrue(policy.governor() == newGovernor);

        // does this new governor have the power?
        address proveCanGovern = makeAddr('proveCanGovern');
        proposal = new GovernanceHandoff(proveCanGovern);
        vm.prank(newGovernor);
        policy.enact(address(proposal));

        assertTrue(policy.governor() == proveCanGovern);
    }
}
