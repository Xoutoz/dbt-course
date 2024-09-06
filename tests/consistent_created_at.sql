SELECT *
FROM {{ ref('dim_listings_cleansed') }} listings
INNER JOIN {{ ref('fct_reviews') }} reviews
USING (listing_id)
WHERE reviews.review_date < listings.created_at