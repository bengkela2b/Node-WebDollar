import consts from 'consts/const_global'
import InterfaceTransactionsPendingQueue from './pending/Interface-Transactions-Pending-Queue'
import InterfaceTransaction from "./transaction/Interface-Blockchain-Transaction"
import InterfaceSatoshminDB from 'common/satoshmindb/Interface-SatoshminDB'
import InterfaceBlockchainAddressHelper from "common/blockchain/interface-blockchain/addresses/Interface-Blockchain-Address-Helper";
const BigNumber = require('bignumber.js');

class InterfaceBlockchainTransactions {

    constructor( blockchain, wallet ){

        this.blockchain = blockchain;
        this.wallet = wallet;

        let db = new InterfaceSatoshminDB(consts.DATABASE_NAMES.TRANSACTIONS_DATABASE);

        this.pendingQueue = new InterfaceTransactionsPendingQueue(db);

    }

    async createTransactionSimple(address, toAddress, toAmount, fee, currencyTokenId, password = undefined, timeLock){

        if (fee === undefined) fee = this.calculateFeeSimple(toAmount);

        try {
            if (!(toAmount instanceof BigNumber)) toAmount = new BigNumber(toAmount);
        } catch (exception){
            if (typeof exception === "object" && exception.hasOwnProperty("message")) exception = exception.message;

            return { result:false,  message: "Amount is not a valid number", reason: exception.toString() }
        }

        try {
            if (!(fee instanceof BigNumber)) fee = new BigNumber(fee);
        } catch (exception){
            return { result:false,  message: "Fee is not a valid number", reason: exception.toString() }
        }

        try {

            address = this.wallet.getAddress(address);

        } catch (exception){
            if (typeof exception === "object" && exception.hasOwnProperty("message")) exception = exception.message;
            console.error("Creating a new transaction raised an exception - Getting Address", exception.toString());
            return { result:false,  message: "Get Address failed", reason: exception.toString() }
        }


        let transaction = undefined;

        try {

            let from = {
                addresses: [
                    {
                        unencodedAddress: address,
                        publicKey: undefined,
                        amount: toAmount.plus(fee)
                    }
                ],
                currencyTokenId: currencyTokenId
            };

            let to = {
                addresses: [
                {
                    unencodedAddress: toAddress,
                    amount: toAmount
                },
            ]};

            transaction = this._createTransaction(

                //from
                from,

                //to
                to,
                undefined, //nonce
                timeLock, //timeLock
                undefined, //version
                undefined, //txId
                false, false
            );

        } catch (exception) {
            if (typeof exception === "object" && exception.hasOwnProperty("message")) exception = exception.message;
            console.error("Creating a new transaction raised an exception - Failed Creating a transaction", exception.toString());
            return { result:false,  message: "Failed Creating a transaction", reason: exception.toString() }
        }


        let signature;
        try{
            signature = await address.signTransaction(transaction, password);
        } catch (exception){
            if (typeof exception === "object" && exception.hasOwnProperty("message")) exception = exception.message;
            console.error("Creating a new transaction raised an exception - Failed Signing the Transaction", exception.toString());
            return { result:false,  message: "Failed Signing the transaction", reason: exception.toString() }
        }

        try{
            transaction.validateTransaction( this.blockchain.blocks.length-1 );
        } catch (exception){
            if (typeof exception === "object" && exception.hasOwnProperty("message")) exception = exception.message;
            console.error("Creating a new transaction raised an exception - Failed Validating Transaction", exception.toString());
            return { result:false,  message: "Failed Signing the transaction", reason: exception.toString() }
        }

        try{

            this.pendingQueue.includePendingTransaction(transaction);

        } catch (exception){
            if (typeof exception === "object" && exception.hasOwnProperty("message")) exception = exception.message;
            console.error("Creating a new transaction raised an exception - Including Pending Transaction", exception.toString());
            return { result:false,  message: "Including Pending Transaction", reason: exception.toString() }
        }

        return {
            result: true,
            message: "Your transaction is pending...",
            signature: signature
        }
    }

    calculateFeeSimple(toAmount){

        if (toAmount < 0)
            return 0;

        return Math.min( Math.floor (0.1 * toAmount) + 1, 10 );

    }


    _createTransaction(from, to, nonce, timeLock, version, txId, validateFrom, validateTo){
        return new InterfaceTransaction(this.blockchain, from, to, nonce, timeLock, txId, validateFrom, validateTo);
    }


}

export default InterfaceBlockchainTransactions;