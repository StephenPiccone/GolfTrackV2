# Golf Track App

This App was designed to track users golf shot distances, and provide users with relevant information that effects their shot distance. Shots are saved in persistent storage, allowing users to have a record of their shot distance, club used, and the date the shot was taken. Device location services, CoreData and a weather API are used in order to add functionality to the app.

## Home Screen

The home screen displays necessary information to the user such as the Start/Stop button, shot distance, selected club, wind speed and the winds effect on the balls distance.

### Shot distance

Calculating the shot distance makes use of device location services. When the user initiates a start by pressing "Start" their current location is temporarily saved, and pressing "Stop" when they reach their ball temporarily saves their current location to the device. Using these two locations the distance between the points is calculated and displayed to the user in yards, as well as recorded in the users reccords.

### Wind Speed/Effect

Similarly to shot distance, device location services is used in conjunction with a weather API to gather relevant wind data. The weather API is passed the device location, and returns the windspeed at the users location in m/s. The wind icon beside wind speed rotates depending on the direction of the wind (cardinal direction). Using the wind information passed from the weather API, the wind effect on the ball is calculated by determining if the wind is a headwind or tailwind, then using that information to calculate the estimated % change on the ball's distance.

| Start    | Stop |
| ---      | ---       |
|![start](/screenshot1.png)|![stop](/screenshot3.png)|


## Records Screen

The records screen as the name suggest provides the user with a list of their recorded shots. Each line contains the shot distance, the club used, and the date the shot was recorded. The user can delete records by swiping left on a specific record and selecting delete.

### Persistent storage

Using Apple's CoreData, the records the user creates are saved on the device. This ensures that after closing the app or powering off the device, user records are maintained and accurate.

![record](/screenshot2.png)
