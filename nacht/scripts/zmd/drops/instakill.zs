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
}

class zmd_InstakillHandler : EventHandler {
    Array<class<Actor> > unaffected;

    override void worldLoaded(WorldEvent e) {

    }

    override void worldThingDamaged(WorldEvent e) {
        if (e.damage < e.thing.health && e.damageSource.countInv('zmd_InstakillPower') != 0 && self.unaffected.find(e.thing.getClassName()) == self.unaffected.size())
            e.thing.die(e.damageSource, e.inflictor, e.damageFlags, e.damageType);
    }
}