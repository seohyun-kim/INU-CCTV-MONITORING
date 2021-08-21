##########이상값 탐지 트리거###############
show tables;


set global log_bin_trust_function_creators =on;



DELIMITER //
CREATE TRIGGER detection 
	AFTER INSERT 
    ON cctv_data
	FOR EACH ROW
BEGIN
	DECLARE people_ref_val, vehicle_ref_val FLOAT DEFAULT NULL;
    
	IF (SELECT COUNT(_id) FROM year_stats) >=1 THEN 	
		SET people_ref_val = (SELECT AVG(std_person) FROM year_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM year_stats);
        
	ELSE IF (SELECT COUNT(_id) FROM month_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_person) FROM month_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM month_stats);
        
	ELSE IF (SELECT COUNT(_id) FROM week_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_person) FROM week_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM week_stats);
			
	ELSE IF (SELECT COUNT(_id) FROM day_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_person) FROM day_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM day_stats);
        
	ELSE IF (SELECT COUNT(_id) FROM hourly_stats) >=1 THEN
		SET people_ref_val = (SELECT AVG(std_person) FROM day_stats);
		SET vehicle_ref_val = (SELECT AVG(std_vehicle) FROM day_stats);
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;

	# 설정된 기준 값으로 이상값 탐지
    IF  NEW.n_person > (SELECT @people_ref_val) THEN
		IF  SUM(NEW.n_car +NEW.n_truck+NEW.n_bus+NEW.n_bicycle+NEW.n_motorcycle+NEW.n_electric_scooter) > (SELECT @vehicle_ref_val) THEN
			INSERT INTO backup VALUES(NEW.rid, NEW.date_time ,NEW.n_person, NEW.n_car, NEW.n_truck, NEW.n_bus, NEW.n_bicycle, NEW.n_motorcycle, NEW.n_electric_scooter, 'Outlier People & Vehicle');
		ELSE 
			INSERT INTO backup VALUES(NEW.rid, NEW.date_time ,NEW.n_person, NEW.n_car, NEW.n_truck, NEW.n_bus, NEW.n_bicycle, NEW.n_motorcycle, NEW.n_electric_scooter, 'Outlier People');
		END IF;
	ELSEIF SUM(NEW.n_car +NEW.n_truck+NEW.n_bus+NEW.n_bicycle+NEW.n_motorcycle+NEW.n_electric_scooter) > (SELECT @vehicle_ref_val) THEN
		INSERT INTO backup VALUES(NEW.rid, NEW.date_time ,NEW.n_person, NEW.n_car, NEW.n_truck, NEW.n_bus, NEW.n_bicycle, NEW.n_motorcycle, NEW.n_electric_scooter, 'Outlier Vehicle');
    END IF;
    
   
END //
DELIMITER ;



DESC cctv_data;