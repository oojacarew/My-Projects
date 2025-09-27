select * 
from stroke_data;

SELECT count(*), stroke, gender         #what is the distribution of stoke occurrence among gender
FROM stroke_data
GROUP BY stroke, gender;

SELECT stroke, ROUND(AVG(age), 2)         #average age of individuals who had stroke
FROM stroke_data
GROUP BY stroke;

SELECT heart_disease, stroke, count(*) AS total_people    # how does heart_disease affect the likelihood of stroke
FROM stroke_data
GROUP BY heart_disease, stroke;

SELECT ever_married, stroke, count(*) total_people     # does being married have any correlation with stroke occurrences
FROM stroke_data
GROUP BY ever_married, stroke;


SELECT work_type, count(*) AS stroke_cases      # What work type has the higest number of stroke cases
FROM stroke_data
WHERE stroke = 1
GROUP BY work_type
ORDER BY stroke_cases DESC; 

SELECT residence_type, count(*) stroke_cases      # Do urban or rural residents have a higher incidence of stroke
FROM stroke_data
WHERE stroke = 1
GROUP BY residence_type; 

SELECT stroke, round(avg(avg_glucose_level), 2) average_glucose   # difference in average glucose level between stroke and non_stroke patients
FROM stroke_data
GROUP BY stroke;

SELECT round(avg(bmi), 2) average_bmi    # what is the average bmi for individuals who suffered a stroke
FROM stroke_data
WHERE stroke = 1;

SELECT smoking_status, stroke, count(*) AS total_people     # are smokers more likely to have a stroke compared to non_smokers
FROM stroke_data
GROUP BY smoking_status, stroke;


 


