var mysql = require('mysql');
var schedule = require('node-schedule');
var date = require('date-utils');
var conn = require('./conf/db');//mysql 연결


var job = schedule.scheduleJob(
    '0/5 * * * * ?', // 주기 (5분마다)----5초 테스트
//  '0 0/5 * * * ?',
function() {
    var data = createData(5*60);
    var sql = 'INSERT into test(date_time, n_person, n_car, n_truck, n_bus, n_bicycle, n_motorcycle, n_electric_scooter) value (?, ?, ?, ?,?,?,?,?)';
    conn.query(sql, [data.Date,  data.peopleNum, data.carNum, data.truckNum, data.busNum,  data.bicycleNum, data.motorcycleNum, data.electricNum], (err) => {
        if (err) {
            console.log(err);
        } else {
            console.log('complete insert data');
        }
    });
});

// mysql 연결 해제시 자동으로 다시 연결
handleDisconnect(conn);
function handleDisconnect(connection) {
    connection.on('error', function(err) {
        if (!err.fatal) {
            return;
        }

        if (err.code !== 'PROTOCOL_CONNECTION_LOST') {
            throw err;
        }
        console.log('Re-connecting lost connection: ' + err.stack);
        conn = mysql.createConnection(connection.config);
        handleDisconnect(conn);
        conn.connect();
    });
}


// 샘플 데이터 랜덤으로 생성
function createData(updateTime) {
    var peopleNum = Math.floor(Math.random() * 30);
    var carNum = Math.floor(Math.random() * 20);
    var truckNum = Math.floor(Math.random() * 20);
    var busNum = Math.floor(Math.random() * 20);
    var bicycleNum = Math.floor(Math.random() * 20);
    var motorcycleNum = Math.floor(Math.random() * 20);
    var electricNum = Math.floor(Math.random() * 20);

    console.log(peopleNum, carNum, truckNum, busNum, bicycleNum, motorcycleNum, electricNum);

    var currentDate = new Date();
    var now = new Date(currentDate);
    //var startDate = new Date(currentDate.setSeconds(currentDate.getSeconds() - updateTime));
    console.log(now.toString());

    return {
        peopleNum: peopleNum,
        carNum: carNum,
        truckNum:truckNum,
        busNum:busNum,
        bicycleNum:bicycleNum,
        motorcycleNum:motorcycleNum,
        electricNum: electricNum,
        Date: now
    };
}


// var updateTime = 5*60; // 데이터 생성 주기 (sec)

// setInterval(timerCallback, updateTime * 1000);

// // 타이머 콜백 함수
// function timerCallback() {
//     var data = createData();
//     console.log(data);

//     var sql = 'INSERT into test(start_date, end_date, people, vehicle) value (?, ?, ?, ?)';
//     conn.query(sql, [data.startDate, data.endDate, data.peopleNum, data.vehicleNum], (err) => {
//         if (err) {
//             console.log(err);
//         } else {
//             console.log('complete instert data');
//         }
//     });
// }
