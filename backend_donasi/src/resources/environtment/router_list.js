const express = require('express');
const router = express.Router();
const authRouter = require('../method/authentication/auth.route');
const campaignsRouter = require('../method/campaigns/campaigns.route');
const transactionRouter = require('../method/transaction/transaction.route');

router.use('/auth', authRouter);
router.use('/campaign', campaignsRouter);
router.use('/transaction', transactionRouter);

module.exports = router;
