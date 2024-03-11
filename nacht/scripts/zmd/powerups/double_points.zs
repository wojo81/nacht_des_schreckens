class zmd_DoublePoints : zmd_Powerup {
    Default {
        Inventory.icon 'dpic';
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_DoublePoints')
            ++self.amount;
        return super.handlePickup(item);
    }
}

class zmd_DoublePointsDrop : zmd_Drop {
    States {
    Spawn:
        inst a 350 bright;

        tnt1 a 35 bright;
        inst a 70 bright;
        tnt1 a 35 bright;
        inst a 35 bright;
        tnt1 a 35 bright;
        inst a 35 bright;

        tnt1 a 15 bright;
        inst a 20 bright;
        tnt1 a 15 bright;
        inst a 20 bright;
        tnt1 a 15 bright;
        tnt1 a 20 bright;

        stop;
    Pickup:
        tnt1 a 0 a_startSound("game/doublePoints", 0, attenuation: attn_none);
        tnt1 a 0 giveAll('zmd_DoublePoints');
        tnt1 a 0 {console.printf('Double Points!');}
        stop;
    }
}