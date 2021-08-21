##분석 테이블

use cctv;
show tables;
DESC cctv_data;

# 1시간 단위 테이블 생성
create table hourly_stats(
	rid INT PRIMARY KEY AUTO_INCREMENT,
	start_datetime TIMESTAMP , #시작 시간
    avg_person float,
    std_person float,
	avg_vehicle float,
    std_vehicle float
);

# 일 별 테이블 생성
create table day_stats(
	rid INT PRIMARY KEY AUTO_INCREMENT,
	date date ,
    avg_person float,
    std_person float,
	avg_vehicle float,
    std_vehicle float
);
 desc day_stats;


# 주 별 테이블 생성
create table week_stats(
	rid INT PRIMARY KEY AUTO_INCREMENT,
    start_date date,
    end_date date,
    avg_person float,
    std_person float,
	avg_vehicle float,
    std_vehicle float
);

# 월 별 테이블 생성
create table month_stats(
	rid INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_person float,
    std_person float,
	avg_vehicle float,
    std_vehicle float
);

# 연도별 테이블 생성
create table year_stats(
	rid INT PRIMARY KEY AUTO_INCREMENT,
    year year, #년도
    avg_person float,
    std_person float,
	avg_vehicle float,
    std_vehicle float
);

#### 이상값 백업테이블 #######
create table backup(
	  rid int NOT NULL,
      date_time TIMESTAMP ,
      n_person int ,
      n_car int,
      n_truck int,
      n_bus int,
      n_bicycle int,
      n_motorcycle int,
      n_electric_scooter int,
      msg varchar(32)
  );    
