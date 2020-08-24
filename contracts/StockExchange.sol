pragma solidity ^0.6.0;


contract StockExchange{
    
    struct Asset{
        address asset_owner;
        string asset_id;
        int256 asset_price;
        int256 asset_quantity;
    }
    
    struct Transaction{
        int256 transaction_id;
        string source;
        string target;
        uint256 timestamp;
        int256 quantity ;
        int256 price;
        int256 transaction_state;//0:Failed 1:Successful
    }
    
    
    mapping(int => Transaction)transactions;
    
    mapping (int => Asset)assets;
    mapping (string => int)assetstore;
    int assetcount;
    int transcount;
    
    event error(string);
    event TransactionLog(string);
    

    //To retrieve the index of asset
    function getAssetIndex(string memory _asset)public view  returns(int)
    {
        
            int i=assetstore[_asset];
            if(keccak256(abi.encodePacked(assets[i].asset_id))==keccak256(abi.encodePacked(_asset)))
            {
                return i; 
            }
            else{
                return -1;
            }
            
        
    }
    
    // To register/add asset 
    function registerAsset(string memory _id,int256 _price,int256 _quantity)public  payable  returns(bool)
    {
        if(getAssetIndex(_id)>=0)
        {
            emit error("Asset already exists");
            revert();
        }
        
        else{
            
        assets[assetcount]=Asset(msg.sender,_id,_price,_quantity);
        assetstore[_id]=assetcount;
        assetcount++;
        return true;
        }
        
    }
    
    
    //To retrieve the asset details
     function getAsset(string memory _asset)public view  returns(address,int256,int256)
    {
                int i=getAssetIndex(_asset);
                if(i>=0)
                {
                     return(assets[i].asset_owner,assets[i].asset_quantity,assets[i].asset_price);
                }
               
     
    }
    
    function transaction(string memory _source, string memory _target,int256 _quantity)public payable returns(bool)
    {
        int sid=getAssetIndex(_source);
        int  tid=getAssetIndex(_target);
       if(sid == -1 || tid == -1)
       {
           emit error("Target or Source asset does not exists");
           revert();
          
       }
       else{
           
        
           if((assets[tid].asset_quantity - _quantity) >=0)
           {
                
                transactions[transcount]=Transaction(transcount,_source,_target,now,assets[tid].asset_price,_quantity,1);
                assets[tid].asset_quantity -=_quantity;
                emit TransactionLog("Transaction successful");
        
                transcount++;
                return true;
           }
           else
           {
                transactions[transcount]=Transaction(transcount,_source,_target,now,assets[tid].asset_price,_quantity,0);
                emit TransactionLog("Transaction failed");
               
                transcount++;
                //revert(); If we need to completely reject the transaction
                return false;
           }
       }
      }
      
        function getTransactionDetails(int256 _transactionid)public view  returns(string memory,string memory,uint256,int256,int256,int)
          {
               
                 if(keccak256(abi.encodePacked(transactions[_transactionid].transaction_id))==keccak256(abi.encodePacked(_transactionid)))
                   {
                      return(transactions[_transactionid].source,transactions[_transactionid].target,transactions[_transactionid].timestamp,transactions[_transactionid].price,transactions[_transactionid].quantity,transactions[_transactionid].transaction_state);
                   }
                  
                 
               
         
    }
    
}
