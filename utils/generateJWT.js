const jwt = require('jsonwebtoken');

module.exports = async (playLoad)=>{
    const token = await jwt.sign(
        playLoad ,
        process.env.JWT_SECRET_KEY,
        {expiresIn:"10d"} );
    return token;
}