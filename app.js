const mysql = require('mysql');
const express = require('express');
const ejs = require('ejs');
const path = require('path');
const schedule = require('node-schedule');
const cookie = require('cookie-parser');
const session = require('express-session');
const http=require('http');
const socketio = require('socket.io');
const MySQLEvents = require('mysql-events');
const cors = require('cors');
var conn = require('./conf/db');//mysql 연결

//express 사용
const app = express();
app.set('view engine', 'ejs');
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());
app.use(express.static(__dirname + '/public'));

//session 사용
// app.use(cookieParser());
app.use(session({
    key: 'sid',
    secret: 'secret',
    resave: false,
    saveUninitialized: true,
    cookie: {
        maxAge: 10 * 60 * 1000 // 쿠키 유효기간 10분
    }
}));

// server 생성
var port = 8080;
const server = app.listen(port, () => {
    console.log(`start app listening at http://localhost:${port}`)
});

//socket 연결
const io = socketio(server);

io.on("connection", (socket) => {
    s = socket;
    console.log(`connect: ${socket.id}`);

  //  mysql events
    var dsn = {
      host : '',
      user : '',
      password : ''
      };
      var lastRowID = -1;
      var mysqlEventWatcher = MySQLEvents(dsn);
      var watcher =mysqlEventWatcher.add(
        'cctv.backup',
        function (oldRow, newRow, event) {
        if (oldRow === null) {

            var sql = 'select * from backup order by rid desc limit 1';
            conn.query(sql, (err, row) => {
                if (err) {
                    console.log(err);
                } else {
                    console.log("보낸다");
                    socket.emit("datainsert", row[0]);
                  //  console.log(row[0]);
                }
            });

            //console.log(newRow.changedColumns); // []
          }

        },
        'Active'
    );
});

app.get('/', (req, res) => {
  //  res.render(path.join(__dirname + '/views/mainPage.ejs'));
  res.redirect('/login');
});

app.get('/login', (req, res) => {
    let session = req.session;
    console.log("session.email", session.email);
    if (session.email) {
        res.redirect('/mainPage');
    } else {
        res.render('./login/loginPage.ejs');
    }
});

app.post('/login', (req, res) => {
    console.log(req.body.userId);
    var sql = 'select * from user_info where user_id = ?'
    conn.query(sql, [req.body.userId], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            if (row.length == 0) {
                res.write('<script>alert("Wrong ID. Please check the ID"); history.back();</script>');
            } else {
                if (row[0].user_pw != req.body.userPw) {
                    res.write('<script>alert("Wrong Passward. Please check the Passward"); history.back();</script>');
                } else {
                    req.session.email = req.body.userId;
                    res.redirect('/mainPage');
                }
            }
        }
    });
});


app.get('/mainPage', (req, res) => {

    var sql = 'select min(date_time), max(date_time) from cctv_data';
    conn.query(sql, (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.render('./mainPage.ejs', { data: row[0], port: port }); // min(start_date), max(end_date)
        }
    });
});

// 데이터 새로고침
app.post('/mainPage/refreshData', (req, res) => {
    console.log(req.body);
    var sql = 'select * from test order by id desc limit 1'
    conn.query(sql, (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row[0]); // latest row
        }
    });
});


//합계 데이터 조회 - 기간 조회
app.post('/mainPage/dateSelect', (req, res) => {
    var data = req.body;
    var sql = 'select sum(people), sum(vehicle) from test where start_date >= ? and end_date <= ?'
    conn.query(sql, [data.startDate, data.endDate], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row[0]); // sum(people), sum(vehicle)
        }
    });
});

//합계 데이터 조회 - 일간 조회
app.post('/mainPage/daySelect', (req, res) => {
    var data = req.body;
    var sql = "select sum(people), sum(vehicle) from test WHERE start_date >= CONCAT(?,' 00:00:00') AND start_date <= CONCAT(?,' 23:59:59')";
    conn.query(sql,[data._Date,data._Date], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row[0]); // sum(people), sum(vehicle)
        }
    });
});

//합계 데이터 조회 - 시간 조회
app.post('/mainPage/timeSelect', (req, res) => {
    var data = req.body;
    var sql =  "select sum(people), sum(vehicle) from test WHERE start_date >= CONCAT(?,' ',?,':00') AND start_date <= CONCAT(?,' ',?,':00')";
    conn.query(sql, [data.start_Date,data.startTime,data.end_Date,data.endTime], (err,row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row[0]); // sum(people), sum(vehicle)
        }
    });
});


