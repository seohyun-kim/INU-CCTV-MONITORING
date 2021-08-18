const mysql = require('mysql');
const express = require('express');
const ejs = require('ejs');
const schedule = require('node-schedule');
const cookie = require('cookie-parser');
const session = require('express-session');
const http=require('http');
const socketio = require('socket.io');
const MySQLEvents = require('mysql-events');

var conn = require('./conf/db'); // db접속정보
