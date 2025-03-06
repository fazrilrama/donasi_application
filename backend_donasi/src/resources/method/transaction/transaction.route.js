const routes = require('express').Router();
const { middleware } = require('../../../helpers/middleware');
const { create, listByCampaign } = require('./transaction.controller');

routes.post('/:id', middleware, create);
routes.get('/list_by_campaign/:id', middleware, listByCampaign);

module.exports = routes;