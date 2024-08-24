const Auth = require('../model/auth');
const bcrypt =require('bcryptjs');
const generateJWT = require('../utils/generateJWT');
const statusUtils = require('../utils/statusUtils');
const asyncWrapper = require('../middleware/asyncWrapper')
const appError = require('../utils/appError');


const signUp = asyncWrapper(async (req, res,next) => {
        const { email,password } = req.body;
        const findUser = await Auth.findOne({ email: email });

        if (findUser) {
            const e = appError.create(
                "There's already a user with that email",
                400,
                statusUtils.FAIL
            );
            return next(e);
        } else {
            const hashedPassword = await bcrypt.hash(password,10);
            req.body.password= hashedPassword;
            const user = await Auth.create(req.body);
            const token =await generateJWT({ email:user.email , id:user._id , username:user.username }) ;
            user.token = token;
            return res.status(201).json({ msg:"Successfully created an account" ,data: { user }, success: true });
        }
    }
);
const signIn = asyncWrapper(
    async (req, res,next) => {
        const { email, password } = req.body;

        const findUser = await Auth.findOne({ email: email });

        if (!findUser) {
            const e = appError.create(
                "Check your Email or Password",
                400,
                statusUtils.FAIL
            );
            return next(e);
        }
        const isMatch = await bcrypt.compare(password, findUser.password);

        if (!isMatch) {
            const e = appError.create(
                "Check your Email or Password",
                400,
                statusUtils.FAIL
            );
            return next(e);
        }
        const token =await generateJWT({ email:findUser.email , id:findUser._id , username:findUser.username }) ;
        findUser.token = token;
        res.status(200).json({ msg: "Successfully logged in", success: true, token,username:findUser.username });
    }
);
module.exports = {signIn,signUp}