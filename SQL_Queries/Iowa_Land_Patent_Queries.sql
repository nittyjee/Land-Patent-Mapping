-- Create table for patent description csv
DROP TABLE IF EXISTS Iowa_Patent_Descriptions CASCADE;

CREATE TABLE Iowa_Patent_Descriptions
(
 accession_nr character varying(50),
 doc_class_code character varying(50),
 descrip_nr character varying(50),
 aliquot_parts character varying(50),
 section_nr character varying(50),
 township_nr character varying(50),
 township_dir character varying(50),
 range_nr character varying(50),
 range_dir character varying(50),
 block_nr character varying(50),
 fractional_section character varying(50),
 survey_nr character varying(50),
 meridian_code character varying(50),
 ld_remarks character varying(500),
 state_code character varying(50)
);

-- Copy contents of CSV into new table
copy Iowa_Patent_Descriptions from 'D:\IA_Patent\data\IA_Land_Description.csv' delimiter as ',' csv header;

-- Add column "quarter"
ALTER TABLE Iowa_Patent_Descriptions
ADD quarter character varying(50);

-- Add quarter descriptions to new column
UPDATE Iowa_Patent_Descriptions SET quarter = RIGHT(aliquot_parts, 2);

-- Add column "q-part" for everything that is to left of quarters
ALTER TABLE Iowa_Patent_Descriptions
ADD q_part character varying(50);

-- Add quarter-quarter descriptions to new column
UPDATE Iowa_Patent_Descriptions SET q_part = LEFT(aliquot_parts, char_length(aliquot_parts) - 2);

-- Add column "qq_1" for quarter-quarters and 1 of 2 quarter-quarters of halves
ALTER TABLE Iowa_Patent_Descriptions
ADD qq_1 character varying(50);

-- Add quarter-quarter description for quarter-quarters and 1 of 2 quarter-quarters of halves
UPDATE Iowa_Patent_Descriptions
SET qq_1 =
       CASE WHEN q_part='W½' THEN 'NW'
            WHEN q_part='E½' THEN 'NE'
            WHEN q_part='N½' THEN 'NW'
            WHEN q_part='S½' THEN 'SW'
            WHEN q_part='NW' THEN 'NW'
            WHEN q_part='SW' THEN 'SW'
            WHEN q_part='NE' THEN 'NE'
            WHEN q_part='SE' THEN 'SE'
            ELSE 'other'
       END

-- Add column "qq_2" for 2 of 2 quarter-quarters of halves
ALTER TABLE Iowa_Patent_Descriptions
ADD qq_2 character varying(50);

-- Add quarter-quarter description for 2 of 2 quarter-quarters of halves
UPDATE Iowa_Patent_Descriptions
SET qq_2 =
       CASE WHEN q_part='W½' THEN 'SW'
            WHEN q_part='E½' THEN 'SE'
            WHEN q_part='N½' THEN 'NE'
            WHEN q_part='S½' THEN 'SE'
            ELSE 'other'
       END

-- create qq1_code for qq_1
ALTER TABLE Iowa_Patent_Descriptions
ADD qq1_code character varying(50);

-- create code for qq_1
UPDATE Iowa_Patent_Descriptions
SET qq1_code =
       CASE WHEN qq_1='NW' THEN 'B'
            WHEN qq_1='SW' THEN 'C'
            WHEN qq_1='NE' THEN 'A'
            WHEN qq_1='SE' THEN 'D'
            ELSE ''
       END


-- create qq2_code for qq_2
ALTER TABLE Iowa_Patent_Descriptions
ADD qq2_code character varying(50);

-- create code for qq_2
UPDATE Iowa_Patent_Descriptions
SET qq2_code =
       CASE WHEN qq_2='NW' THEN 'B'
            WHEN qq_2='SW' THEN 'C'
            WHEN qq_2='NE' THEN 'A'
            WHEN qq_2='SE' THEN 'D'
            ELSE ''
       END


-- Create new column for sections to add '0' when single digit
ALTER TABLE Iowa_Patent_Descriptions
ADD sec_new character varying(50);

-- Add '0' when single digits for sections
UPDATE Iowa_Patent_Descriptions
SET sec_new =
       CASE WHEN char_length(section_nr)='1' THEN '0' || section_nr
            WHEN char_length(section_nr)='2' THEN section_nr
            ELSE 'other'
       END



-- Create new column for townships to add '0' when single digit
ALTER TABLE Iowa_Patent_Descriptions
ADD twp_new character varying(50);

-- Add '0' when single digits for townships
UPDATE Iowa_Patent_Descriptions
SET twp_new =
       CASE WHEN char_length(township_nr)='3' THEN '0' || LEFT(township_nr, char_length(township_nr) - 2)
            WHEN char_length(township_nr)='4' THEN LEFT(township_nr, char_length(township_nr) - 2)
            WHEN char_length(township_nr)='5' THEN LEFT(township_nr, char_length(township_nr) - 2)
            ELSE 'other'
       END


-- Create new column for range to add '0' when single digit
ALTER TABLE Iowa_Patent_Descriptions
ADD rng_new character varying(50);

-- Add '0' when single digits for range
UPDATE Iowa_Patent_Descriptions
SET rng_new =
       CASE WHEN char_length(range_nr)='3' THEN '0' || LEFT(range_nr, char_length(range_nr) - 2)
            WHEN char_length(range_nr)='4' THEN LEFT(range_nr, char_length(range_nr) - 2)
            WHEN char_length(range_nr)='5' THEN LEFT(range_nr, char_length(range_nr) - 2)
            ELSE 'other'
       END


-- Create code column for quarters
ALTER TABLE Iowa_Patent_Descriptions
ADD q_code character varying(50);

-- Generate code for quarters
UPDATE Iowa_Patent_Descriptions
SET q_code =
       CASE WHEN quarter='NW' THEN 'B'
            WHEN quarter='SW' THEN 'C'
            WHEN quarter='NE' THEN 'A'
            WHEN quarter='SE' THEN 'D'
            ELSE ''
       END

-- Create full code column for qq_1
ALTER TABLE Iowa_Patent_Descriptions
ADD qq1_full character varying(50);

-- Generate full code for qq_1
UPDATE Iowa_Patent_Descriptions SET qq1_full = 'T' || twp_new || township_dir || 'R' || rng_new || range_dir || sec_new || qq1_code || q_code;


       

-- Create full code column for qq_2
ALTER TABLE Iowa_Patent_Descriptions
ADD qq2_full character varying(50);

-- Generate full code for qq_1
UPDATE Iowa_Patent_Descriptions
SET qq2_full =
       CASE WHEN qq2_code='' THEN ''
            ELSE 'T' || twp_new || township_dir || 'R' || rng_new || range_dir || sec_new || qq2_code || q_code
       END

	   
	  
--Print Length of Codes in order to sort

--qq_1
ALTER TABLE Iowa_Patent_Descriptions
ADD qq1_len character varying(50);

--qq_1_full
UPDATE Iowa_Patent_Descriptions
SET qq1_len = char_length(qq1_full);

--qq_2
ALTER TABLE Iowa_Patent_Descriptions
ADD qq2_len character varying(50);

--qq_2_full
UPDATE Iowa_Patent_Descriptions
SET qq2_len = char_length(qq2_full);


-- Export to CSV file
COPY iowa_patent_descriptions TO 'D:/Iowa_Land_Patent_Mapping\coded_descriptions_2.csv' DELIMITER ',' CSV HEADER;
-- Copy (Select * From iowa_patent_descriptions) To 'D:/Iowa_Land_Patent_Mapping\coded_descriptions.csv' With CSV;