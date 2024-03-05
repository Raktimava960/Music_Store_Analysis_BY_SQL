# Q1: Who is the senior most employee based on job title?
SELECT * FROM employee;
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;

/* Q2: Which countries have the most Invoices? */
SELECT * FROM invoice;
SELECT COUNT(*),billing_city FROM invoice
GROUP BY billing_city
ORDER BY COUNT(*) DESC 
LIMIT 1;

/* Q3: What are top 3 values of total invoice? */
select total from invoice
order by total desc limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city
we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
select sum(total) as total_invoice,billing_city from invoice
group by billing_city
order by total_invoice desc limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best 
customer. Write a query that returns the person who has spent the most money.*/
select C.customer_id,C.first_name,c.last_name,sum(invoice.total) as total_invoice,invoice.billing_city from customer as C
inner join invoice on c.customer_id=invoice.customer_id
group by invoice.billing_city 
order by total_invoice desc limit 1;

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select distinct first_name, last_name,email from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on invoice_line.track_id=track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
order by customer.email; 

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
select artist.artist_id,artist.name,count(artist.artist_id) as total_track
from track 
join album2 on album2.album_id=track.album_id
join artist on artist.artist_id=album2.album_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id 
order by total_track desc limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
select track_id,name,milliseconds from track
where milliseconds>(
select avg(track.milliseconds) as avg_length from track)
order by milliseconds desc;

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name,
artist name and total spent */
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, 
    SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album2 ON album2.album_id = track.album_id
	JOIN artist ON artist.artist_id = album2.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;





