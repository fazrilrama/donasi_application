const jwt = require("jsonwebtoken");

exports.middleware = async (req, res, next) => {
    try {
        if (req.headers.authorization) {
            let token = '';
            token = await req.headers.authorization.split(" ")[1];

            const decodeToken = jwt.verify(token, process.env.SECRET_KEY);

            if (decodeToken) {
                req.user = decodeToken;

                next();
            } else {
                return res.status(401).send({
                    status: true,
                    message: 'NOT_AUTHORIZED',
                });
            }
        } else {
            return res.status(401).send({
                status: false,
                message: 'NOT_AUTHORIZED',
            });
        }
    } catch (e) {
        return res.status(500).send({
            status: false,
            message: "TOKEN_NOT_VALID",
        });
    }
}