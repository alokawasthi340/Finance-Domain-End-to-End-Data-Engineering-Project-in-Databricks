
create or replace database neo;

create or replace schema neo.banking;

use database neo;

use schema neo.banking;

/* =========================================
   TABLE: branches
========================================= */
CREATE OR REPLACE TABLE banking.branches (
    branch_code        VARCHAR(10)     NOT NULL,
    branch_name        VARCHAR(100)    NOT NULL,
    city               VARCHAR(100)    NOT NULL,
    state              VARCHAR(100)    NOT NULL,
    region             VARCHAR(100),
    created_at         TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_branches PRIMARY KEY (branch_code)
);


/* =========================================
   TABLE: customers
========================================= */
CREATE OR REPLACE TABLE banking.customers (
    customer_id        INT             NOT NULL,
    first_name         VARCHAR(100)    NOT NULL,
    last_name          VARCHAR(100)    NOT NULL,
    date_of_birth      DATE            NOT NULL,
    pan_number         VARCHAR(20),
    email              VARCHAR(150),
    phone_number       VARCHAR(20),
    kyc_status         VARCHAR(50)     DEFAULT 'PENDING',
    branch_code        VARCHAR(10)     NOT NULL,
    created_at         TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_customers PRIMARY KEY (customer_id),
    CONSTRAINT FK_customers_branches 
        FOREIGN KEY (branch_code) REFERENCES banking.branches(branch_code)
);


/* =========================================
   TABLE: accounts
========================================= */
CREATE OR REPLACE TABLE banking.accounts (
    account_id         BIGINT          NOT NULL,
    customer_id        INT             NOT NULL,
    account_type       VARCHAR(50)     NOT NULL,   -- Savings / Current
    balance            NUMBER(18,2)    NOT NULL,
    currency           VARCHAR(10)     DEFAULT 'INR',
    branch_code        VARCHAR(10)     NOT NULL,
    status             VARCHAR(50)     DEFAULT 'ACTIVE',
    opened_date        DATE            NOT NULL,
    created_at         TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_accounts PRIMARY KEY (account_id),
    CONSTRAINT FK_accounts_customers 
        FOREIGN KEY (customer_id) REFERENCES banking.customers(customer_id),
    CONSTRAINT FK_accounts_branches 
        FOREIGN KEY (branch_code) REFERENCES banking.branches(branch_code)
);


/* =========================================
   TABLE: transactions
========================================= */
CREATE OR REPLACE TABLE banking.transactions (
    txn_id             BIGINT          NOT NULL,
    account_id         BIGINT          NOT NULL,
    txn_type           VARCHAR(20)     NOT NULL,   -- Debit / Credit
    amount             NUMBER(18,2)    NOT NULL,
    txn_timestamp      TIMESTAMP_NTZ   NOT NULL,
    channel            VARCHAR(50),                -- UPI / ATM / NEFT
    status             VARCHAR(50)     DEFAULT 'SUCCESS',
    created_at         TIMESTAMP_NTZ   DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_transactions PRIMARY KEY (txn_id),
    CONSTRAINT FK_transactions_accounts 
        FOREIGN KEY (account_id) REFERENCES banking.accounts(account_id)
);
