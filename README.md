# Overview

It is a simple application that records, users search queries. In reality, the users will be searching for the article but as of now, the functionality is not implemented so the users will not find any Article. But in as of now, we will record the user's search queries with a number of hits so that our article editors can have an overview of what kind of articles are being searched by users.

To search an article users can just start typing in the search box and already saved queries will start appearing as search predictions, they can select the search query from prediction or can press ENTER.

# Technologies and Libraries
- Rails 5.x
- ElasticSearch
- Redis
- Postgres
- Sidekiq

NOTE: I have used webpacker for frontend assets, please look into app/front_end for JS and CSS.

# Technical Overview

As the application needs to tackle the heavy traffic, we need to keep the scalability parameters in mind.

The search predictions will be retrieved by firing GET requests to the server on each character change in the search field when thousands of users will be doing it concurrently, we need to make sure that this is fast enough to serve responses in very less time.

For that purpose, we are using ElasticSearch, so on each character change, we are firing a GET request to our Rails application with the user search query the Rails application further searched for related search queries in the ElasticSearch and return 5 Most related queries sorted by previous hits count of that query.

Whenever the user presses ENTER we need to store this into a persistent database or if the query is already present in the database, we need to increment its "hits" count.

"hits" count is also incremented when users select one of the search predictions.

We also needed to scale the recording of user search queries for analytics purpose, so what we did is that whenever the user presses ENTER or selects any prediction, the articles related to that search query should be returned that is why it's a GET endpoint. Article search functionality is not implemented yet but what we are doing now is that we are secretly recording user search query in the database. For scalability we are not touching the database in article search request cycle, instead, we are verifying the user query to be valid so only usefull for search queries are preserved for analytics. We have a list of the common word like "how", "I" etc. if the user query does not have anything except these common words, we are ignoring the query to be stored in DB for analytics.

If the user search query is valid, we are just pushing that query to Redis, on later time a Sidekiq worker will process this query and update the Postgres database. We are using Searchkiq as well so the updates in DB are also reflected in the ElasticSearch as well.

# Future Enhancement

- Deployment is very poor now, will need to create a cluster of the elastic search for better performance.
- Implement Article search and add the table for Articles.
- UI is poor as it was just for the demonstration purpose but could be improved.
- Add more analytics features and improve analytics dashboard.
