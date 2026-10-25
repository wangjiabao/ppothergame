const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { spawn } = require('node:child_process');
const RUNTIME = '/Users/wangjiabao/Documents/ms_token_v12_hardhat_all_contracts/hardhat_deploy_v12';
const solc = require(RUNTIME + '/node_modules/solc');
const ethers = require(RUNTIME + '/node_modules/ethers');
const ROOT = __dirname;
const ORIGINAL = '/Users/wangjiabao/Documents/ispay-token-review-20261004/bsc-release-no-minimum-20261004';
function compile(input) {
  const output = JSON.parse(solc.compile(JSON.stringify(input)));
  const errors = (output.errors || []).filter(x => x.severity === 'error');
  assert.equal(errors.length, 0, errors.map(x => x.formattedMessage).join('\n'));
  return output;
}
function save(name, data) { fs.writeFileSync(path.join(ROOT, name), JSON.stringify(data, null, 2) + '\n'); }
const mockSource = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract SplitTestToken {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public reject;
    bool public rejectWithFalse;
    address public reenter;
    constructor() { balanceOf[msg.sender] = type(uint256).max; }
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value; return true;
    }
    function setReject(address recipient, bool returnFalse) external { reject = recipient; rejectWithFalse = returnFalse; }
    function setReenter(address target) external { reenter = target; }
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        if (to == reject) { if (rejectWithFalse) return false; revert("blocked"); }
        if (reenter != address(0)) {
            (bool ok,) = reenter.call(abi.encodeWithSignature("buy(uint256)", 0));
            require(!ok, "reentry succeeded");
        }
        require(allowance[from][msg.sender] >= value, "allowance");
        require(balanceOf[from] >= value, "balance");
        allowance[from][msg.sender] -= value;
        balanceOf[from] -= value;
        balanceOf[to] += value;
        return true;
    }
}`;
async function main() {
  const input = JSON.parse(fs.readFileSync(path.join(ROOT, 'standard-input.json')));
  assert.equal(input.sources['contracts/BuyBurn.sol'].content, fs.readFileSync(path.join(ROOT, 'BuyBurn.sol'), 'utf8'));
  const oldInput = JSON.parse(fs.readFileSync(path.join(ORIGINAL, 'BuyBurn.standard-input.json')));
  assert.deepEqual(input.settings, oldInput.settings);
  for (const name of Object.keys(oldInput.sources)) if (name !== 'contracts/BuyBurn.sol') {
    assert.deepEqual(input.sources[name], oldInput.sources[name]);
  }
  const originalSource = oldInput.sources['contracts/BuyBurn.sol'].content;
  const block = /        require\(IERC20\(usdt\)\.transferFrom\([\s\S]*?        \), "transfer failed"\);/g;
  assert.equal(originalSource.replace(block, '').replace(/\s+/g, ''), input.sources['contracts/BuyBurn.sol'].content.replace(block, '').replace(/\s+/g, ''));
  const compiled = compile(input).contracts['contracts/BuyBurn.sol'].BuyBurn;
  const original = JSON.parse(fs.readFileSync(path.join(ORIGINAL, 'BuyBurn.compiled.json')));
  assert.deepEqual(compiled.abi, original.abi);
  save('artifact.json', { compiler: solc.version(), sourceName: 'contracts/BuyBurn.sol', contractName: 'BuyBurn', ...compiled });
  save('abi.json', compiled.abi);
  fs.writeFileSync(path.join(ROOT, 'metadata.json'), compiled.metadata + '\n');
  const testInput = structuredClone(input);
  testInput.sources['test/SplitTestToken.sol'] = { content: mockSource };
  const mock = compile(testInput).contracts['test/SplitTestToken.sol'].SplitTestToken;
  const port = 18645;
  const child = spawn(process.execPath, [RUNTIME + '/node_modules/hardhat/internal/cli/cli.js', 'node', '--hostname', '127.0.0.1', '--port', String(port), '--config', path.join(ROOT, 'hardhat.test.config.cjs')], { cwd: RUNTIME, stdio: 'ignore' });
  const p = new ethers.JsonRpcProvider('http://127.0.0.1:' + port, undefined, { batchMaxCount: 1, cacheTimeout: -1 });
  p.pollingInterval = 50;
  const results = [];
  try {
    for (let i = 0; i < 100; i++) {
      try { assert.equal(Number(await p.send('eth_chainId', [])), 31337); break; }
      catch { if (i === 99) throw Error('Local test chain did not start'); await new Promise(r => setTimeout(r, 100)); }
    }
    const signer = await p.getSigner(0);
    const sender = await signer.getAddress();
    const tf = new ethers.ContractFactory(mock.abi, '0x' + mock.evm.bytecode.object, signer);
    const token = await tf.deploy(); await token.waitForDeployment();
    const bf = new ethers.ContractFactory(compiled.abi, '0x' + compiled.evm.bytecode.object, signer);
    const burn = await bf.deploy(await token.getAddress()); await burn.waitForDeployment();
    const contract = await burn.getAddress();
    assert.equal(await burn.usdt(), await token.getAddress());
    assert.equal(await burn.getUserLength(), 0n);
    await (await token.approve(contract, ethers.MaxUint256)).wait();
    const initial = await p.send('evm_snapshot', []);
    const recipients = JSON.parse(fs.readFileSync(path.join(ROOT, 'recipients.json'))).recipients;
    const unit = 10n ** 15n;
    const balances = async () => Promise.all([token.balanceOf(sender), ...recipients.map(x => token.balanceOf(x.address))]);
    const success = async (num, name) => {
      const before = await balances(), count = await burn.getUserLength();
      await (await burn.buy(num)).wait();
      const after = await balances(), amount = num * unit;
      assert.equal(before[0] - after[0], amount);
      for (let i = 0; i < recipients.length; i++) assert.equal(after[i+1] - before[i+1], amount / 10000n * BigInt(recipients[i].parts));
      assert.equal(after.slice(1).reduce((a,v,i) => a + v - before[i+1], 0n), amount);
      assert.equal(await burn.getUserLength(), count + 1n);
      assert.equal(await burn.users(count), sender);
      assert.equal(await burn.usersAmount(count), num);
      results.push({ name, passed: true });
    };
    const fail = async (num, name) => {
      const before = await balances(), count = await burn.getUserLength(), allowance = await token.allowance(sender, contract);
      let reverted = false;
      try { const tx = await burn.buy(num, { gasLimit: 2000000 }); await tx.wait(); } catch { reverted = true; }
      assert.equal(reverted, true);
      assert.deepEqual(await balances(), before);
      assert.equal(await burn.getUserLength(), count);
      assert.equal(await token.allowance(sender, contract), allowance);
      results.push({ name, passed: true });
    };
    await success(1n, '0.001 ISPAY splits exactly, no rounding loss');
    await success(1000n, '1 ISPAY: 0.95 / 0.0075 / 0.01 / 0.0225 / 0.01');
    await success(1234n, 'Fractional input: 1.234 ISPAY');
    await success(100000n, '100 ISPAY and repeated same-user records');
    await success(0n, 'Zero input remains accepted with this token, as original contract');
    const addresses = await burn.getUsersByIndex(0, 4), amounts = await burn.getUsersAmountByIndex(0, 4);
    assert.deepEqual([...addresses], Array(5).fill(sender));
    assert.deepEqual([...amounts], [1n,1000n,1234n,100000n,0n]);
    assert.deepEqual([...(await burn.getUsers())], [...addresses]);
    results.push({ name: 'Existing scanner getters and record order preserved', passed: true });
    for (const i of [1,4]) {
      await (await token.setReject(recipients[i].address, true)).wait();
      await fail(1000n, 'Recipient ' + (i+1) + ' returns false: all transfers and records roll back');
    }
    await (await token.setReject(recipients[4].address, false)).wait();
    await fail(1000n, 'Fifth transfer reverts: entire operation rolls back');
    await (await token.setReject(ethers.ZeroAddress, false)).wait();
    await (await token.approve(contract, unit * 999n)).wait();
    await fail(1000n, 'Insufficient total allowance: earlier transfers roll back');
    await (await token.approve(contract, ethers.MaxUint256)).wait();
    await (await token.setReenter(contract)).wait();
    await success(1000n, 'Reentrancy guard blocks nested buy');
    await p.send('evm_revert', [initial]);
    const maximum = ethers.MaxUint256 / unit;
    await success(maximum, 'Largest original valid num: no additional split arithmetic overflow');
    await fail(maximum + 1n, 'Original amount multiplication overflow remains rejected');
    results.push({ name: 'Original ABI, constructor and all non-transfer source preserved', passed: true });
    save('local-validation.json', { passed: true, network: 'local mock chain 31337', production_transactions: 0, compiler: solc.version(), source_sha256: require('node:crypto').createHash('sha256').update(fs.readFileSync(path.join(ROOT,'BuyBurn.sol'))).digest('hex'), results });
    console.log(JSON.stringify({ passed: true, checks: results.length, runtimeBytes: compiled.evm.deployedBytecode.object.length / 2, results }, null, 2));
  } finally { p.destroy(); child.kill('SIGTERM'); }
}
main().catch(e => { console.error(e.message); process.exitCode = 1; });
