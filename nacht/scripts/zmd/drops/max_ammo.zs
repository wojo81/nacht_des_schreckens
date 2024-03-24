class zmd_MaxAmmo : zmd_Drop {
    action void giveAllMaxAmmo() {
        foreach (player : players) {
            let player = zmd_Player(player.mo);
            if (player)
                foreach (weapon : player.heldWeapons)
                    player.giveInventory(weapon.getClassName()..'Ammo', 9999);
        }
    }

    States {
    Spawn:
        tnt1 a 0 downScale;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdefgh 5 bright;
        maxa abcdef 5 bright;

        tnt1 a 35 bright;
        maxa ghabcdefghabcd 5 bright;
        tnt1 a 35 bright;
        maxa efghabc 5 bright;
        tnt1 a 35 bright;
        maxa defghab 5 bright;

        tnt1 a 15 bright;
        maxa cdef 5 bright;
        tnt1 a 15 bright;
        maxa ghab 5 bright;
        tnt1 a 15 bright;
        maxa cdef 5 bright;

        stop;
    Pickup:
        tnt1 a 0 a_startSound("game/maxAmmo", 0, attenuation: attn_none);
        tnt1 a 0 giveAllMaxAmmo;
        tnt1 a 0 {console.printf('Max Ammo!');}
        stop;
    }
}