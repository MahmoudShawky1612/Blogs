module.exports = (asFunc)=>{
    return (req,res,next)=>{
        asFunc(req,res,next).catch((e)=>{
            next(e);
        })
    }
}