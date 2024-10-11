import {Test} from "forge-std/Test.sol";


contract ForkTest is Test {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    Utilities internal utils;
    uint256 mainnetFork;

    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    // create two _different_ forks during setup
    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);

    }

    // select a specific fork
    function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        // from here on data is fetched from the `mainnetFork` if the EVM requests it and written to the storage of `mainnetFork`
    }

}