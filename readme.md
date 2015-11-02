# Tracks
## Rails Inspired Framework

---

Tracks is a Rails inspired framework that can respond to server requests with HTML. It also includes an ActiveRecord inspired implementation of Object-Relational Mapping, ActiveRecord Lite.

### Tracks Features

 - can read and write to/from cookie
 - can flash messages that persist through a redirect
 - can process embedded ruby on .erb files to pure HTML

### Planned Features

 - implement PATCH, DELETE requests
 - CSRF protection



### ActiveRecord Lite features

 - SQLObject class from which all models inherit. Provides the foundation for interacting with the database
 - Can infer correct table to read from through corresponding Ruby classname
 - Can make the appropriate searches based on associations such as has\_many, belongs\_to, and has\_many through

### Planned Features

 - implement a relations class to allow stacking of association methods
 - prefetch with an includes method to optimize number of queries made
