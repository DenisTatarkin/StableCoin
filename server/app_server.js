const express = require('express');
const app = express();
const port = 8000;

const auctionAudit = require('./auction_audit.js');
const courseOracle = require('./course_oracle.js');
auctionAudit.auditStart();
courseOracle.oracleStart();
app.listen(port);

