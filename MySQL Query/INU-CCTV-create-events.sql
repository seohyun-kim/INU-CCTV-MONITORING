use cctv;
show tables;
DESC cctv_data;

##########################################################
SHOW variables LIKE 'event%'; #이벤트 스케쥴러 상태 확인

#실행 환경 설정
SET global event_scheduler =ON;
SET @@global.event_scheduler =ON;
#root권한으로 주었음

SELECT * FROM information_schema.events; #생성확인

SELECT curdate();
SELECT now();
select current_timestamp();
select @@global.time_zone, @@session.time_zone,@@system_time_zone;
select @@system_time_zone;
SELECT  DATE_ADD(CURDATE(),INTERVAL -1 day);

SELECT count(*) FROM cctv_data;
SELECT AVG(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter) FROM cctv_data;
SELECT SUM(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter) FROM cctv_data;
DESC cctv_data;

drop event day_stats;
#### 1). 매일 00:00:00 에 하루치 데이터 평균과 기준값을 `day_stats` 테이블에 저장   
CREATE EVENT `day_stats`
    ON SCHEDULE EVERY 1 Day 
    STARTS DATE_ADD(CURDATE(),INTERVAL 1 day) #내일 00시부터 시작
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of day'
    DO 
	INSERT INTO day_stats(date, avg_person, std_person, avg_vehicle, std_vehicle) 
		SELECT  DATE_ADD(CURDATE(),INTERVAL -1 day)  , CONVERT(AVG(n_person), float), CONVERT(AVG(n_person)+1.5*STDDEV(n_person), float),
				CONVERT(AVG(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter), float), 
                CONVERT(AVG(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter)+1.5*STDDEV(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter), float)
                FROM cctv_data  WHERE DATE(date_time) =  DATE_ADD(CURDATE(), INTERVAL -1 day) #어제 데이터
                


SELECT  DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d %H:00:00'), INTERVAL -1 hour) ;		
SELECT DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d %H:59:59'), INTERVAL -1 hour)    ;


 #### 0). 매시 00분에 1시간 치 데이터 평균과 기준값을 `hourly_stats` 테이블에 저장   
CREATE EVENT `hourly_stats`
    ON SCHEDULE EVERY 1 hour
    STARTS DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d %H:00:00'), INTERVAL 1 hour) #다가오는 정시부터 시작
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of every hour'
    DO 
	INSERT INTO hourly_stats(start_datetime, avg_person, std_person, avg_vehicle, std_vehicle) 
		SELECT DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d %H:00:00'), INTERVAL -1 hour) , CONVERT(AVG(n_person), float), CONVERT(AVG(n_person)+1.5*STDDEV(n_person), float),
				CONVERT(AVG(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter), float), 
                CONVERT(AVG(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter)+1.5*STDDEV(n_car+n_truck+n_bus+n_bicycle+n_motorcycle+n_electric_scooter), float)
                FROM cctv_data 
                WHERE date_time BETWEEN DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d %H:00:00'), INTERVAL -1 hour) AND DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d %H:59:59'), INTERVAL -1 hour)        
                
                
 SELECT DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d 23:59:59'), INTERVAL -1 day) ;               

DROP event week_stats;
  #### 2). 매주 월요일에 `day_stats` table의 일주일 치(7개의 row) 평균을 `week_stats` 테이블에 저장                 
  CREATE EVENT `week_stats`
    ON SCHEDULE
	EVERY 1 WEEK
	STARTS CURRENT_DATE + INTERVAL 7- WEEKDAY(CURRENT_DATE) DAY #가장 가까운 미래의 월요일
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of week'
    DO 
	INSERT INTO week_stats(start_date, end_date, avg_person, std_person, avg_vehicle, std_vehicle) 
		SELECT CURRENT_DATE + INTERVAL -7- WEEKDAY(CURRENT_DATE) DAY,#지난 주 월요일
			CURRENT_DATE + INTERVAL -1 - WEEKDAY(CURRENT_DATE) DAY, #지난 주 일요일
			CONVERT(AVG(avg_person), float), CONVERT(AVG(std_person), float),
			CONVERT(AVG(avg_vehicle), float), CONVERT(AVG(std_vehicle), float)
			FROM day_stats WHERE date BETWEEN DATE_ADD(DATE_FORMAT(now(), '%Y-%m-%d 00:00:00'),INTERVAL -1 WEEK ) AND DATE_ADD( DATE_FORMAT(now(), '%Y-%m-%d 23:59:59'), INTERVAL -1 day)  
            #오늘(매주 월요일 0시) 기준으로 지난 일주일 간
   


#### 3). 매달 1일에 `day_stats` table의 한달 치 평균을 `month_stats` 테이블에 저장              
 CREATE EVENT `month_stats`
    ON SCHEDULE
	EVERY 1 MONTH
	STARTS LAST_DAY(NOW()) + interval 1 DAY #가장 가까운 1일부터 시작
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of month'
    DO 
	INSERT INTO month_stats(start_date, avg_person, std_person, avg_vehicle, std_vehicle) 
		SELECT LAST_DAY(DATE_FORMAT(now(), '%Y-%m-%d 00:00:00') - interval 2 month) + interval 1 DAY, #지난 달의 1일
			CONVERT(AVG(avg_person), float), CONVERT(AVG(std_person), float),
			CONVERT(AVG(avg_vehicle), float), CONVERT(AVG(std_vehicle), float)
			FROM day_stats WHERE date BETWEEN LAST_DAY(DATE_FORMAT(now(), '%Y-%m-%d 00:00:00') - interval 2 month) + interval 1 DAY AND  LAST_DAY(DATE_FORMAT(now(), '%Y-%m-%d 23:59:59') - interval 1 month) 
            
            
            
#### 4). 매년 1월1일에 `month_stats` table의 일년 치 평균(12개의 row)을 `year_stats` 테이블에 저장     
 CREATE EVENT `year_stats`
    ON SCHEDULE
	EVERY 1 YEAR
	STARTS LAST_DAY(DATE_ADD(NOW(), INTERVAL 12-MONTH(NOW()) MONTH))+ interval 1 DAY #가장 가까운 1월 1일부터 시작
	ON COMPLETION NOT PRESERVE ENABLE
    COMMENT 'average and reference value of year'
    DO 
	INSERT INTO year_stats(_year, avg_person, std_person, avg_vehicle, std_vehicle) 
		SELECT YEAR(CURDATE()-interval 1 DAY), # 지난 년도 (현재 1월1일)
			CONVERT(AVG(avg_person), float), CONVERT(AVG(std_person), float),
			CONVERT(AVG(avg_vehicle), float), CONVERT(AVG(std_vehicle), float)
			FROM month_stats 
            where start_date BETWEEN DATE_ADD(DATE_FORMAT(now(), '%Y-01-01 00:00:00'),INTERVAL -1 YEAR ) 
            AND DATE_ADD(DATE_FORMAT(now(), '%Y-12-31 23:59:59'),INTERVAL -1 YEAR ) #지난 일년
          
            SELECT DATE_ADD(DATE_FORMAT(now(), '%Y-12-31 23:59:59'),INTERVAL -1 YEAR )

            