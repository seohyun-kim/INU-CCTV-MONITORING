USE test;
show tables;
DESC user_info;

DESC backup;
#트리거 없애
DROP TRIGGER IF EXISTS detection;
select @@global.time_zone, @@session.time_zone,@@system_time_zone;
#원래 트리거
DELIMITER //
CREATE TRIGGER detection 
	AFTER INSERT 
    ON test 
	FOR EACH ROW
BEGIN
    IF  NEW.people > (SELECT AVG(people)+1.5*STDDEV(people) FROM test) THEN
    
		IF  NEW.vehicle > (SELECT AVG(vehicle)+1.5*STDDEV(vehicle) FROM test) THEN
			INSERT INTO backup VALUES(NEW.id, NEW.start_date ,NEW.end_date, NEW.people, NEW.vehicle, 'Outlier People & Vehicle');
		ELSE 
			INSERT INTO backup VALUES(NEW.id, NEW.start_date ,NEW.end_date, NEW.people, NEW.vehicle, 'Outlier People');
		END IF;
        
	ELSEIF NEW.vehicle > (SELECT AVG(vehicle)+1.5*STDDEV(vehicle) FROM test) THEN
		INSERT INTO backup VALUES(NEW.id, NEW.start_date ,NEW.end_date, NEW.people, NEW.vehicle, 'Outlier Vehicle');
    END IF;
END //
DELIMITER ;


show triggers; #트리거 보여줘
TRUNCATE backup; #생각하고 누르셈!!


SHOW EVENTS ;

show tables;

###########테이블 생성########################


# 일 별 테이블 생성
create table day_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _date date,
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);
 desc day_stats;

# 주 별 테이블 생성
create table week_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date,
    end_date date,
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월 별 테이블 생성
create table month_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 연도별 테이블 생성
create table year_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, #년도
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성 (월요일)
create table monthly_mon_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성(화요일)
create table monthly_tue_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성(수요일)
create table monthly_wed_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성(목요일)
create table monthly_thu_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성 (금요일)
create table monthly_fri_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성 (토요일)
create table monthly_sat_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 월간 요일별 테이블 생성 (일요일)
create table monthly_sun_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    start_date date, #월 포맷이 없어서 그냥 해당 달의 첫날로함
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

show tables;

# 연간 요일별 테이블 생성 (월요일)
create table yearly_mon_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 연간 요일별 테이블 생성 (화요일)
create table yearly_tue_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);
# 연간 요일별 테이블 생성 (수요일)
create table yearly_wed_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);
# 연간 요일별 테이블 생성 (목요일)
create table yearly_thu_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);
# 연간 요일별 테이블 생성 (금요일)
create table yearly_fri_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);
# 연간 요일별 테이블 생성 (토요일)
create table yearly_sat_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

# 연간 요일별 테이블 생성 (일요일)
create table yearly_sun_stats(
	_id INT PRIMARY KEY AUTO_INCREMENT,
    _year year, 
    avg_people float,
    std_people float,
	avg_vehicle float,
    std_vehicle float
);

show tables;


##########################################################
SHOW variables LIKE 'event%'; #이벤트 스케쥴러 상태 확인

#실행 환경 설정
SET global event_scheduler =ON;
SET @@global.event_scheduler =ON;

SELECT * FROM information_schema.events; #생성확인




#### 1). 매일 00:00:00 에 하루치 데이터 평균과 기준값을 `day_stats` 테이블에 저장   
CREATE EVENT `day_stats`
    ON SCHEDULE EVERY 1 Day 
    STARTS CURDATE() #오늘부터 시작 (표준시간 기준임, 한국시간은 +9 hour 해줘야 함)
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of day'
    DO 
	INSERT INTO day_stats(_date, avg_people, std_people, avg_vehicle, std_vehicle) 
		SELECT  DATE_ADD(CURDATE(),INTERVAL -1 day)  , CONVERT(AVG(people), float), CONVERT(AVG(people)+1.5*STDDEV(people), float),
				CONVERT(AVG(vehicle), float), CONVERT(AVG(vehicle)+1.5*STDDEV(vehicle), float)
                FROM test  WHERE DATE(start_date) =  DATE_ADD(CURDATE(), INTERVAL -1 day) #어제 데이터
                

 #### 2). 매주 월요일에 `day_stats` table의 일주일 치(7개의 row) 평균을 `week_stats` 테이블에 저장                 
  CREATE EVENT `week_stats`
    ON SCHEDULE
	EVERY 1 WEEK
	STARTS CURRENT_DATE + INTERVAL 7- WEEKDAY(CURRENT_DATE) DAY #가장 가까운 미래의 월요일
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of week'
    DO 
	INSERT INTO week_stats(start_date, end_date, avg_people, std_people, avg_vehicle, std_vehicle) 
		SELECT CURRENT_DATE + INTERVAL -7- WEEKDAY(CURRENT_DATE) DAY,#지난 주 월요일
			CURRENT_DATE + INTERVAL -1 - WEEKDAY(CURRENT_DATE) DAY, #지난 주 일요일
			CONVERT(AVG(avg_people), float), CONVERT(AVG(std_people), float),
			CONVERT(AVG(avg_vehicle), float), CONVERT(AVG(std_vehicle), float)
			FROM day_stats WHERE _date BETWEEN DATE_ADD(NOW(),INTERVAL -1 WEEK ) AND NOW() #오늘(매주 월요일 0시) 기준으로 지난 일주일 간
            


