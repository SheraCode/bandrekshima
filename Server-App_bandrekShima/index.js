const app = require('./app');
const db = require('./config/db');

const port = 2005;

app.get('/',(req,res) => {
    res.send('Halooo tita, lagi apa sayangggkuu???')
})

app.listen(port,()=> {
    console.log(`Server Listening on Port http://localhost:${port}`);
})