//시작시간/종료시간을 지정하고, 수신한 데이터를 테이블로 표시
app.post('/mainPage/tableDatetimeSelect', (req, res) => {
    var data = req.body;
    console.log(data.startDate);
    var sql = "SELECT * FROM cctv_data WHERE date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql, [data.startDate, data.endDate], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row);
        }
    });
});
app.post('/mainPage/tableDatetimeSelect2', (req, res) => {
    var data = req.body;
    console.log(data.startDate);
    var sql = "SELECT sum(n_car), sum(n_bicycle), sum(n_motorcycle),sum(n_truck) FROM cctv_data WHERE date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql, [data.startDate, data.endDate], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row);
        }
    });
});
app.post('/mainPage/showPerson', (req, res) => {
    var data = req.body;
    console.log(data._Date);
    var sql = "SELECT sum(n_person) FROM cctv_data WHERE  date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql,[data.startDate, data.endDate], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row);
        }
    });

});
app.post('/mainPage/tableDaytimeSelect', (req, res) => {
    var data = req.body;
    console.log(data._Date);
    var sql = "SELECT  * FROM cctv_data WHERE  date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql, [data._Date, data._Date], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row);
        }
    });

});
app.post('/mainPage/tableDaytimeSelect2', (req, res) => {
    var data = req.body;
    console.log(data._Date);
    var sql = "SELECT sum(n_car), sum(n_bicycle), sum(n_motorcycle),sum(n_truck) FROM cctv_data WHERE  date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql, [data._Date, data._Date], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row);
        }
    });

});
app.post('/mainPage/showpperson', (req, res) => {
    var data = req.body;
    console.log(data._Date);
    var sql = "SELECT sum(n_person) FROM cctv_data WHERE  date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql, [data._Date, data._Date], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            console.log("row는"+row);
            res.json(row);
        }
    });

});
app.post('/mainPage/carSpeed', (req, res) => {
    var data = req.body;
    console.log(data._Date);
    var sql = "SELECT sum(n_car), sum(n_bicycle), sum(n_motorcycle),sum(n_truck) FROM cctv_data WHERE  date_time >= CONCAT(?,' 00:00:00') AND date_time <= CONCAT(?,' 23:59:59')";
    conn.query(sql, [data._Date, data._Date], (err, row) => {
        if (err) {
            console.log(err);
        } else {
            //console.log(row);
            res.json(row);
        }
    });

});
app.post('/mainPage/showimg', (req, res) => {
    var data = req.body;
    console.log(data._Date);

    var sql = "select image from cctv_data order by date_time desc limit 1";
    conn.query(sql, (err, row) => {
        if (err) {
            console.log(err);
        } else {
            for (i = 0; i <= row.length - 1; i++) {
                row[i].image = Buffer.from(row[i].image).toString('base64');
            }

            res.render('./part/chart.ejs', { data: row });
        }
    });

});


//메인페이지 로그아웃
app.post('/mainPage/logout', (req, res) => {
    req.session.destroy();
    res.clearCookie('sid');

    res.redirect('/login');
});


// Create Sample Data
app.get('/createSampleData', (req, res) => {
    res.render('./createDataPage.ejs');
});

app.post('/createSampleData', (req, res) => {
    console.log(req.body);
    var data = req.body;

    var startTime = new Date(data.startDate).setHours(data.startTime);
    var endTime = new Date(data.endDate).setHours(data.endDate);

    var flag = 1;
    var job = schedule.scheduleJob({
        start: startTime,
        end: endTime+1,
        rule: '*/5 * * * *' // 주기 (5분마다)
    },
    function() {
        if (flag == 1) {
            res.json('Scheduler is Working');
            flag = flag + 1;
        }

        var data = createData(5*60);
        var sql = 'INSERT into test(start_date, end_date, people, vehicle) value (?, ?, ?, ?)';
        conn.query(sql, [data.startDate, data.endDate, data.peopleNum, data.vehicleNum], (err) => {
            if (err) {
                console.log(err);
            } else {
                console.log('complete insert data');
            }
        });
    });
})
