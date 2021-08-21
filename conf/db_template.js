//mysql 버전: 8.0.26-0ubuntu0.20.04.2
const mysql = require('mysql');

// mysql 연결
var conn = mysql.createConnection({
    host : '',
    user : '',
    password : '',
    database : ''
});
conn.connect();

//외부 사용
module.exports =conn;
