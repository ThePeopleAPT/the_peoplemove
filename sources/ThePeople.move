module ThePeople::thepeoplecoin {
    use std::signer;
    use std::string;
    use aptos_framework::coin;


    
    struct The_People { }
    struct CoinCapabilities<phantom CoinType> has key { 
        burn_capability: coin::BurnCapability<CoinType>,
    }

    //entry function
    public entry fun initialize_coin<CoinType>(
        issuer: &signer,
        name: string::String,
        symbol: string::String,
        decimals: u8,
        amount: u64
    ) {
        let (burn_cap, freeze_cap, mint_cap) = coin::initialize(issuer, name, symbol, decimals, true);
        coin::register<CoinType>(issuer);
        let coins_minted = coin::mint<CoinType>(amount, &mint_cap);
        coin::deposit(signer::address_of(issuer), coins_minted);

        coin::destroy_freeze_cap(freeze_cap);
        coin::destroy_mint_cap(mint_cap);

        move_to<CoinCapabilities<CoinType>>(issuer,
            CoinCapabilities<CoinType>{
                burn_capability: burn_cap,
        });
    }
}