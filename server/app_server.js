const express = require('express');
const app = express();
const port = 8000;

const auctionAudit = require('./auction_audit.js');
auctionAudit.auditStart();
app.listen(port);

