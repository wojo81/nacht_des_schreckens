class zmd_Rayflux : Rocket {
    Default {
        scale 0.25;
        health 1;
        radius 5;
        height 5;
        speed 25;
        damage 40;
        damageType 'Explosion';
        seeSound "weapons/rayflux";
        deathSound "weapons/rayflux_explode";

        -rocketTrail
        +noBlood
    }

    action void increaseScale() {
        scale *= 1.2;
    }

    action void decreaseScale() {
        scale /= 1.2;
    }

    action void resetScale() {
        scale = (1.0, 1.0);
    }

    States {
    Spawn:
        tnt1 a 0;
        rayl aaaaaaaaaa 1 bright increaseScale;
        rayl aaaaaaaaaa 1 bright decreaseScale;
        loop;

    Death:
        tnt1 a 0 resetScale;
        tnt1 aaa 0 increaseScale;
        bal7 ab 2 bright;
        tnt1 a 0 a_explode(80, 256);
        bal7 cde 2 bright;
        stop;
    }
}