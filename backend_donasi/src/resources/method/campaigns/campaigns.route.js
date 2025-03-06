const routes = require('express').Router();
const { middleware } = require('../../../helpers/middleware');
const { create, list } = require('./campaigns.controller');

routes.get('/', middleware, list);
routes.post('/', middleware, create);

module.exports = routes;