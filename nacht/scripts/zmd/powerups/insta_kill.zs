class zmd_InstaKill : zmd_Powerup {
    Default {
        Inventory.icon 'ikic';
    }
}

class zmd_InstaKillDrop : zmd_Drop {
    States {
    Spawn:
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdefgh 5 bright;
        inst abcdef 5 bright;

        tnt1 a 35 bright;
        inst ghabcdefghabcd 5 bright;
        tnt1 a 35 bright;
        inst efghabc 5 bright;
        tnt1 a 35 bright;
        inst defghab 5 bright;

        tnt1 a 15 bright;
        inst cdef 5 bright;
        tnt1 a 15 bright;
        inst ghab 5 bright;
        tnt1 a 15 bright;
        inst cdef 5 bright;

        stop;
    Pickup:
        tnt1 a 0 a_startSound("game/instaKill", 0, attenuation: attn_none);
        tnt1 a 0 giveAll('zmd_Instakill');
        tnt1 a 0 {console.printf('Insta-kill!');}
        stop;
    }
}