#### 3). 매달 1일에 `day_stats` table의 한달 치 평균을 `month_stats` 테이블에 저장              
 CREATE EVENT `month_stats`
    ON SCHEDULE
	EVERY 1 MONTH
	STARTS LAST_DAY(NOW()) + interval 1 DAY #가장 가까운 1일부터 시작
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of month'
    DO 
	INSERT INTO month_stats(start_date, avg_people, std_people, avg_vehicle, std_vehicle) 
		SELECT LAST_DAY(NOW() - interval 2 month) + interval 1 DAY, #지난 달의 1일
			CONVERT(AVG(avg_people), float), CONVERT(AVG(std_people), float),
			CONVERT(AVG(avg_vehicle), float), CONVERT(AVG(std_vehicle), float)
			FROM day_stats WHERE _date BETWEEN DATE_ADD(NOW(),INTERVAL -1 WEEK ) AND NOW()
                            


#### 4). 매년 1월1일에 `month_stats` table의 일년 치 평균(12개의 row)을 `year_stats` 테이블에 저장     
 CREATE EVENT `year_stats`
    ON SCHEDULE
	EVERY 1 YEAR
	STARTS LAST_DAY(DATE_ADD(NOW(), INTERVAL 12-MONTH(NOW()) MONTH))+ interval 1 DAY #가장 가까운 1월 1일부터 시작
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of year'
    DO 
	INSERT INTO year_stats(_year, avg_people, std_people, avg_vehicle, std_vehicle) 
		SELECT YEAR(CURDATE()-interval 1 DAY), # 지난 년도
			CONVERT(AVG(avg_people), float), CONVERT(AVG(std_people), float),
			CONVERT(AVG(avg_vehicle), float), CONVERT(AVG(std_vehicle), float)
			FROM month_stats where start_date BETWEEN DATE_ADD(NOW(),INTERVAL -1 YEAR ) AND NOW() #지난 일년
                 



###################test########################
CREATE EVENT `day_stats_test`
    ON SCHEDULE EVERY 1 Minute  
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of day'
    DO 
	INSERT INTO day_stats(_date, avg_people, std_people, avg_vehicle, std_vehicle) 
		SELECT  CURDATE(), CONVERT(AVG(people), float), CONVERT(AVG(people)+1.5*STDDEV(people), float),
				CONVERT(AVG(vehicle), float), CONVERT(AVG(vehicle)+1.5*STDDEV(vehicle), float)
                FROM test  WHERE DATE(start_date) = DATE(date_add(now(),INTERVAL 1 DAY))
            

##############################################


#############################################
###############ver4.1 이상값 탐티 ##############

DELIMITER //
CREATE TRIGGER detection 
	AFTER INSERT 
    ON test 
	FOR EACH ROW
BEGIN
	DECLARE people_ref_val, vehicle_ref_val FLOAT DEFAULT NULL;
    
	IF (SELECT COUNT(_id) FROM year_stats) >=1 THEN 	
		SET people_ref_val = (SELECT AVG(std_people) FROM year_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM year_stats);
        
	ELSE IF (SELECT COUNT(_id) FROM month_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_people) FROM month_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM month_stats);
        
	ELSE IF (SELECT COUNT(_id) FROM week_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_people) FROM week_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM week_stats);
			
	ELSE IF (SELECT COUNT(_id) FROM day_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_people) FROM day_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM day_stats);
				END IF;
			END IF;
		END IF;
	END IF;

	# 설정된 기준 값으로 이상값 탐지
    IF  NEW.people > (SELECT @people_ref_val) THEN
		IF  NEW.vehicle > (SELECT @vehicle_ref_val) THEN
			INSERT INTO backup VALUES(NEW.id, NEW.start_date ,NEW.end_date, NEW.people, NEW.vehicle, 'Outlier People & Vehicle');
		ELSE 
			INSERT INTO backup VALUES(NEW.id, NEW.start_date ,NEW.end_date, NEW.people, NEW.vehicle, 'Outlier People');
		END IF;
	ELSEIF NEW.vehicle > (SELECT @vehicle_ref_val) THEN
		INSERT INTO backup VALUES(NEW.id, NEW.start_date ,NEW.end_date, NEW.people, NEW.vehicle, 'Outlier Vehicle');
    END IF;
    
   
END //
DELIMITER ;