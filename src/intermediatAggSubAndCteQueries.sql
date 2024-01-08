/* Intemediate Queries using Aggregation, Subqueries, and Common Table Expression.  */

/* Calculate the total revenue generated by each store */
select st.store_id, sum(p.amount)
from payment p
         join staff s on p.staff_id = s.staff_id
         join store st on s.store_id = st.store_id
group by st.store_id;


/* Identify customers who have rented movies more times than the average customer. */
with CustomerRentalCount as (select r.customer_id, count(r.customer_id) as rental_count
                             from rental r
                             group by r.customer_id)

select c.first_name || ' ' || c.last_name as full_name, cc.rental_count
from CustomerRentalCount cc
         join customer c on c.customer_id = cc.customer_id
group by full_name, rental_count
having rental_count > (select avg(rental_count) from CustomerRentalCount)
order by rental_count desc;


/* Find the actor who has appeared in the most rented films. */

-- find film_id of all rented films
with RentedFilms as (select distinct f.film_id
                     from rental
                              join inventory using (inventory_id)
                              join film f on inventory.film_id = f.film_id)

select a.first_name || ' ' || a.last_name as full_name, count(fa.film_id) as counts
from film_actor fa
         join RentedFilms on RentedFilms.film_id = fa.film_id
         join actor a on fa.actor_id = a.actor_id
group by full_name
order by counts desc
limit 1;





