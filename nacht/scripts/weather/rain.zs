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