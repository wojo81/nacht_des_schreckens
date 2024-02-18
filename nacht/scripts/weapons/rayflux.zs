class Rayflux : Rocket {
    Default {
        scale 0.25;
        health 1;
        radius 5;
        height 5;
        speed 30;
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
        rayl AAAAAAAAAA 1 bright increaseScale;
        rayl AAAAAAAAAA 1 bright decreaseScale;
        loop;

    Death:
        tnt1 a 0 resetScale;
        tfog GFEDCB 1 bright;
        tnt1 a 0 a_explode(80, 256);
        tfog BCDEFG 1 bright;
        stop;
    }
}