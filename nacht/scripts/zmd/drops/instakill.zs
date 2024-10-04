class zmd_Instakill : zmd_Drop {
    States {
    Spawn:
        tnt1 a 0 downScale;
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
        tnt1 a 0 a_startSound("game/instakill", 0, attenuation: attn_none);
        tnt1 a 0 giveAll('zmd_InstakillPower');
        tnt1 a 0 {console.printf('Insta-kill!');}
        stop;
    }
}

class zmd_InstakillPower : zmd_Powerup {
    Default {
        Inventory.icon 'ikic';
    }

    override void modifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (!passive && source != self.owner)
            newDamage = source.health;
    }

    override void detachFromOwner() {
        self.owner.a_startSound("game/ikvanish", chanf_local);
        super.detachFromOwner();
    }
}