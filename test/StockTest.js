const BN = web3.utils.BN ;
const truffleAssert = require('truffle-assertions');
const { assert } = require('chai');
const StockExchange = artifacts.require('StockExchange');
require("chai").use(require("chai-bignumber")(BN))
.should();

const ans="true";

contract('StockExchange',() => {
        it('Should deploy smart contract properly',async() =>{
        const stock = await StockExchange.deployed();
        console.log(stock.address);
        assert(stock.address !== '');
    });

    beforeEach(async function(){
        stock= await StockExchange.new();
      
      });
    describe("[Testcase 1: To add the asset]",() =>{
        it("Register the asset",async() => {
          assert.isTrue(await( stock.registerAsset.call("ARWEN",200,15)));
        
        });
    });


    describe("[Testcase 2: To perform the transaction when the assets are registered]",() =>{
        it("transaction from ",async() => {
          await(stock.registerAsset("RIPPLE",100,12));
          await(stock.registerAsset("CLOUDM",150,18));
          assert.isTrue(await( stock.transaction.call("RIPPLE","CLOUDM",8)));
        
        });
    });

    describe("[Testcase 3: To perform the transaction when one of the assets are  not registered/ non-existent assets]",() =>{
        it("transaction from ",async() => {
          await(stock.registerAsset("RIPPLE",100,12));
          assert.isTrue(await( stock.transaction.call("RIPPLE","TREMS",8)));//transaction will get reverted as target asset is not registered
        
        });
    });

    describe("[Testcase 4: To check when the quantity is not valid ",() =>{
        it("transaction from ",async() => {
          await(stock.registerAsset("INFURA",200,12));
          await(stock.registerAsset("TREMS",150,7));
          assert.isTrue(await( stock.transaction.call("INFURA","TREMS",10)));//transaction will be unsuccessful and returns false
        
        });

    });
    describe("[Testcase 5: To re-register the existing asset ",() =>{
        it("Register Asset ",async() => {
          await(stock.registerAsset("INFURA",50,7));
          assert.isTrue(await(stock.registerAsset("INFURA",50,7)));//Gets reverted as the Asset already exists
        });
        
    });
});
