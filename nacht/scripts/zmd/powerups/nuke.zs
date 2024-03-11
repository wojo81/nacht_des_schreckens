class zmd_NukeDrop : zmd_Drop {
    States {
    Spawn:
        nuke a 350 bright;

        tnt1 a 35 bright;
        nuke a 70 bright;
        tnt1 a 35 bright;
        nuke a 35 bright;
        tnt1 a 35 bright;
        nuke a 35 bright;

        tnt1 a 15 bright;
        nuke a 20 bright;
        tnt1 a 15 bright;
        nuke a 20 bright;
        tnt1 a 15 bright;
        tnt1 a 20 bright;

        stop;
    Pickup:
        tnt1 a 0 a_startSound("game/nuke", 0, attenuation: attn_none);
        tnt1 a 0 giveAll('zmd_Points', 400);
        tnt1 a 0 thing_destroy(115, true);
        tnt1 a 0 {console.printf('Ka-boom!');}
        stop;
    }
}