// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import NavigationNestedMenuController from "./navigation_nested_menu_controller"
import PanoramaController from "./panorama_controller"
import LobbyController from "./lobby_controller"
import GameObserverController from "./game_observer_controller"
import YoutubePlayerController from "./youtube_player_controller"
import ChatController from "./chat_controller"

application.register("navigation", NavigationNestedMenuController)
application.register("panorama", PanoramaController)
application.register("lobby", LobbyController)
application.register("game_observer", GameObserverController)
application.register("youtube_player", YoutubePlayerController)
application.register("chat", ChatController)
