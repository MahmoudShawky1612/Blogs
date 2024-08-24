const express = require('express');
const session = require('express-session');

const app = express();
const connectDB = require('./db/connection');
const blogs = require('./routes/blogs');
const users = require('./routes/users');
const statusUtils = require('./utils/statusUtils');


require('dotenv').config();

app.use(express.json());
const port = 3000;

app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
}));

app.use('/api/v1/blogs', blogs);
app.use('/api/v1/users', users); 

const start = async () => {
    try {
        const mainDBConnection = await connectDB(process.env.MONGO_URI);

        app.listen(port, () => console.log(`Listening on port ${port}`));
    } catch (error) {
        console.error('Error starting server:', error);
    }
};

app.all('*',(req,res,next)=>{
    res.status(404).json({status:statusUtils.ERROR,msg:"no rout found"});
})

app.use((e,req,res,next)=>{
    res.status(e.statusCode || 500).json({status:e.statusText || statusUtils.ERROR , msg:e.message})
})

start();
