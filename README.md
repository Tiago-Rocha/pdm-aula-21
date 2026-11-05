# pdm-aula-21 · Where am I, the nearest island and the map

Repository for lesson 21 of PDM (Mobile Device Programming), CTeSP DAW, ESTA, University of the Azores, 2026/27.

Tempo Açores with the islands from the course API (`https://api-pdm.sublimecipher.com`), accounts and favourites, as in lesson 17. Today the app asks the phone where the person is, says which island is closest, and shows the nine islands on a map made of OpenStreetMap tiles.

```
lib/
  main.dart                          loads the settings, puts the pieces together
  models/
    island.dart                      Island, now with latitude and longitude
    forecast.dart                    WeatherType, DayForecast, Forecast
    user.dart                        AppUser, Session
  data/
    api_client.dart                  HTTP: tokens, headers, status codes, JSON
    forecast_repository.dart         what the app can ask for (the interface)
    http_forecast_repository.dart    how: asks the API, returns Island
    auth_repository.dart             login, register, refresh, logout
    favorites_repository.dart        GET, PUT and DELETE on /v1/me/favorites
    session_store.dart               refresh token in secure storage
  location/
    location_service.dart            permission and position, with geolocator
    nearest.dart                     distance to an island, the nearest one
  state/
    forecast_notifier.dart           loading, error and islands
    session_notifier.dart            who is logged in
    favorites_notifier.dart          the favourite islands of who is logged in
    location_notifier.dart           where the person is, in one line
    settings.dart                    last email and theme (shared_preferences)
  screens/
    islands_screen.dart              the islands, the card "Onde estou?", the map button
    map_screen.dart                  the map, a pin per island, "A minha posição"
    login_screen.dart                log in or create an account
  widgets/
    nearest_card.dart                the button "Onde estou?" and the answer
    island_sheet.dart                the sheet that opens when you tap a pin
```

Packages added today: `geolocator` (permission, position, distance), `flutter_map` (the map, in Dart) and `latlong2` (the `LatLng` type).

## Getting started

```bash
git clone https://github.com/Tiago-Rocha/pdm-aula-21.git
cd pdm-aula-21
flutter pub get
flutter run -d chrome --dart-define=CLIENT_ID=pdm-ab12cd --dart-define=CLIENT_SECRET=your-secret
```

Your `clientId` and `clientSecret` are in issue #1 of your `pdm-miniprojeto` repository (or, for the group project, in issue #1 of your group's repository). They go on the command line, never in the code and never in git. Pressing F5 in VS Code does not pass them. Keep the `flutter run` command on one line: PowerShell does not accept `\` to split it.

Log in. On `main` you see the islands and, above them, a card with the button "Onde estou?". Tap it: the card says there is no position. That is the starting point. The map button in the app bar already opens a map of the Azores, with nine small pins without names. In the terminal where `flutter run` is running, `r` is hot reload, `R` is hot restart and `q` quits. Open a second terminal for the `git` commands.

Chrome asks for the position with its own dialog, like a phone does. To test "denied" again, click the icon on the left of the address bar and reset the permission.

## The steps

There is one branch per step. `main` is the starting point; `passo-4` is the final state. Each step is a `TODO` with its number in the code.

| Step | Branch | What you do | In the app |
|---|---|---|---|
| 1 | `passo-1` | `lib/location/location_service.dart`: is the location service on? Ask for permission and turn the answer into one of four states (`TODO 1`). | "Onde estou?" shows the dialog. Accept: the card shows your coordinates. Deny: the card says so, and nothing crashes. |
| 2 | `passo-2` | `lib/location/nearest.dart`: measure the distance to every island and keep the shortest; `lib/state/location_notifier.dart`: call it after the position arrives (`TODO 2`). | The card says "Estás a 16 km de São Miguel". |
| 3 | `passo-3` | `lib/screens/map_screen.dart`: a `Marker` per island, with a pin and the name, that opens the sheet when tapped (`TODO 3`). | Nine pins on the map. Tap one: the sheet with the island. |
| 4 | `passo-4` | `lib/screens/map_screen.dart`: the button "A minha posição" asks the `LocationNotifier` and moves the camera there (`TODO 4`). | A red pin where you are, and the map centred on it. |

## Syncing with the lesson

At the end of each step, finished or not, run the commands on the slide, one at a time, in the second terminal. They put aside what you wrote and give you the code of that step:

```bash
git stash -u
git checkout passo-1
flutter pub get
```

Then press `R` in the `flutter run` terminal (hot restart).

To go back to the start: `git stash -u` and then `git checkout main`. To see a step in one place: `git diff main passo-1`, `git diff passo-1 passo-2` and so on.

## What each platform needs

| Where | What | Why |
|---|---|---|
| `android/app/src/main/AndroidManifest.xml` | `INTERNET`, `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION` | Without `INTERNET` the map is grey in a release build. Android 12 lets the person choose an approximate position, so both location permissions are declared. |
| `ios/Runner/Info.plist` | `NSLocationWhenInUseUsageDescription` | Without a reason, iOS never shows the dialog. |
| Chrome | nothing | The browser asks with its own dialog. `openAppSettings` does nothing on the web, so the card hides that button there. |

The map uses the public OpenStreetMap tiles, which are free for small apps as long as the attribution stays visible and the app identifies itself (`userAgentPackageName`). A production app with many users needs a tile provider with a key.

The texts on screen are in Portuguese, like the app in the project; the code and the comments are in English.

API documentation: https://api-pdm.sublimecipher.com/docs

Teacher's content licensed CC BY-NC-SA 4.0.
