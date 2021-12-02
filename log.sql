-- Keep a log of any SQL queries you execute as you solve the mystery.

--All we know is that the theft took place on July 28, 2020 and that it took place on Chamberlin Street.
SELECT description FROM crime_scene_reports
WHERE day=28 AND month=7 AND year=2020 AND street="Chamberlin Street";

--Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse. Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.
SELECT transcript FROM interviews
WHERE day=28 AND month=7 AND year=2020 AND transcript LIKE "%courthouse%";
--Transcript:
--Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away. If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.
--I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
--As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
--Lets check security footage from the courthouse parking lot.

--So, We work with first Transcript
SELECT name FROM people
JOIN courthouse_security_logs ON people.license_plate=courthouse_security_logs.license_plate
WHERE day=28 AND month=7 AND year=2020 AND hour=10 AND minute>=15 AND minute<=25 and activity="exit";

--we get this names:
--Patrick
--Ernest
--Amber
--Danielle
--Roger
--Elizabeth
--Russell
--Evelyn
--let us check second statement.
SELECT DISTINCT name FROM people
JOIN bank_accounts ON bank_accounts.person_id=people.id
JOIN atm_transactions ON atm_transactions.account_number=bank_accounts.account_number
WHERE day=28 AND month=7 AND year=2020 AND atm_location="Fifer Street" AND transaction_type="withdraw";
--We get this:
--Danielle
--Bobby
--Madison
--Ernest
--Roy
--Elizabeth
--Victoria
--Russell
--Now, our suspect are:Danielle, Ernest, Elizabeth, Russell.
--Let us check third statement.

SELECT name FROM people
JOIN passengers ON passengers.passport_number=people.passport_number
WHERE flight_id=(
SELECT id FROM flights
WHERE day=29 AND month=7 AND year=2020
ORDER BY hour,minute LIMIT 1);
--we get this
--Doris
--Roger
--Ernest
--Edward
--Evelyn
--Madison
--Bobby
--Danielle

--NOW our suspects are: Danielle, Ernest.
SELECT DISTINCT name FROM people
JOIN phone_calls ON people.phone_number=phone_calls.caller
WHERE day=28 AND month=7 AND year=2020 AND duration<60;
--WE get this:
--Roger
--Evelyn
--Ernest
--Madison
--Russell
--Kimberly
--Bobby
--Victoria
--The THIEF is:Ernest.

SELECT city FROM airports
WHERE id=(
SELECT destination_airport_id FROM flights
WHERE year=2020 AND month=7 AND day=29
ORDER BY hour,minute LIMIT 1);

--The thief ESCAPED TO: London

SELECT DISTINCT name FROM people
JOIN phone_calls ON people.phone_number=phone_calls.receiver
WHERE day=28 AND month=7 AND year=2020 AND duration<60 AND caller=(
SELECT phone_number FROM people
WHERE name="Ernest");
--The ACCOMPLICE is:Berthold

