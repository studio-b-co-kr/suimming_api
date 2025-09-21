# SB Trader API

Rails API for `SB Trader` project.

## Getting Started

Install dependencies
```
bundle install
```

Run client
```
rails s
```

## .env
Make sure to have `.env` file available
```
SUI_PRIVATE_KEY=      <SUI_PRIVATE_KEY>
SUI_PACKAGE_ID        =0x64782be5a17110c5c7bf8ce007fcca6a95ebd124e8aeecbbaa7850b971f358a9
TRANSACTION_BOOK_ID   =0xc12298a1291d0d70df3c22aa70171bb1ca1531270d404a2b78263096d59a1e95
DB_USER               = jl
DB                    = suimming_api
DB_PORT               = 5432
DB_HOST               = 127.0.0.1
DEVISE_JWT_SECRET_KEY = <DEVISE_JWT_SECRET_KEY>
```

## Node script
When deploying, Node modules need to be installed.
`app/services/submit_sui_transaction` uses `node/submit_transaction.js` script, so during deploy run following command:

```
cd /path/to/your/rails/project/node
npm install
```
