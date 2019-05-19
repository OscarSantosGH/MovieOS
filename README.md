<<<<<<< HEAD
![Banner](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/banner.png?raw=true "Movie OS")

# MovieOS

This is a movie app for IOS that keep track of the most _popular movies_, the _upcoming_ and _now playing_ movies. This app also demonstrates the use of multiple libraries with a clean architecture for fetching the data from [The Movie Database](https://www.themoviedb.org/) API.


### Setting it up with your own API KEY

In the _**WebService.swift**_ file there is a property called `API_KEY`, initialize the _String_ with your own API KEY in the following line:
```Swift
//INSERT YOU OWN API KEY HERE
let API_KEY = "{INSERT YOU OWN API KEY HERE}"
```

### Libraries

* [Alamofire](https://github.com/Alamofire/Alamofire) for networking.
* [Core Data](https://developer.apple.com/documentation/coredata) to save the favorites movies in app Data Base.


### Architecture
This app uses the [MVVM architecture](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) as explained in this [article](https://medium.com/@azamsharp/mvvm-in-ios-from-net-perspective-580eb7f4f129) written by [Mohammad Azam](https://medium.com/@azamsharp) at his awesome blog. 

### Animations 
MovieOS had some animations to optimize the user experience and make it more pleasant.
![navBarAnim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/navBarAnim.gif?raw=true "NavBar Animation") ![save Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/saveAnim.gif?raw=true "Save Animation")
### Network reachability status

The app uses [Alamofire network reachability](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#network-reachability) to monitor the changes in the network. The app will notify the user when the app lost and find network with a custom message.

![netOnOff Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/networkLost.gif?raw=true "Network Lost Animation") ![netIsBack Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/netIsBack.gif?raw=true "Network is back Animation")

### Core Data Framework

Core Data is used to add and remove the favorites movies in the app Data Base for offline use.

![Add favorite Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/addFav.gif?raw=true "Add favorite movie Animation") ![Remove favorite Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/removeFav.gif?raw=true "Remove favorite movie Animation")

### Search Movies

You can search any movie from [The Movie Database](https://www.themoviedb.org/) and save it in your favorite list.

![Search Movies Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/searchView.gif?raw=true "Search movie Animation")

||||||| added: cast label default value
=======
![Banner](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/banner.png?raw=true "Movie OS")

# MovieOS

This is a movie app for IOS that keep track of the most _popular movies_, the _upcoming_ and _now playing_ movies. This app also demonstrates the use of multiple libraries with a clean architecture for fetching the data from [The Movie Database](https://www.themoviedb.org/) API.


### Setting it up with your own API KEY

In the _**WebService.swift**_ file there is a property called `API_KEY`, initialize the _String_ with your own API KEY in the following line:
```Swift
//INSERT YOU OWN API KEY HERE
let API_KEY = "{INSERT YOU OWN API KEY HERE}"
```

### Libraries

* [Alamofire](https://github.com/Alamofire/Alamofire) for networking.
* [Core Data](https://developer.apple.com/documentation/coredata) to save the favorites movies in app Data Base.


### Architecture
This app uses the [MVVM architecture](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) as explained in this [article](https://medium.com/@azamsharp/mvvm-in-ios-from-net-perspective-580eb7f4f129) written by [Mohammad Azam](https://medium.com/@azamsharp) at his awesome blog. 

### Animations 
MovieOS had some animations to optimize the user experience and make it more pleasant.
![navBarAnim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/navBarAnim.gif?raw=true "NavBar Animation") ![save Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/saveAnim.gif?raw=true "Save Animation")
### Network reachability status

The app uses [Alamofire network reachability](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#network-reachability) to monitor the changes in the network. The app will notify the user when the app lost and find network with a custom message.

![netOnOff Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/networkLost.gif?raw=true "Network Lost Animation") ![netIsBack Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/netIsBack.gif?raw=true "Network is back Animation")

### Core Data Framework

Core Data is used to add and remove the favorites movies in the app Data Base for offline use.
 
![Add favorite Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/addFav.gif?raw=true "Add favorite movie Animation") ![Remove favorite Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/removeFav.gif?raw=true "Remove favorite movie Animation")
 
### Search Movies

You can search any movie from [The Movie Database](https://www.themoviedb.org/) and save it in your favorite list.

![Search Movies Anim](https://github.com/OscarSantosGH/imagesAndGifs/blob/master/images/gift/searchView.gif?raw=true "Search movie Animation")
>>>>>>> master
