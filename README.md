fag (Forums Are Gay) - A board for coders.
==========================================

To setup and start a fag server you just need Ruby 1.9+ and bundler installed.

Then just run

```
rake db:setup
rake start
```

If you want to develop it or a client library it's suggested to start it in development
mode.

```
rake db:test
FAG_DEVELOPMENT=1 FAG_DEBUG=1 rake start
```

You can change the database url with `FAG_DATABASE` and the listening port with `FAG_PORT`.

If you want fag to be able to be accessed cross-domain by javascript, you have to add to
`FAG_DOMAINS` the domain list (including http and port).

API client libraries
--------------------

### Ruby
* https://github.com/meh/ruby-fag-api

### Python
* https://github.com/0Chuzz/pyfag

### JavaScript
* https://github.com/MrYawn/JSFag

### Clojure
* https://github.com/Bronsa/fagotto

Insights
--------

### Models design

```
Flow -> id
     -> title
     -> tags
     -> author_name # present if Anonymous
     -> author_id   # present if logged in User
     -> drops

Drop -> id
     -> title
     -> author_name # present if Anonymous
     -> author_id   # present if logged in User
     -> message

Float -> id
      -> author_name # present if Anonymous
      -> author_id   # present if logged in User
      -> name
      -> language
      -> content

User -> id
     -> name
     -> email (not required)
     -> flows
     -> drops
```

### API design

Version 1 (this means you have to prepend `/1/` to every request):

```
# this returns the csrf token, every request that's not a GET needs to
# have passed this token as a `csrf` parameter in the URL otherwise the
# request will fail with a 403
GET /csrf

# this request is used to get a new csrf token, usually not needed
GET /csrf/renew

# this returns true or false wether you're logged in or not
GET /auth

# this is the entry point, once authorized you get back a cookie
POST /auth # id: the id or the name of the user
           # password: the password to login

# all multiple fetching can have passed a limit and/or offset option, this way you can
# fetch only the group of messages you want

# flows are sorted by newest updated drop in descending order
# drops are sorted by creation date in ascending order

GET /flows # expression (optional): the boolean tag expression to look for

POST /flows # title: the title for the flow
            # tags: the tags for the flow
            # content: the content for the first drop of the flow
            # author_name (required unless logged in): set the flow author as anonymous with the given name

GET /flows/:id # get the whole flow

PUT /flows/:id # tags (optional): json encoded array of tags to replace with
               # title (optional): the new title
               # author_name (optional): set the flow author as anonymous with the given name
               # author_id (optional): set the flow author as the registered user with the given id

DELETE /flows/:id # delete the flow

GET /flows/:id/drops # get the drops for the given flow

POST /flows/:id/drops # name (optional if not logged in): name to set as anonymous author
                      # title (optional): the title for the drop
                      # content: the content of the drop

GET /drops/:id # get the given drop

PUT /drops/:id # title (optional): the new title for the drop
               # author_name (optional): set the drop author as anonymous with the given name
               # author_id (optional): set the drop author as the registered user with the given id
               # content (optional): set the new content

DELETE /drops/:id # destroy the given drop
```
