class WeatherGiver : Weather {
    override void postBeginPlay() {
        super.postBeginPlay();
        Weather.setPrecipitationType('BloodRain');
    }
}

class Rain : Precipitation {
    Default {
        vspeed -15;
    }

    States {
    Spawn:
        rain a 1;
        loop;
    Death:
        rain a 1;
        stop;
    }
}

class WeatherSpawner : EventHandler {
    override void WorldLoaded(WorldEvent e) {
        Actor.spawn('WeatherGiver');
    }
}