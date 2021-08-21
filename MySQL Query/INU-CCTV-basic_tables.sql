use cctv;
select * from time_zone_name where name='KST';

SELECT VERSION();



SELECT * FROM cctv_data ORDER BY rid DESC limit 10;

show tables;
DESC cctv_data;
DESC people_pos;
select @@global.time_zone, @@session.time_zone,@@system_time_zone;
set global time_zone = 'Asia/Seoul';
set time_zone = 'Asia/Seoul';


create table cctv_data(
	  rid int NOT NULL AUTO_INCREMENT PRIMARY KEY,
      date_time TIMESTAMP ,
      n_person int ,
      n_car int,
      n_truck int,
      n_bus int,
      n_bicycle int,
      n_motorcycle int,
      n_electric_scooter int
  );    
  
  DROP table person_pos;
  DESC people_pos;
create table person_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  
  create table car_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  
    create table truck_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  
    create table bus_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  
      create table motocycle_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  

     create table electric_scooter_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  
       create table bicycle_pos(
	  rid int NOT NULL PRIMARY KEY,
      date_time TIMESTAMP ,
	  loc_0 int,
      loc_1 int,
      loc_2 int,
      loc_3 int,
      loc_4 int,
      loc_5 int,
      loc_6 int,
      loc_7 int,
      loc_8 int,
      foreign key (rid) references cctv_data (rid)
  );  
  
  
  
  ####로그인정보
  create table user_info(
	  rid int NOT NULL PRIMARY KEY auto_increment,
	  user_id varchar(20),
      user_pw varchar(20)
  );  

  
  DESC user_info;
  insert into user_info (user_id, user_pw) value('inu', 'inu');
  SELECT * FROM user_info;
  
  
  //////////////////////////////
  
    DROP table car_speed;
    
  create table person_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
    create table car_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
  

    create table truck_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
  

    create table bus_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
    create table bicycle_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
  

    create table motocycle_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
  
    

    create table electric_scooter_speed(
	  rid int NOT NULL primary key,
      date_time TIMESTAMP ,
	  loc_0  float,
      loc_1  float,
      loc_2  float,
      loc_3  float,
      loc_4  float,
      loc_5  float,
      loc_6  float,
      loc_7  float,
      loc_8  float,
      foreign key (rid) references cctv_data (rid)
  );  
  
  
  
  ######################################################################
  