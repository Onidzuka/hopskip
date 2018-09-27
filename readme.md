##### 1. Write out the database schema that you would design for repeating rides. Include table names, column names, column types, and a brief description of each column.


```
TABLE NAME:
organizers

COLUMNS:
id, int
name, string

----------------

TABLE NAME:
locations

COLUMNS:
id, int
name, string
organizer_id, int

----------------

TABLE NAME:
riders

COLUMNS:
id, int
first_name, string
last_name, string
birthday, timestamp
phone, string
gender, string
care_driver_prefence, string
can_seat_in_front, boolean
booster_seat, boolean
organizer_id, int

----------------

TABLE NAME:
rides

COLUMNS:
id, int
status, string -> "pending", "completed", "cancelled"
pick_up_at, timestamp
requirements
pick_up_location, string
pick_up_notes, string
drop_off_location, string 
drop_off_notes, string
organizer_id, int

----------------

TABLE NAME:
ride_requests

COLUMNS:
id, int
ride_id, int
rider_id, int

----------------

```

#####  2. Describe the routes, controller(s), and models you would implement.

ROUTES:

```
  resources :organizers do
    resources :riders
    resources :locations
  end

  resources :rides
```

MODELS/CLASSES:
```
 - Organizer 
   has_many :locations 
   has_many :riders 
   has_many :rides
 
 - Location
   belongs_to :organizer
 
 - Rider
   belongs_to :organizer
   has_many :ride_requests
   has_many :rides, through: :ride_requests
 
 - Ride
   belongs_to :organizer
   has_many :ride_requests
   has_many :riders, through: :ride_requests
 
 - RideRequest
   belongs_to :ride
   belongs_to :rider
```
   
SERVICES/CLASSES:
```
 - CreateRide
 - UpdateRide
 - CancelRide
```

   
CONTROLLERS/CLASSES:
```
 - rides#create
 - rides#update
 - rides#cancel
```
 
#####  3. Write request/response documentation for how a mobile client might create, edit, and cancel a set of repeating rides.
 
 - Create ride 
 
 ```
 POST /api/rides
 ```
 
 Required Parameters:
 
 Name | Type | Description | Example
 --- | --- | --- | ---
 requirements | string | Ride requirements | "pick_up_and_drop_off", "pick_up", "drop_off
 pick_up_location | string | Pick up location | "Barry Ave, LA, CA, 90064"
 pick_up_notes | string | Pick up notes | "Don't let him forget his backpack"
 drop_off_location | string | Drop off location | "Arizona Ave, LA, CA, 90054"
 drop_off_notes | string | Drop off notes | "Eat your lunch!"
 riders_ids | array | riders ids | [1,2,3]
 pick_up_at | timestamp | Pick up timestamp | "2018-09-27T05:23:25+00:00"
 
 Optional Parameters:
  
   Name | Type | Description | Example | Notes
    --- | --- | --- | --- | ---
   repeat_until | string | date until ride repeats | "09/30/2018" | 
   repeat_on | array | week days to repeat | ["Monday", "Friday", "Sunday"] | Required if repeat_until  present
 
  Format:
 
  ```
 {
   ride: {
     repeat_until: "",
     repeat_on: [],
     riders_ids: [],
     pick_up_at: "",
     requirements: "",
     pick_up_location: "",
     pick_up_notes: "",
     drop_off_location: "",
     drop_off_notes: ""
   }
 }
  ```

  Response:
  
  ```
  HTTP/1.1 201 Created
  ```
  
  - Update ride 

 ```
 PATCH /api/rides
 ```
 
  Required Parameters:
 
 Name | Type | Description | Example
 --- | --- | --- | ---
 id | string | ride id | 1
 requirements | string | Ride requirements | "pick_up_and_drop_off", "pick_up", "drop_off
 pick_up_location | string | Pick up location | "Barry Ave, LA, CA, 90064"
 pick_up_notes | string | Pick up notes | "Don't let him forget his backpack"
 drop_off_location | string | Drop off location | "Arizona Ave, LA, CA, 90054"
 drop_off_notes | string | Drop off notes | "Eat your lunch!"
 riders_ids | array | riders ids | [1,2,3]
 pick_up_at | timestamp | Pick up timestamp | "2018-09-27T05:23:25+00:00"
 
   ```
 {
   id: "",
   ride: {
     repeat_until: "",
     repeat_on: [],
     riders_ids: [],
     pick_up_at: "",
     requirements: "",
     pick_up_location: "",
     pick_up_notes: "",
     drop_off_location: "",
     drop_off_notes: ""
   }
 }
  ```
  
    - Cancel ride 

 ```
 PATCH /api/cancel_rides
 ```
 
  Required Parameters:
 
 Name | Type | Description | Example
 --- | --- | --- | ---
 id | string | ride id | 1
 cancel_future | boolean | Cancels current and future rides if true, otherwise cancels current only | false
 
   ```
 {
   id: "",
   cancel_future: true
 }
  ```
  
####  4. Provide edge cases and how you would test them.

Api might create thousands or millions of rides depending on "repeat until" value. I would  set a limit for an interval between current time and repeat until date. 

I would add tests for all normal and abnormal cases.


####  5. Provide performance challenges and how you would address them.

Creating and cancelling repeating rides might take a while depending on amount of data. I would use background processors like sidekiq. 
