class zmd_FireSale : zmd_Drop {
    void spawnBoxes() {
        zmd_MysteryBoxHandler.fetch().spawnAllBoxes();
    }

    States {
    Spawn:
        tnt1 a 0 downScale;
        maxa a 350 bright;

        tnt1 a 35 bright;
        maxa a 70 bright;
        tnt1 a 35 bright;
        maxa a 35 bright;
        tnt1 a 35 bright;
        maxa a 35 bright;

        tnt1 a 15 bright;
        maxa a 20 bright;
        tnt1 a 15 bright;
        maxa a 20 bright;
        tnt1 a 15 bright;
        tnt1 a 20 bright;

        stop;
    Pickup:
        tnt1 a 0 a_startSound("game/fire_sale", 0, attenuation: attn_none);
        tnt1 a 0 giveAll('zmd_FireSalePower');
        tnt1 a 0 spawnBoxes;
        tnt1 a 0 {console.printf('Fire Sale!');}
        stop;
    }
}

class zmd_FireSalePower : zmd_Powerup {
    Default {
        Inventory.icon 'fsic';
    }

    override void detachFromOwner() {
        if (self.owner.playerNumber() == 0)
            zmd_MysteryBoxHandler.fetch().removeAllBoxes();
    }
}