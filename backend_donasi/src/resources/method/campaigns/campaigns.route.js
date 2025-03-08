const routes = require('express').Router();
const { middleware } = require('../../../helpers/middleware');
const { create, list, detail, createImage } = require('./campaigns.controller');

routes.get('/', middleware, list);
routes.post('/', middleware, create);
routes.post('/create-image/:id', middleware, createImage);
routes.get('/detail/:id', middleware, detail);

module.exports = routes;