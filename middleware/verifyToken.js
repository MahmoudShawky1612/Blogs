const jwt = require('jsonwebtoken');
const statusUtils = require('../utils/statusUtils');
const appError = require('../utils/appError');
const asyncWrapper = require('../middleware/asyncWrapper');

const verifyToken = asyncWrapper(async (req, res, next) => {
    const authHeader = req.headers['authorization'] || req.headers['Authorization'];

    if (!authHeader) {
        const e = appError.create(
            "Token is required",
            401,
            statusUtils.FAIL
        );
        return next(e);
    }

    const token = authHeader.split(' ')[1];
    if (!token) {
        const e = appError.create(
            "Token is missing",
            401,
            statusUtils.FAIL
        );
        return next(e);
    }

    try {
        const decodedToken = jwt.verify(token, process.env.JWT_SECRET_KEY);
        req.user = decodedToken; // Attach decoded token payload to req.user
        next();
    } catch (err) {
        const e = appError.create(
            "Invalid token",
            403,
            statusUtils.FAIL
        );
        return next(e);
    }
});

module.exports = verifyToken;
